local config = config
local awful  = require("awful")

module("proxygin/tools")

function screenshot()
  awful.util.spawn("gnome-screenshot -i", false)
end

function lock_screen()
  awful.util.spawn("i3lock -c 000000")
end

function terminal()
  awful.util.spawn(config.terminal)
end

function browser()
  awful.util.spawn(config.browser)
end
