local icons     = loadrc("icons", "proxygin/icons")
local awful     = require("awful")
local wibox     = require("wibox")
local vicious   = require("vicious")
local naughty   = require("naughty")
local beautiful = require("beautiful")

module("proxygin/battery")

local battery = "BAT0"
local state   = nil
local percent = nil
local time    = nil
local icon    = nil
local title   = nil
local lastid  = nil
local _widget = wibox.container.background()
_widget:set_bg(beautiful.bg_widget)
local battery_widget = wibox.widget.imagebox()
_widget:set_widget(battery_widget)

local function get_icon()
  local charge = "100"
  if percent < 10 then
    charge = "000"
  elseif percent < 20 then
    charge = "020"
  elseif percent < 40 then
    charge = "040"
  elseif percent < 60 then
    charge = "060"
  elseif percent < 80 then
    charge = "080"
  end

  local current_state = state == "+" and "-charging" or ""
  return icons.lookup({name = "gpm-battery-" .. charge .. current_state, type = "status"})
end

local function notify()
  local level = "Battery level is currently " .. percent .. "%.\n"
  local remaining_time = nil
  if state == "+" then
    remaining_time = time .. " until charged."
  else
    remaining_time = time == "N/A" and "" or (time .. " left before running out of power.")
  end
  lastid = naughty.notify({
    title = title,
    text  = level .. remaining_time,
    icon  = icon,
    replaces_id = lastid }).id
end

vicious.register(battery_widget, vicious.widgets.bat,
  function(widget, args)
    state   = args[1]
    percent = args[2]
    time    = args[3]

    if percent > 95 then
      widget:set_image(nil)
    else
      icon = get_icon()
      widget:set_image(icon)
    end

    if percent < 15 then
      title = "Battery low!"
      notify()
    else
      title = nil
    end
  end,
  60, battery)

function widget()
  battery_widget:buttons(awful.util.table.join(
    awful.button({ }, 1, notify)
  ))
  return _widget
end
