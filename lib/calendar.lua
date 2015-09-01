local wibox   = require("wibox")
local awful   = require("awful")
local vicious = require("vicious")
local beautiful = require("beautiful")

module("proxygin/calendar")

font = "Inconsolata 13"

clockicon = wibox.widget.imagebox()
clockicon:set_image(beautiful.clock)

local _widget = wibox.widget.textbox()

local strf = '<span font="' .. font .. '" color="#EEEEEE" background="#777E76">%b %d %H:%M</span>'
vicious.register(_widget, vicious.widgets.date,
 strf,
  5 )

function widget()
  _widget:buttons(awful.util.table.join(
    awful.button({ }, 1, notify)
  ))
  return _widget
end
