pragma Singleton
import "../modules/common"
import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Singleton {
    id: root

    property bool smartTray: Config.options.tray.filterPassive
    property list<var> itemsInUserList: SystemTray.items.values.filter(i => (Config.options.tray.pinnedItems.includes(i.id) && (!smartTray || i.status !== Status.Passive)))
    property list<var> itemsNotInUserList: SystemTray.items.values.filter(i => (!Config.options.tray.pinnedItems.includes(i.id) && (!smartTray || i.status !== Status.Passive)))

    property bool invertPins: Config.options.tray.invertPinnedItems
    property list<var> pinnedItems: invertPins ? itemsNotInUserList : itemsInUserList
    property list<var> unpinnedItems: invertPins ? itemsInUserList : itemsNotInUserList

    function getTooltipForItem(item) {
        var result = item.tooltipTitle.length > 0 ? item.tooltipTitle : (item.title.length > 0 ? item.title : item.id);
        if (item.tooltipDescription.length > 0) result += " • " + item.tooltipDescription;
        if (Config.options.tray.showItemId) result += "\n[" + item.id + "]";
        return result;
    }

    function pin(itemId) {
        var pins = Config.options.tray.pinnedItems;
        if (pins.includes(itemId)) return;
        Config.options.tray.pinnedItems.push(itemId);
    }

    function unpin(itemId) { Config.options.tray.pinnedItems = Config.options.tray.pinnedItems.filter(id => id !== itemId); }
    function isPinned(itemId) { return root.pinnedItems.some(item => item.id === itemId); }
    function togglePin(itemId) { if (Config.options.tray.pinnedItems.includes(itemId)) unpin(itemId); else pin(itemId); }

    // --- Testable pure JS functions ---
    function _filterItems(items, pinnedList, filterPassive) {
        return items.filter(i => pinnedList.includes(i.id) && (!filterPassive || i.status !== "Passive"));
    }

    function _invertPinBehavior(inUserList, notInUserList, invert) {
        return invert ? { pinned: notInUserList, unpinned: inUserList } : { pinned: inUserList, unpinned: notInUserList };
    }
}
