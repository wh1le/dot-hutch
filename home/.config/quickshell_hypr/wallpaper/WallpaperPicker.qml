import QtQuick
import QtQuick.Layouts
import QtCore
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io
import "../modules/common"
import "../modules/common/widgets"
import ".."

// Cherry-picked from https://github.com/ilyamiro/nixos-configuration

Item {
    id: window

    // Theme color aliases (mapped from Appearance)
    readonly property color _mantle: Appearance.colors.colLayer0
    readonly property color _surface1: Appearance.colors.colLayer2
    readonly property color _surface2: Appearance.colors.colLayer3
    readonly property color _text: Appearance.colors.colOnLayer0

    // -------------------------------------------------------------------------
    // PROPERTIES & IPC RECEIVER
    // -------------------------------------------------------------------------
    property string widgetArg: ""
    property string targetWallName: ""
    property bool initialFocusSet: false
    property int visibleItemCount: -1
    property int scrollAccum: 0
    property int scrollThreshold: 300

    // Filter System Properties
    property string currentFilter: "All"
    property string _lastFilter: "All"
    property string searchQuery: ""
    property bool isOnlineSearch: false
    property bool isSearchPaused: false
    property bool hasSearched: false
    property var colorMap: ({})
    property int cacheVersion: 0

    // Download and Status Tracking Properties
    property bool isDownloadingWallpaper: false
    property string currentDownloadName: ""

    // Reactive Status Properties
    property bool isStartup: localFolderModel.status === FolderListModel.Loading || srcModelDefault.status === FolderListModel.Loading
    property bool isReady: visible && localFolderModel.status === FolderListModel.Ready
    property bool isSearchActive: window.currentFilter === "Search" && window.hasSearched && searchFolderModel.status === FolderListModel.Loading

    // Memory Properties for Search
    property string lastSearchName: ""
    property bool isModelChanging: false
    property bool searchIndexRestored: false

    // Lock scrolling/interaction while actively streaming search results.
    property bool isScrollingBlocked: window.currentFilter === "Search" && window.hasSearched && window.isSearchActive && !window.isSearchPaused
    property bool jumpToLastOnFilterChange: false

    readonly property var filterData: [
        { name: "All", hex: "", label: "All" },
        { name: "Video", hex: "", label: "Vid" },
        { name: "Red", hex: "#FF4500", label: "" },
        { name: "Orange", hex: "#FFA500", label: "" },
        { name: "Yellow", hex: "#FFD700", label: "" },
        { name: "Green", hex: "#32CD32", label: "" },
        { name: "Blue", hex: "#1E90FF", label: "" },
        { name: "Purple", hex: "#8A2BE2", label: "" },
        { name: "Pink", hex: "#FF69B4", label: "" },
        { name: "Monochrome", hex: "#A9A9A9", label: "" },
        { name: "Search", hex: "", label: "Search" }
    ]

    // -------------------------------------------------------------------------
    // GLOBAL ACTION: APPLY WALLPAPER
    // -------------------------------------------------------------------------
    function applyWallpaper(safeFileName, isVideo) {
        if (!safeFileName) return;

        window.targetWallName = safeFileName
        let cleanName = window.getCleanName(safeFileName)
        const escapeBash = (str) => String(str).replace(/(["\\$`])/g, '\\$1');

        if (window.currentFilter === "Search" && window.hasSearched) {
            let alreadyExists = window.isDownloaded(safeFileName);
            let destFile = window.baseDir + "/default/" + safeFileName;
            let finalThumb = decodeURIComponent(window.thumbDir.replace("file://", "")) + "/" + safeFileName;
            let tempThumb = decodeURIComponent(window.searchDir.replace("file://", "")) + "/" + safeFileName;
            let mapFile = Quickshell.env("HOME") + "/.cache/wallpaper_picker/search_map.txt";

            if (alreadyExists) {
                let resolvedPath = window.resolveSourcePath(safeFileName);
                Quickshell.execDetached([window.applyScript, resolvedPath]);
            } else {
                window.isDownloadingWallpaper = true;
                window.currentDownloadName = safeFileName;

                const downloadScript = `
                    export SAFE_NAME="${escapeBash(safeFileName)}"
                    export DEST_FILE="${escapeBash(destFile)}"
                    export FINAL_THUMB="${escapeBash(finalThumb)}"
                    export TEMP_THUMB="${escapeBash(tempThumb)}"
                    export MAP_FILE="${escapeBash(mapFile)}"
                    export APPLY_SCRIPT="${escapeBash(window.applyScript)}"

                    (
                        URL=$(awk -F'|' -v fname="$SAFE_NAME" '$1 == fname {print $2; exit}' "$MAP_FILE")
                        if [ -n "$URL" ]; then
                            curl -s -L -A "Mozilla/5.0" "$URL" -o "$DEST_FILE.tmp"

                            if file "$DEST_FILE.tmp" | grep -iq "webp"; then
                                magick "$DEST_FILE.tmp" "$DEST_FILE"
                                rm -f "$DEST_FILE.tmp"
                            else
                                mv "$DEST_FILE.tmp" "$DEST_FILE"
                            fi

                            cp "$TEMP_THUMB" "$FINAL_THUMB"
                            magick "$DEST_FILE" -resize x420 -quality 70 "$FINAL_THUMB"

                            "$APPLY_SCRIPT" "$DEST_FILE"
                        fi
                    ) >/dev/null 2>&1 & disown
                `;
                Quickshell.execDetached(["bash", "-c", downloadScript]);
            }
            return;
        }

        const originalFile = window.resolveSourcePath(safeFileName)
        Quickshell.execDetached([window.applyScript, originalFile]);
        GlobalStates.wallpaperPickerOpen = false;
    }

    // -------------------------------------------------------------------------
    // PERSISTENT SETTINGS
    // -------------------------------------------------------------------------
    Settings {
        id: searchState
        category: "QS_WallpaperPicker"
        property string query: ""
        property bool searched: false
        property string lastName: ""
    }

    onIsSearchPausedChanged: {
        Quickshell.execDetached(["bash", "-c", "echo '" + (isSearchPaused ? "pause" : "run") + "' > /tmp/ddg_search_control"]);
    }

    // -------------------------------------------------------------------------
    // VISIBILITY LOGIC
    // -------------------------------------------------------------------------
    onVisibleChanged: {
        if (!visible) {
            window.initialFocusSet = false;
            window.searchIndexRestored = false;

            if (window.hasSearched) {
                window.isSearchPaused = true;
            }
        } else {
            searchInput.forceActiveFocus();
            // Re-apply focus rules when re-opening
            if (window.currentFilter !== "Search") {
                window.applyFilters(true);
            } else if (window.hasSearched) {
                window.searchIndexRestored = false;
                window.isSearchPaused = true;
                window.trySearchFocus();
                window.syncSearchModel();
            }
        }
    }

    // -------------------------------------------------------------------------
    // NOTIFICATION & LABEL STATE LOGIC
    // -------------------------------------------------------------------------
    property bool isLoading: localFolderModel.status === FolderListModel.Loading ||
                             srcModelDefault.status === FolderListModel.Loading ||
                             (window.currentFilter === "Search" && searchFolderModel.status === FolderListModel.Loading)

    property bool showSpinner: window.isDownloadingWallpaper ||
                               (window.currentFilter === "Search" && window.hasSearched && !window.isSearchPaused) ||
                               (window.currentFilter !== "Search" && window.isLoading)

    property string currentNotification: {
        if (window.isDownloadingWallpaper) return "Downloading wallpaper...";

        if (window.currentFilter === "Search") {
            if (!window.hasSearched) return "Type something to search...";
            if (window.isSearchPaused) return "Search Paused";
            if (window.visibleItemCount === 0) return "Searching DDG (FHD+)...";
            // If it's not paused and has items, it is actively generating thumbnails
            return "Generating thumbnails...";
        }

        if (isLoading) return "Generating thumbnails...";
        if (window.visibleItemCount === 0) return "No wallpapers found";

        if (window.currentFilter === "All") return "";
        if (window.currentFilter === "Video") return "Videos";

        return window.currentFilter;
    }

    // Block the notification flag during initial load to stop UI shifting
    property bool showNotification: !window.isStartup && currentNotification !== ""

    function getCleanName(name) {
        if (!name) return "";
        let clean = String(name);
        if (clean.startsWith("000_")) clean = clean.substring(4);
        if (clean.startsWith("AAA_")) clean = clean.substring(4);
        return clean;
    }

    function isFav(name) {
        return String(name).startsWith("AAA_");
    }

    function isDownloaded(name) {
        if (!name) return false;
        for (let i = 0; i < srcModelDefault.count; i++) {
            if (srcModelDefault.get(i, "fileName") === name) return true;
        }
        for (let i = 0; i < srcModelFav.count; i++) {
            if (srcModelFav.get(i, "fileName") === name) return true;
        }
        return false;
    }

    function resolveSourcePath(name) {
        if (!name) return "";
        let clean = window.getCleanName(name);
        if (window.isFav(name))
            return window.baseDir + "/fav/" + clean;
        return window.baseDir + "/default/" + clean;
    }

    onWidgetArgChanged: {
        if (widgetArg !== "") {
            targetWallName = widgetArg;
            initialFocusSet = false;
            tryFocus();
        }
    }

    // Force layouts and positioning *before* setting index to avoid animation conflicts
    function executeFocusRestore(targetIndex, isSearchRestore, requirePositioning) {
        let targetModel = window.getModelForFilter(window.currentFilter);

        if (targetIndex !== -1 && targetIndex < targetModel.count) {
            window.isModelChanging = true;

            if (requirePositioning) {
                view.forceLayout();
                view.positionViewAtIndex(targetIndex, ListView.Center);
            }

            view.currentIndex = targetIndex;

            if (isSearchRestore) {
                window.searchIndexRestored = true;
            }

            window.isModelChanging = false;
            window.initialFocusSet = true;
        } else if (isSearchRestore) {
            window.searchIndexRestored = true;
        }
    }

    function tryFocus() {
        if (initialFocusSet) return;

        if (localProxyModel.count > 0) {
            let foundIndex = -1;
            let cleanTarget = window.getCleanName(targetWallName);

            if (cleanTarget !== "") {
                for (let i = 0; i < localProxyModel.count; i++) {
                    let fname = localProxyModel.get(i).fileName || "";
                    if (window.getCleanName(fname) === cleanTarget) {
                        foundIndex = i;
                        break;
                    }
                }
            }

            let finalIndex = foundIndex !== -1 ? foundIndex : 0;
            window.executeFocusRestore(finalIndex, false, true);
        }
    }

    function trySearchFocus() {
        if (window.searchIndexRestored || searchProxyModel.count === 0) return;

        if (window.lastSearchName === "") {
             window.searchIndexRestored = true;
             return;
        }

        for (let i = 0; i < searchProxyModel.count; i++) {
            let fname = searchProxyModel.get(i).fileName || "";
            if (fname === window.lastSearchName) {
                window.executeFocusRestore(i, true, true);
                return;
            }
        }

        if (searchFolderModel.status === FolderListModel.Ready && searchProxyModel.count === searchFolderModel.count) {
             window.searchIndexRestored = true;
        }
    }

    // Guarantee the exact model is queried regardless of reactive binding propagation delay
    function getModelForFilter(filter) {
        return filter === "Search" ? searchProxyModel : localProxyModel;
    }

    function updateVisibleCount() {
        let targetModel = window.getModelForFilter(window.currentFilter);

        if (!targetModel || targetModel.count === 0) {
            window.visibleItemCount = 0;
            return;
        }
        let count = 0;
        for (let i = 0; i < targetModel.count; i++) {
            let fname = targetModel.get(i).fileName || "";
            let isVid = fname.startsWith("000_");
            if (checkItemMatchesFilter(fname, isVid, window.cacheVersion, window.currentFilter)) {
                count++;
            }
        }
        window.visibleItemCount = count;
    }

    function triggerOnlineSearch() {
        if (searchInput.text.trim() === "") return;

        window.isModelChanging = true;
        searchProxyModel.clear();
        window.lastSearchName = "";
        searchState.lastName = "";

        if (window.currentFilter === "Search") {
            view.currentIndex = 0;
            view.positionViewAtIndex(0, ListView.Center);
        }
        window.isModelChanging = false;

        window.searchIndexRestored = true;
        window.isOnlineSearch = true;
        window.hasSearched = true;

        // Force count to 0 instantly to prevent "Generating thumbnails..." from flashing
        window.visibleItemCount = 0;

        searchState.searched = true;
        searchState.query = searchInput.text.trim();

        window.isSearchPaused = false;
        window.searchQuery = searchInput.text.trim();

        let rawSearchDir = decodeURIComponent(window.searchDir.replace(/^file:\/\//, ""));
        let scriptPath = decodeURIComponent(Qt.resolvedUrl("ddg_search.sh").toString().replace(/^file:\/\//, ""));

        const cmd = `
            exec > /tmp/qs_ddg_run.log 2>&1
            echo "=== QML Shell Handoff Successful ==="
            export PATH=$PATH:/run/current-system/sw/bin

            echo "Gracefully stopping old processes..."
            echo 'stop' > /tmp/ddg_search_control

            # Safely kill old bash scripts without killing this wrapper
            for p in $(pgrep -f ddg_search.sh); do
                if [ "$p" != "$$" ] && [ "$p" != "$BASHPID" ]; then
                    kill -9 $p 2>/dev/null || true
                fi
            done
            pkill -f "[g]et_ddg_links.py" || true
            sleep 0.2

            echo "Clearing old cache..."
            rm -rf "${rawSearchDir}"/* || true
            rm -f "${rawSearchDir}/../search_map.txt" || true

            echo "Setting control state back to run..."
            echo 'run' > /tmp/ddg_search_control

            echo "Executing new search pipeline..."
            bash "${scriptPath}" "${window.searchQuery}" &
        `;

        Quickshell.execDetached(["bash", "-c", cmd]);

        searchInput.textInput.focus = false;
        view.forceActiveFocus();
    }

    readonly property string homeDir: "file://" + Quickshell.env("HOME")
    readonly property string thumbDir: homeDir + "/.cache/wallpaper_picker/thumbs"
    readonly property string searchDir: homeDir + "/.cache/wallpaper_picker/search_thumbs"
    readonly property string baseDir: Config.options.wallpaper.baseDir
    readonly property string applyScript: Config.options.wallpaper.applyScript

    readonly property var transitions: ["grow", "outer", "any", "wipe", "wave", "pixel", "center"]

    readonly property int itemWidth: 400
    readonly property int itemHeight: 420
    readonly property int borderWidth: 3
    readonly property int spacing: 10
    readonly property real skewFactor: 0

    // Mouse input UX throttle (Not a layout logic timer)
    Timer {
        id: scrollThrottle
        interval: 150
    }

    // -------------------------------------------------------------------------
    // COLOR FILTERING MATH & NATIVE FILE SYSTEM CACHE
    // -------------------------------------------------------------------------
    function getHexBucket(hexStr) {
        if (!hexStr) return "Monochrome";

        hexStr = String(hexStr).trim().replace(/#/g, '');
        if (hexStr.length > 6) hexStr = hexStr.substring(0, 6);
        if (hexStr.length !== 6) return "Monochrome";

        let r = parseInt(hexStr.substring(0,2), 16) / 255;
        let g = parseInt(hexStr.substring(2,4), 16) / 255;
        let b = parseInt(hexStr.substring(4,6), 16) / 255;

        if (isNaN(r) || isNaN(g) || isNaN(b)) return "Monochrome";

        let max = Math.max(r, g, b), min = Math.min(r, g, b);
        let d = max - min;

        let h = 0;
        let s = max === 0 ? 0 : d / max;
        let v = max;

        if (max !== min) {
            if (max === r) {
                h = (g - b) / d + (g < b ? 6 : 0);
            } else if (max === g) {
                h = (b - r) / d + 2;
            } else {
                h = (r - g) / d + 4;
            }
            h /= 6;
        }
        h = h * 360;

        if (s < 0.05 || v < 0.08) return "Monochrome";

        if (h >= 345 || h < 15) return "Red";
        if (h >= 15 && h < 45) return "Orange";
        if (h >= 45 && h < 75) return "Yellow";
        if (h >= 75 && h < 165) return "Green";
        if (h >= 165 && h < 260) return "Blue";
        if (h >= 260 && h < 315) return "Purple";
        if (h >= 315 && h < 345) return "Pink";

        return "Monochrome";
    }

    function checkItemMatchesFilter(fileName, isVid, cv, filter) {
        // fzf text search takes priority
        if (searchInput.fzfMatches !== null) {
            if (!(String(fileName) in searchInput.fzfMatches)) return false;
        }

        if (filter === "Search") return true;

        if (filter === "All") return true;
        if (filter === "Video") return isVid;

        let hexColor = window.colorMap[String(fileName)];
        if (!hexColor) return filter === "Monochrome";

        return window.getHexBucket(hexColor) === filter;
    }

    FolderListModel {
        id: markerModel
        folder: "file://" + Quickshell.env("HOME") + "/.cache/wallpaper_picker/colors_markers"
        showDirs: false
        nameFilters: ["*_HEX_*"]

        onCountChanged: window.processMarkers()
        onStatusChanged: {
            if (status === FolderListModel.Ready) window.processMarkers()
        }
    }

    FolderListModel {
        id: srcModelDefault
        folder: "file://" + window.baseDir + "/default"
        nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.webp"]
        showDirs: false

        onCountChanged: {
            if (window.isDownloadingWallpaper && window.isDownloaded(window.currentDownloadName)) {
                window.isDownloadingWallpaper = false;
            }
        }
    }

    FolderListModel {
        id: srcModelFav
        folder: "file://" + window.baseDir + "/fav"
        nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.webp"]
        showDirs: false
    }

    function processMarkers() {
        let newMap = {};
        for (let i = 0; i < markerModel.count; i++) {
            let markerName = markerModel.get(i, "fileName") || "";
            if (!markerName) continue;

            let splitIdx = markerName.lastIndexOf("_HEX_");
            if (splitIdx !== -1) {
                let fName = markerName.substring(0, splitIdx);
                let hexCode = markerName.substring(splitIdx + 5);
                newMap[fName] = "#" + hexCode;
            }
        }
        window.colorMap = newMap;
        window.cacheVersion++;
        window.updateVisibleCount();
    }

    function triggerColorExtraction() {
        const extractScript = `
            COLOR_DIR="$HOME/.cache/wallpaper_picker/colors_markers"
            THUMBS="$HOME/.cache/wallpaper_picker/thumbs"
            CSV="$HOME/.cache/wallpaper_picker/colors.csv"

            mkdir -p "$COLOR_DIR"

            if [ -f "$CSV" ]; then
                while IFS=, read -r fname hexcode; do
                    cleanhex=$(echo "$hexcode" | tr -d '\r#' | cut -c 1-6)
                    if [ -n "$cleanhex" ] && [ -n "$fname" ]; then
                        touch "$COLOR_DIR/$fname""_HEX_$cleanhex" 2>/dev/null
                    fi
                done < "$CSV"
                mv "$CSV" "$CSV.bak" 2>/dev/null
            fi

            if command -v magick &> /dev/null; then CMD="magick"; else CMD="convert"; fi

            for file in "$THUMBS"/*; do
                if [ -f "$file" ]; then
                    filename=$(basename "$file")
                    found=0
                    for marker in "$COLOR_DIR/$filename"_HEX_*; do
                        if [ -e "$marker" ]; then found=1; break; fi
                    done

                    if [ $found -eq 0 ]; then
                        hex=$($CMD "$file" -modulate 100,200 -resize "1x1^" -gravity center -extent 1x1 -depth 8 -format "%[hex:p{0,0}]" info:- 2>/dev/null | grep -oE '[0-9A-Fa-f]{6}' | head -n 1)
                        if [ -n "$hex" ]; then
                            touch "$COLOR_DIR/$filename""_HEX_$hex"
                        fi
                    fi
                fi
            done
        `;
        Quickshell.execDetached(["bash", "-c", extractScript]);
    }

    function stepToNextValidIndex(direction) {
        let targetModel = window.getModelForFilter(window.currentFilter);
        if (!targetModel || targetModel.count === 0) return;

        let start = view.currentIndex;
        let found = -1;

        if (direction === 1) {
            for (let i = start + 1; i < targetModel.count; i++) {
                let fname = targetModel.get(i).fileName || "";
                let isVid = fname.startsWith("000_");
                if (checkItemMatchesFilter(fname, isVid, window.cacheVersion, window.currentFilter)) {
                    found = i; break;
                }
            }
        } else {
            for (let i = start - 1; i >= 0; i--) {
                let fname = targetModel.get(i).fileName || "";
                let isVid = fname.startsWith("000_");
                if (checkItemMatchesFilter(fname, isVid, window.cacheVersion, window.currentFilter)) {
                    found = i; break;
                }
            }
        }

        if (found !== -1) {
            view.currentIndex = found;
            return;
        }

        let filterOrder = ["All", "Video", "Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Pink", "Monochrome"];
        let currentFilterIdx = filterOrder.indexOf(window.currentFilter);

        if (currentFilterIdx === -1) {
            let current = start;
            for (let i = 0; i < targetModel.count; i++) {
                current = (current + direction + targetModel.count) % targetModel.count;
                let fname = targetModel.get(current).fileName || "";
                let isVid = fname.startsWith("000_");

                if (checkItemMatchesFilter(fname, isVid, window.cacheVersion, window.currentFilter)) {
                    view.currentIndex = current;
                    return;
                }
            }
            return;
        }

        let nextFilterIdx = currentFilterIdx + direction;

        if (nextFilterIdx >= 0 && nextFilterIdx < filterOrder.length) {
            window.jumpToLastOnFilterChange = (direction === -1);
            window.currentFilter = filterOrder[nextFilterIdx];
        }
    }

    function cycleFilter(direction) {
        let currentIdx = -1;
        for (let i = 0; i < window.filterData.length; i++) {
            if (window.filterData[i].name === window.currentFilter) {
                currentIdx = i;
                break;
            }
        }

        if (currentIdx !== -1) {
            let nextIdx = (currentIdx + direction + window.filterData.length) % window.filterData.length;
            window.currentFilter = window.filterData[nextIdx].name;
        }
    }

    function applyFilters(forceSnap) {
        let targetModel = window.getModelForFilter(window.currentFilter);

        if (!targetModel || targetModel.count === 0) {
            window.updateVisibleCount();
            return;
        }

        if (window.currentFilter === "Search") {
            window.updateVisibleCount();
            return;
        }

        let firstValidIndex = -1;
        let lastValidIndex = -1;
        let cleanTarget = window.getCleanName(window.targetWallName);
        let targetIndex = -1;

        for (let i = 0; i < targetModel.count; i++) {
            let fname = targetModel.get(i).fileName || "";
            let isVid = fname.startsWith("000_");

            if (checkItemMatchesFilter(fname, isVid, window.cacheVersion, window.currentFilter)) {
                if (firstValidIndex === -1) {
                    firstValidIndex = i;
                }
                lastValidIndex = i;

                if (cleanTarget !== "" && window.getCleanName(fname) === cleanTarget) {
                    targetIndex = i;
                }
            }
        }

        let indexToFocus = -1;

        if (targetIndex !== -1) {
             indexToFocus = targetIndex;
        } else if (window.jumpToLastOnFilterChange && lastValidIndex !== -1) {
            indexToFocus = lastValidIndex;
        } else if (firstValidIndex !== -1) {
            indexToFocus = firstValidIndex;
        }

        window.jumpToLastOnFilterChange = false;

        if (indexToFocus !== -1) {
            window.executeFocusRestore(indexToFocus, false, forceSnap === true);
        }

        window.updateVisibleCount();
    }

    onCurrentFilterChanged: {
        window.isModelChanging = true;
        let returningFromSearch = (window._lastFilter === "Search" && window.currentFilter !== "Search");
        window._lastFilter = window.currentFilter;

        // Erase search memory status instantly when we abandon the tab so it triggers fresh when we return
        if (returningFromSearch) {
             window.searchIndexRestored = false;
        }

        // Defer routing logic to ensure the ListView's internal model pointer has fully swapped
        // We keep isModelChanging true across the closure to protect from ListView default index resets
        Qt.callLater(() => {
            // Force focus on the wallpaper list so shortcuts work immediately
            view.forceActiveFocus();

            if (window.currentFilter === "Search") {
                if (window.hasSearched) {
                    window.searchIndexRestored = false;
                    window.trySearchFocus();
                }
            } else {
                window.applyFilters(returningFromSearch);
            }
            window.isModelChanging = false;
        });
    }

    // -------------------------------------------------------------------------
    // SHORTCUTS
    // -------------------------------------------------------------------------
    Shortcut {
        sequence: "Left";
        enabled: !window.isScrollingBlocked
        onActivated: window.stepToNextValidIndex(-1)
    }
    Shortcut {
        sequence: "Right";
        enabled: !window.isScrollingBlocked
        onActivated: window.stepToNextValidIndex(1)
    }

    Shortcut {
        sequence: "Return"
        enabled: !searchInput.textInput.activeFocus && !window.isScrollingBlocked
        onActivated: {
            let targetModel = window.getModelForFilter(window.currentFilter);
            if (view.currentIndex >= 0 && view.currentIndex < targetModel.count) {
                let fname = targetModel.get(view.currentIndex).fileName;
                if (fname) {
                    let isVid = String(fname).startsWith("000_");
                    window.applyWallpaper(String(fname), isVid);
                }
            }
        }
    }

    Shortcut { sequence: "Escape"; onActivated: { if (window.currentFilter === "Search") { window.currentFilter = "All"; } else { GlobalStates.wallpaperPickerOpen = false; } } }
    Shortcut { sequence: "Tab"; onActivated: window.cycleFilter(1) }
    Shortcut { sequence: "Backtab"; onActivated: window.cycleFilter(-1) }

    // -------------------------------------------------------------------------
    // CONTENT & DUAL MODELS
    // -------------------------------------------------------------------------
    ListModel { id: localProxyModel }
    ListModel { id: searchProxyModel }

    readonly property var activeModel: window.currentFilter === "Search" ? searchProxyModel : localProxyModel

    // Local Wallpapers Model Logic
    FolderListModel {
        id: localFolderModel
        folder: window.thumbDir
        nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.webp", "*.gif", "*.mp4", "*.mkv", "*.mov", "*.webm"]
        showDirs: false
        sortField: FolderListModel.Name

        onCountChanged: window.syncLocalModel()
        onStatusChanged: { if (status === FolderListModel.Ready) window.syncLocalModel() }
    }

    function syncLocalModel() {
        let startIdx = localProxyModel.count;
        let endIdx = localFolderModel.count;

        if (endIdx < startIdx) {
            window.isModelChanging = true;
            localProxyModel.clear();
            startIdx = 0;
            window.isModelChanging = false;
        }

        for (let i = startIdx; i < endIdx; i++) {
            let fn = localFolderModel.get(i, "fileName");
            let fu = localFolderModel.get(i, "fileUrl");
            if (fn !== undefined) {
                localProxyModel.append({ "fileName": fn, "fileUrl": String(fu) });
            }
        }

        if (window.currentFilter !== "Search") window.updateVisibleCount();

        if (!window.initialFocusSet && window.currentFilter !== "Search" && localProxyModel.count > 0) {
            window.tryFocus();
        }
    }

    // Search Thumbnails Model Logic
    FolderListModel {
        id: searchFolderModel
        folder: window.searchDir
        nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.webp", "*.gif", "*.mp4", "*.mkv", "*.mov", "*.webm"]
        showDirs: false
        sortField: FolderListModel.Name

        onFolderChanged: {
            window.isModelChanging = true;
            searchProxyModel.clear()
            window.isModelChanging = false;
        }

        onCountChanged: window.syncSearchModel()
        onStatusChanged: { if (status === FolderListModel.Ready) window.syncSearchModel() }
    }

    function syncSearchModel() {
        let startIdx = searchProxyModel.count;
        let endIdx = searchFolderModel.count;

        if (endIdx < startIdx) {
            window.isModelChanging = true;
            searchProxyModel.clear();
            startIdx = 0;
            window.isModelChanging = false;
        }

        for (let i = startIdx; i < endIdx; i++) {
            let fn = searchFolderModel.get(i, "fileName");
            let fu = searchFolderModel.get(i, "fileUrl");
            if (fn !== undefined) {
                searchProxyModel.append({ "fileName": fn, "fileUrl": String(fu) });
            }
        }

        if (window.currentFilter === "Search") window.updateVisibleCount();

        if (window.currentFilter === "Search" && window.hasSearched) {
            if (!window.searchIndexRestored) {
                window.trySearchFocus();
            }

            if (window.isScrollingBlocked && startIdx === 0 && searchProxyModel.count > 0 && window.lastSearchName === "") {
                view.forceLayout();
                view.currentIndex = 0;
                view.positionViewAtIndex(0, ListView.Center);
            }
        }
    }

    ListView {
        id: view
        anchors.fill: parent
        anchors.topMargin: 110
        anchors.bottomMargin: 80

        opacity: window.isReady ? 1.0 : 0.0

        Behavior on opacity { NumberAnimation { duration: 600; easing.type: Easing.OutQuart } }

        spacing: 0
        orientation: ListView.Horizontal
        clip: true

        interactive: !window.isScrollingBlocked
        cacheBuffer: 2000

        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: (width / 2) - ((window.itemWidth * 1.5 + window.spacing) / 2)
        preferredHighlightEnd: (width / 2) + ((window.itemWidth * 1.5 + window.spacing) / 2)

        highlightMoveDuration: window.initialFocusSet ? 400 : 0
        focus: true

        onCurrentIndexChanged: {
            // Guard: completely ignore index resets if the view's internal model doesn't match the search state yet
            if (view.model !== searchProxyModel || window.currentFilter !== "Search") return;

            if (!window.isModelChanging && window.hasSearched && window.searchIndexRestored) {
                if (currentIndex >= 0 && currentIndex < searchProxyModel.count) {
                    let fname = searchProxyModel.get(currentIndex).fileName;
                    if (fname !== undefined && fname !== "") {
                        window.lastSearchName = String(fname);
                        searchState.lastName = String(fname);
                    }
                }
            }
        }

        add: Transition {
            enabled: window.initialFocusSet
            ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 400; easing.type: Easing.OutCubic }
                NumberAnimation { property: "scale"; from: 0.5; to: 1; duration: 400; easing.type: Easing.OutBack }
            }
        }
        addDisplaced: Transition {
            enabled: window.initialFocusSet
            NumberAnimation { property: "x"; duration: 400; easing.type: Easing.OutCubic }
        }

        header: Item { width: Math.max(0, (view.width / 2) - ((window.itemWidth * 1.5) / 2)) }
        footer: Item { width: Math.max(0, (view.width / 2) - ((window.itemWidth * 1.5) / 2)) }

        model: window.activeModel

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton

            onWheel: (wheel) => {
                if (window.isScrollingBlocked) {
                    wheel.accepted = true;
                    return;
                }

                if (scrollThrottle.running) {
                   wheel.accepted = true
                   return
                }

                let dx = wheel.angleDelta.x
                let dy = wheel.angleDelta.y
                let delta = Math.abs(dx) > Math.abs(dy) ? dx : dy

                scrollAccum += delta

                if (Math.abs(scrollAccum) >= scrollThreshold) {
                    window.stepToNextValidIndex(scrollAccum > 0 ? -1 : 1)
                    scrollAccum = 0
                    scrollThrottle.start()
                }

                wheel.accepted = true
            }
        }

        delegate: Item {
            id: delegateRoot

            readonly property string safeFileName: fileName !== undefined ? String(fileName) : ""

            readonly property bool isCurrent: ListView.isCurrentItem && !window.isScrollingBlocked
            readonly property bool isFakeSelected: window.isScrollingBlocked && index === 0
            readonly property bool isVisuallyEnlarged: isCurrent || isFakeSelected

            readonly property bool isVideo: safeFileName.startsWith("000_")
            readonly property bool matchesFilter: window.checkItemMatchesFilter(safeFileName, isVideo, window.cacheVersion, window.currentFilter)

            readonly property real targetWidth: isVisuallyEnlarged ? (window.itemWidth * 1.5) : (window.itemWidth * 0.5)
            readonly property real targetHeight: isVisuallyEnlarged ? (window.itemHeight + 30) : window.itemHeight

            width: matchesFilter ? (targetWidth + window.spacing) : 0
            visible: width > 0.1 || opacity > 0.01
            opacity: matchesFilter ? (isVisuallyEnlarged ? 1.0 : 0.6) : 0.0

            scale: matchesFilter ? 1.0 : 0.5

            height: matchesFilter ? targetHeight : 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 15

            z: isVisuallyEnlarged ? 10 : 1

            Behavior on scale { enabled: window.initialFocusSet; NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
            Behavior on width { enabled: window.initialFocusSet; NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
            Behavior on height { enabled: window.initialFocusSet; NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
            Behavior on opacity { enabled: window.initialFocusSet; NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

            Item {
                anchors.centerIn: parent

                width: parent.width > 0 ? parent.width * (targetWidth / (targetWidth + window.spacing)) : 0
                height: parent.height

                MouseArea {
                    anchors.fill: parent
                    enabled: delegateRoot.matchesFilter && !window.isScrollingBlocked
                    onClicked: {
                        view.currentIndex = index
                        window.applyWallpaper(delegateRoot.safeFileName, delegateRoot.isVideo)
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    color: "black"
                    border.color: Qt.rgba(window._surface1.r, window._surface1.g, window._surface1.b, 0.5)
                    border.width: 2
                    radius: 4
                    clip: true

                    Image {
                        anchors.fill: parent
                        anchors.margins: 2
                        fillMode: Image.PreserveAspectCrop
                        source: fileUrl !== undefined ? fileUrl : ""
                        asynchronous: true
                    }

                    Rectangle {
                        visible: delegateRoot.isVideo
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.margins: 10
                        width: 32
                        height: 32
                        radius: 6
                        color: "#60000000"

                        Canvas {
                            anchors.fill: parent
                            anchors.margins: 8
                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.fillStyle = "#EEFFFFFF";
                                ctx.beginPath();
                                ctx.moveTo(4, 0);
                                ctx.lineTo(14, 8);
                                ctx.lineTo(4, 16);
                                ctx.closePath();
                                ctx.fill();
                            }
                        }
                    }
                }
            }
        }
    }

    // -------------------------------------------------------------------------
    // FLOATING FILTER BAR & INLINE NOTIFICATION DRAWER
    // -------------------------------------------------------------------------
    Rectangle {
        id: filterBarBackground
        anchors.top: parent.top

        anchors.topMargin: window.isReady ? 40 : -100
        opacity: window.isReady ? 1.0 : 0.0
        Behavior on anchors.topMargin { NumberAnimation { duration: 600; easing.type: Easing.OutExpo } }
        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }

        anchors.horizontalCenter: parent.horizontalCenter
        z: 20
        height: 56
        width: filterRow.width + 24
        radius: 14

        color: Qt.rgba(window._mantle.r, window._mantle.g, window._mantle.b, 0.90)
        border.color: Qt.rgba(window._surface2.r, window._surface2.g, window._surface2.b, 0.8)
        border.width: 1

        Row {
            id: filterRow
            anchors.centerIn: parent
            spacing: 8

            Rectangle {
                id: notifDrawer
                height: 44
                property real paddingLeft: window.showSpinner ? 40 : 16
                property real targetWidth: window.showNotification ? Math.min(notifTextDrawer.implicitWidth + paddingLeft + 20, 300) : 0
                width: targetWidth
                visible: width > 0.1
                radius: 10
                clip: true

                color: window.showNotification ? Qt.rgba(window._surface2.r, window._surface2.g, window._surface2.b, 0.5) : "transparent"
                border.color: window.showNotification ? Qt.rgba(window._surface1.r, window._surface1.g, window._surface1.b, 0.8) : "transparent"
                border.width: 1

                Behavior on width {
                    NumberAnimation { duration: 600; easing.type: Easing.OutBack; easing.overshoot: 0.5 }
                }
                Behavior on color { ColorAnimation { duration: 400 } }
                Behavior on border.color { ColorAnimation { duration: 400 } }

                Item {
                    visible: window.showSpinner
                    width: 44
                    height: 44
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    Canvas {
                        id: notifSpinner
                        width: 14; height: 14
                        anchors.centerIn: parent
                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.reset();
                            ctx.lineWidth = 2;
                            ctx.strokeStyle = Qt.rgba(window._text.r, window._text.g, window._text.b, 0.3);
                            ctx.beginPath();
                            ctx.arc(7, 7, 5, 0, Math.PI * 2);
                            ctx.stroke();

                            ctx.strokeStyle = Qt.rgba(window._text.r, window._text.g, window._text.b, 0.9);
                            ctx.beginPath();
                            ctx.arc(7, 7, 5, 0, Math.PI * 0.5);
                            ctx.stroke();
                        }
                        RotationAnimation on rotation {
                            loops: Animation.Infinite
                            from: 0; to: 360
                            duration: 800
                            running: window.showSpinner && window.showNotification
                        }
                    }
                }

                Text {
                    id: notifTextDrawer
                    anchors.left: parent.left
                    anchors.leftMargin: window.showSpinner ? 40 : 16
                    anchors.verticalCenter: parent.verticalCenter
                    width: Math.min(implicitWidth, 300 - anchors.leftMargin - 16)
                    text: window.currentNotification

                    color: window._text
                    font.family: "JetBrains Mono"
                    font.pixelSize: 14
                    font.bold: true
                    elide: Text.ElideRight

                    opacity: window.showNotification ? 0.9 : 0.0
                    Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.OutQuad } }
                    Behavior on anchors.leftMargin {
                        NumberAnimation { duration: 600; easing.type: Easing.OutBack; easing.overshoot: 0.5 }
                    }
                }
            }

            Repeater {
                model: window.filterData

                delegate: Item {
                    id: delegateRoot2
                    visible: modelData.name !== "Search"
                    property bool isActive: window.currentFilter === modelData.name
                    property bool isColor: modelData.hex !== ""
                    width: !visible ? 0 : (isColor ? 40 : (modelData.name === "Video" || modelData.name === "All") ? 40 : filterText.contentWidth + 24)
                    height: !visible ? 0 : 40
                    anchors.verticalCenter: parent.verticalCenter

                    Rectangle {
                        anchors.fill: parent
                        radius: 6
                        color: isColor
                                ? modelData.hex
                                : (delegateRoot2.isActive ? window._surface2 : "transparent")

                        border.color: delegateRoot2.isActive ? window._text : Qt.rgba(window._surface1.r, window._surface1.g, window._surface1.b, 0.6)
                        border.width: delegateRoot2.isActive ? 3 : 1

                        // Checkmark for active color swatches
                        Text {
                            visible: isColor && delegateRoot2.isActive
                            text: "\u2713"
                            anchors.centerIn: parent
                            font.pixelSize: 16
                            font.bold: true
                            color: "#FFFFFF"
                            style: Text.Outline
                            styleColor: "#40000000"
                        }

                        Text {
                            id: filterText
                            visible: !isColor && modelData.name !== "Video" && modelData.name !== "All"
                            text: modelData.label
                            anchors.centerIn: parent
                            color: delegateRoot2.isActive ? window._text : Qt.rgba(window._text.r, window._text.g, window._text.b, 0.7)
                            font.family: "JetBrains Mono"
                            font.bold: delegateRoot2.isActive
                        }

                        Canvas {
                            visible: modelData.name === "Video"
                            width: 14; height: 16
                            anchors.centerIn: parent
                            property string activeColor: delegateRoot2.isActive ? window._text : Qt.rgba(window._text.r, window._text.g, window._text.b, 0.7)
                            onActiveColorChanged: requestPaint()

                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.reset();
                                ctx.fillStyle = activeColor;
                                ctx.beginPath();
                                ctx.moveTo(0, 0);
                                ctx.lineTo(14, 8);
                                ctx.lineTo(0, 16);
                                ctx.closePath();
                                ctx.fill();
                            }
                        }

                        Canvas {
                            visible: modelData.name === "All"
                            width: 14; height: 14
                            anchors.centerIn: parent
                            property string activeColor: delegateRoot2.isActive ? window._text : Qt.rgba(window._text.r, window._text.g, window._text.b, 0.7)
                            onActiveColorChanged: requestPaint()

                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.reset();
                                ctx.fillStyle = activeColor;
                                ctx.fillRect(0, 0, 6, 6);
                                ctx.fillRect(8, 0, 6, 6);
                                ctx.fillRect(0, 8, 6, 6);
                                ctx.fillRect(8, 8, 6, 6);
                            }
                        }
                    }

                    MouseArea {
                        id: filterMouse
                        anchors.fill: parent
                        onClicked: {
                            if (window.currentFilter === modelData.name)
                                window.applyFilters(true);
                            else
                                window.currentFilter = modelData.name;
                        }
                        cursorShape: Qt.PointingHandCursor
                    }

                    // Arrow key navigation
                    Keys.onLeftPressed: window.cycleFilter(-1)
                    Keys.onRightPressed: window.cycleFilter(1)
                    Keys.onReturnPressed: window.currentFilter = modelData.name
                    Keys.onSpacePressed: window.currentFilter = modelData.name
                }
            }

        }
    }

    // --- Search bar at bottom, identical to launcher Content.qml ---
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        width: Config.options.launcher.itemWidth + 20
        height: searchInput.height + 20
        z: 20
        color: Appearance.colors.colBarBg
        radius: 6

        opacity: window.isReady ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }

        SearchInput {
            id: searchInput
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 10
            placeholder: "search wallpapers..."

        property var fzfMatches: null // null = no filter, [] = no matches, [...] = matched filenames

        onTextEdited: {
            if (text.trim() === "") {
                fzfMatches = null;
                window.cacheVersion++;
                window.applyFilters(true);
                return;
            }
            fzfFilterTimer.restart();
        }

        onAccepted: {
            view.forceActiveFocus();
        }

        Timer {
            id: fzfFilterTimer
            interval: 150
            onTriggered: {
                if (!searchInput.text.trim()) return;
                fzfProcess.running = false;
                let qEscaped = searchInput.text.trim().replace(/'/g, "'\\''");
                let thumbDir = decodeURIComponent(window.thumbDir.replace("file://", ""));
                fzfProcess.command = ["bash", "-c",
                    "ls '" + thumbDir + "' | fzf --filter '" + qEscaped + "'"
                ];
                fzfProcess.running = true;
            }
        }

        Process {
            id: fzfProcess
            running: false
            stdout: StdioCollector {
                onStreamFinished: {
                    let lines = text.trim().split("\n").filter(l => l.length > 0);
                    let matches = {};
                    for (let i = 0; i < lines.length; i++) {
                        matches[lines[i]] = true;
                    }
                    searchInput.fzfMatches = matches;
                    window.cacheVersion++;
                    window.applyFilters(true);
                }
            }
        }
        }
    }

    Component.onCompleted: {
        Quickshell.execDetached(["bash", "-c", "mkdir -p '" + decodeURIComponent(window.searchDir.replace("file://", "")) + "'"]);

        if (searchState.searched) {
            searchInput.text = searchState.query;
            window.searchQuery = searchState.query;
            window.hasSearched = true;
            window.lastSearchName = searchState.lastName;
            window.isSearchPaused = true;
        }

        view.forceActiveFocus();
        window.processMarkers();
        window.triggerColorExtraction();
    }

    Component.onDestruction: {
        if (window.hasSearched) {
            searchState.query = searchInput.text;
            searchState.searched = window.hasSearched;
            searchState.lastName = window.lastSearchName;

            Quickshell.execDetached(["bash", "-c", "echo 'pause' > /tmp/ddg_search_control"]);
        } else {
            Quickshell.execDetached(["bash", "-c", "echo 'stop' > /tmp/ddg_search_control; for p in $(pgrep -f ddg_search.sh); do if [ \"$p\" != \"$$\" ] && [ \"$p\" != \"$BASHPID\" ]; then kill -9 $p 2>/dev/null || true; fi; done; pkill -f '[g]et_ddg_links.py'"]);
        }
    }
}
