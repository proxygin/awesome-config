local vicious = require("vicious")
local wibox = require("wibox")
local beautiful = require("beautiful")
local awful   = require("awful")
local icons   = loadrc("icons", "proxygin/icons")

module("proxygin/memory")

local _widget = wibox.widget.textbox()
local _comb_widget = wibox.layout.fixed.horizontal()
local _widget_icon = wibox.widget.imagebox()
_widget_icon:set_image(beautiful.icons .. "/widgets/mem.png")
_comb_widget:add(_widget_icon)
_comb_widget:add(_widget)

vicious.register(_widget, vicious.widgets.mem,
  '<span background="#777E76" font="Inconsolata 13"> <span font="Inconsolata 13" color="#EEEEEE" background="#777E76">$2MB </span></span>',
  20 )

function widget()
  _widget:buttons(awful.util.table.join(
    awful.button({ }, 1, notify)
  ))
  return _comb_widget
end
