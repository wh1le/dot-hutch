import QtQuick
import QtTest

TestCase {
    name: "Encryption"

    function parseMountOutput(text) {
        if (!text || text.trim() === "") return false;
        return /\s+on\s+\/mnt\/personal_\S+\s+/.test(text);
    }

    function test_mounted() {
        verify(parseMountOutput("/dev/mapper/encryption1 on /mnt/personal_data type ext4 (rw)"));
    }
    function test_not_mounted() {
        verify(!parseMountOutput("/dev/sda1 on /mnt/public type ext4 (rw)"));
    }
    function test_empty() {
        verify(!parseMountOutput(""));
    }
    function test_wrong_prefix() {
        verify(!parseMountOutput("/dev/mapper/encryption1 on /mnt/public type ext4 (rw)"));
    }
    function test_multiple_mounts() {
        var text = "/dev/sda1 on /mnt/public type ext4 (rw)\n/dev/mapper/encryption1 on /mnt/personal_docs type ext4 (rw)";
        verify(parseMountOutput(text));
    }
    function test_null() {
        verify(!parseMountOutput(null));
    }
    function test_personal_underscore_required() {
        verify(!parseMountOutput("/dev/mapper/x on /mnt/personal type ext4 (rw)"));
    }
}
