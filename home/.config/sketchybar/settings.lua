return {
  paddings = 3,
  group_paddings = 5,

  icons = "sf-symbols",

  font = require("helpers.default_font"),

  vpn_check = "/sbin/ifconfig utun4 2>/dev/null | grep -q 'inet '",
  vpn_click = "open -a GlobalProtect",
}
