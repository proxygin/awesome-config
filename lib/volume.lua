-- Handle volume (through pulseaudio)

local io       = require("io")
local awful    = require("awful")
local naughty  = require("naughty")
local tonumber = tonumber
local string   = string
local config   = config
local icons    = loadrc("icons", "proxygin/icons")
local wibox    = require("wibox")

module("proxygin/volume")

local lastid  = nil
local channel = "Master"
local _widget = wibox.widget.imagebox()

local function pulse(args)
  local f = io.popen("pacmd" .. " list-sinks")
  if f  == nill then
    return false
  end

  local list_sinks = f:read("*a")
  f:close()

  for sink in list_sinks:gmatch("volume: front-left: (%d+)") do
    lastid = naughty.notify({ text = "test", icon = icon, font = "Ubuntu Bold 14", replaces_id = lastid }).id
  end
  local _, count = string.gsub(list_sinks, "index: (%d)", "%1")

  --vol = tonumber(vol) + ((65537/100)*5)
  for i = 0, count-1 do
    -- apply 'whatever' to each index
    local f = io.popen("pacmd set-sink-volume "  .. i .. " " .. 14418)
    if f  == nill then
      lastid = naughty.notify({ text = "det gik galt...",
      icon = icon,
      font = "Ubuntu Bold 14",
      replaces_id = lastid }).id
      return false
    end
    f:close()
  end

  lastid = naughty.notify({ text = vols,
  icon = icon,
  font = "Ubuntu Bold 14",
  replaces_id = lastid }).id
end

local function amixer(args)
  local out = awful.util.pread("amixer " .. args)
  local vol, mute = out:match("([%d]+)%%.*%[([%l]*)")
  if not mute or not vol then return end

  vol = tonumber(vol)
  local icon = "high"
  if mute ~= "on" or vol == 0 then
    icon = "muted"
  elseif vol < 30 then
    icon = "low"
  elseif vol < 60 then
    icon = "medium"
  end

  local icon = icons.lookup({name = "audio-volume-" .. icon, type = "status"})
  _widget:set_image(icon)
  lastid = naughty.notify({ text = string.format("%3d %%", vol),
        icon = icon,
        font = "Ubuntu Bold 14",
        replaces_id = lastid }).id
end

function increase()
  --awful.util.spawn("pavol +")
  pulse("test")
end

function decrease()
  awful.util.spawn("pavol -")
end

function toggle()
  awful.util.spawn("pavol mute")
end

function update()
  amixer("sget " .. channel)
end

function mixer()
  awful.util.spawn(config.term_cmd .. "alsamixer", false)
end

function widget()
  _widget:buttons(awful.util.table.join(
    awful.button({ }, 3, mixer),
    awful.button({ }, 1, toggle),
    awful.button({ }, 4, increase),
    awful.button({ }, 5, decrease)
  ))
  update()
  return _widget
end
