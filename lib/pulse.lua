local awful    = require("awful")
local naughty  = require("naughty")
local tonumber = tonumber
local string   = string
local config   = config
local icons    = loadrc("icons", "proxygin/icons")
local wibox    = require("wibox")
local io       = require("io")
local math     = require("math")

module("proxygin/pulse")

local lastid  = nil
local _widget = wibox.widget.imagebox()
local inc = nil


local function change_volume(arg) 
  local f = io.popen("pacmd" .. " list-sinks") 
  if f == nill then 
    return false 
  end 
  
  local list_sinks = f:read("*a") 
  f:close() 
  
  if not inc then
    for i in list_sinks:gmatch("volume steps: (%d+)",1) do
    	inc = math.floor((tonumber(i)/100))
    end
  end
  
  local i = 0 
  local percent = 0
  for vol in list_sinks:gmatch("volume: front%-left: (%d+)") do 
    vol = tonumber(vol) + (inc*arg)
    if vol < 0 then
      vol = 0
    end
       
    percent = math.floor(vol/inc)

    local f = io.popen("pacmd set-sink-volume  " .. i .. " " .. vol )
    local f = io.popen("pacmd set-sink-mute " .. i .. " false")
    i = i + 1 
  end 

  local icon = "high"
  if percent < 30 then
    icon = "low"
  elseif percent < 60 then
    icon = "medium"
  end

  local icon = icons.lookup({name = "audio-volume-" .. icon, type = "status"})
  _widget:set_image(icon)
  lastid = naughty.notify({ text = string.format("%d %%", percent),
        icon = icon,
        font = "Ubuntu Bold 14",
        replaces_id = lastid }).id
end

function increase()
  change_volume(5)
end

function decrease()
  change_volume(-5)
end

function mute()
  local f = io.popen("pacmd" .. " list-sinks") 
  if f == nill then 
    return false 
  end 
  
  local list_sinks = f:read("*a") 
  f:close() 
  
  local i = 0 
  for _ in list_sinks:gmatch("volume: front%-left: (%d+)") do 
    local f = io.popen("pacmd set-sink-mute " .. i .. " true")
    i = i + 1 
  end 
end

function mixer()
  awful.util.spawn(config.term_cmd .. "alsamixer", false)
end


function widget()
  _widget:buttons(awful.util.table.join(
    awful.button({ }, 3, mixer),
    awful.button({ }, 1, mute),
    awful.button({ }, 4, increase),
    awful.button({ }, 5, decrease)
  ))
  return _widget
end
