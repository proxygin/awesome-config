local wibox   = require("wibox")
local awful   = require("awful")
local vicious = require("vicious")
local beautiful = require("beautiful")
local print  = print
local pairs   = pairs

module("proxygin/calendar")

font = "Inconsolata 13"

clockicon = wibox.widget.imagebox()
clockicon:set_image(beautiful.clock)

local datewidget_text = wibox.widget.textbox()
local datewidget_wrapper = wibox.container.background()
datewidget_wrapper:set_widget(datewidget_text)
datewidget_wrapper:set_bg(beautiful.bg_widget)
local _comb_widget = wibox.layout.fixed.horizontal()
local _widget_icon = wibox.widget.imagebox()

_widget_icon:set_image(beautiful.icons .. "/widgets/myclocknew.png")
_comb_widget:add(_widget_icon)
_comb_widget:add(datewidget_wrapper)

local strf = '<span font="' .. font .. '" color="#EEEEEE" background="' .. beautiful.bg_widget .. '">%b %d %H:%M</span>'
vicious.register(datewidget_text, vicious.widgets.date,
 strf,
  5 )

function widget()
  datewidget_wrapper:buttons(awful.util.table.join(
    awful.button({ }, 1, notify)
  ))
  return _comb_widget
end
