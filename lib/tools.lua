local config = config
local awful  = require("awful")

module("proxygin/tools")

function screenshot()
  awful.spawn("gnome-screenshot -i", false)
end

function lock_screen()
  awful.spawn("i3lock -c 000000")
end

function terminal()
  awful.spawn(config.terminal)
end

function browser()
  awful.spawn(config.browser)
end
