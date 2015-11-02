local vicious = require("vicious")
local wibox = require("wibox")
local beautiful = require("beautiful")
local awful   = require("awful")
local icons   = loadrc("icons", "proxygin/icons")

module("proxygin/memory")

local _widget = wibox.widget.textbox()
local widget_wrapper = wibox.widget.background()
widget_wrapper:set_bg(beautiful.bg_widget)
widget_wrapper:set_widget(_widget)
local _comb_widget = wibox.layout.fixed.horizontal()
local _widget_icon = wibox.widget.imagebox()
_widget_icon:set_image(beautiful.icons .. "/widgets/mem.png")
_comb_widget:add(_widget_icon)
_comb_widget:add(widget_wrapper)

vicious.register(_widget, vicious.widgets.mem,
  '<span font="Inconsolata 13" color="#EEEEEE" background="' .. beautiful.bg_widget .. '">$2MB</span>',
  20 )

function widget()
  _widget:buttons(awful.util.table.join(
    awful.button({ }, 1, notify)
  ))
  return _comb_widget
end
