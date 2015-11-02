-- Handle brightness (with xbacklight)

local awful     = require("awful")
local naughty   = require("naughty")
local tonumber  = tonumber
local string    = string
local icons     = loadrc("icons", "proxygin/icons")
local io        = require("io")
local math      = require("math")
local beautiful = require("beautiful")

module("proxygin/brightness")

-- Assume we have one and only one monitor with controllable brightness
local BRIGHTNESS_MODULE = awful.util.pread("find -L /sys/class/backlight/ -mindepth 1 -maxdepth 1 2> /dev/null | head -n 1 | tr -d '\n'")
local MAX_BRIGHTNESS    = tonumber(awful.util.pread("cat " .. BRIGHTNESS_MODULE .. "/max_brightness"))
local nid = nil

local function notify(value)
  local icon = beautiful.icons .. "/widgets/display-brightness-symbolic.png"
  nid = naughty.notify({ text = string.format("%.0f %%", value),
      icon = icon,
      font = "Ubuntu Bold 14",
      replaces_id = nid }).id
end


-- For this to work we need two things to have happend:
-- root must have run `setpci -v -H1 -s 00:01.00 BRIDGE_CONTROL=0`
-- root must have made `/sys/class/backlight/*/brigtness` writeable
local function change(inc)
  local b = io.open(BRIGHTNESS_MODULE .. "/brightness","r")
  local brightness = tonumber(b:read("*all"))
  b:close()

  brightness = brightness + inc

  -- Let brightness be between [0-MAX_BRIGHTNESS]
  brightness = math.min(brightness,MAX_BRIGHTNESS)
  brightness = math.max(brightness,0)

  awful.util.pread("echo " .. brightness ..  " > " .. BRIGHTNESS_MODULE .. "/brightness")

  notify( (brightness/MAX_BRIGHTNESS) * 100)
end

function increase()
  change(100)
end

function decrease()
  change(-100)
end
