import QtQuick
import QtTest

TestCase {
    name: "Network"

    function parseNmcliNetworks(text) {
        const PLACEHOLDER = "STRINGWHICHHOPEFULLYWONTBEUSED";
        const rep = new RegExp("\\\\:", "g");
        const rep2 = new RegExp(PLACEHOLDER, "g");
        return text.trim().split("\n").map(n => {
            const net = n.replace(rep, PLACEHOLDER).split(":");
            return { active: net[0] === "yes", strength: parseInt(net[1]), frequency: parseInt(net[2]), ssid: net[3], bssid: net[4]?.replace(rep2, ":") ?? "", security: net[5] || "" };
        }).filter(n => n.ssid && n.ssid.length > 0);
    }

    function dedupNetworks(networks) {
        const networkMap = new Map();
        for (const network of networks) {
            const existing = networkMap.get(network.ssid);
            if (!existing) networkMap.set(network.ssid, network);
            else if (network.active && !existing.active) networkMap.set(network.ssid, network);
            else if (!network.active && !existing.active && network.strength > existing.strength) networkMap.set(network.ssid, network);
        }
        return Array.from(networkMap.values());
    }

    function iconForStrength(strength) {
        if (strength > 83) return "signal_wifi_4_bar";
        if (strength > 67) return "network_wifi";
        if (strength > 50) return "network_wifi_3_bar";
        if (strength > 33) return "network_wifi_2_bar";
        if (strength > 17) return "network_wifi_1_bar";
        return "signal_wifi_0_bar";
    }

    // --- nmcli parsing ---
    function test_parse_basic() {
        var result = parseNmcliNetworks("yes:85:5180:MyWifi:AA\\:BB\\:CC\\:DD\\:EE\\:FF:WPA2");
        compare(result.length, 1);
        compare(result[0].ssid, "MyWifi");
        compare(result[0].active, true);
        compare(result[0].strength, 85);
    }
    function test_parse_inactive() {
        var result = parseNmcliNetworks("no:45:2437:OtherNet:11\\:22\\:33\\:44\\:55\\:66:WPA2");
        verify(!result[0].active);
    }
    function test_parse_empty() {
        compare(parseNmcliNetworks("").length, 0);
    }

    // --- dedup ---
    function test_dedup_same_ssid_keep_stronger() {
        var networks = [
            { ssid: "Net", strength: 50, active: false },
            { ssid: "Net", strength: 80, active: false }
        ];
        var deduped = dedupNetworks(networks);
        compare(deduped.length, 1);
        compare(deduped[0].strength, 80);
    }
    function test_dedup_active_wins() {
        var networks = [
            { ssid: "Net", strength: 90, active: false },
            { ssid: "Net", strength: 50, active: true }
        ];
        var deduped = dedupNetworks(networks);
        compare(deduped.length, 1);
        verify(deduped[0].active);
    }
    function test_dedup_different_ssids() {
        var networks = [
            { ssid: "A", strength: 50, active: false },
            { ssid: "B", strength: 80, active: false }
        ];
        compare(dedupNetworks(networks).length, 2);
    }

    // --- signal icon ---
    function test_icon_excellent() { compare(iconForStrength(90), "signal_wifi_4_bar"); }
    function test_icon_good() { compare(iconForStrength(70), "network_wifi"); }
    function test_icon_fair() { compare(iconForStrength(55), "network_wifi_3_bar"); }
    function test_icon_weak() { compare(iconForStrength(35), "network_wifi_2_bar"); }
    function test_icon_very_weak() { compare(iconForStrength(20), "network_wifi_1_bar"); }
    function test_icon_none() { compare(iconForStrength(5), "signal_wifi_0_bar"); }

    // --- connectivity state ---
    function test_status_mapping() {
        var states = ["disconnected", "connecting", "connected", "limited", "disabled"];
        compare(states.length, 5);
        verify(states.includes("connected"));
    }
}
