local vicious = require("vicious")
local wibox = require("wibox")
local beautiful = require("beautiful")
local awful   = require("awful")

module("proxygin/memory")

local _widget = wibox.widget.textbox()

vicious.register(_widget, vicious.widgets.mem,
  '<span background="#777E76" font="Inconsolata 13"> <span font="Inconsolata 13" color="#EEEEEE" background="#777E76">$2MB </span></span>',
  20 )

function widget()
  _widget:buttons(awful.util.table.join(
    awful.button({ }, 1, notify)
  ))
  return _widget
end
