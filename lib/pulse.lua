local awful     = require("awful")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local icons     = loadrc("icons", "proxygin/icons")
local wibox     = require("wibox")
local io        = require("io")
local math      = require("math")
local scratch   = require("scratch")
local tonumber  = tonumber
local print     = print
local mouse     = mouse
local screen    = screen
local pairs     = pairs

module("proxygin/pulse")

local lastid  = nil
local _widget = wibox.widget.imagebox()
local inc = nil


local function change_volume(arg) 
  local list_sinks = awful.util.pread("pacmd" .. " list-sinks")
  
  -- Break down volume into into %. inc = 1%
  if not inc then
    for i in list_sinks:gmatch("volume steps: (%d+)",1) do
    	inc = math.floor((tonumber(i)/100))
	break
    end
  end
  
  -- iter over sinks and set the volume 
  local sink_no = 0 
  local percent = 0
  for vol in list_sinks:gmatch("volume: front%-left: (%d+)") do 
    vol = tonumber(vol) + (inc*arg)
    if vol < 0 then
      vol = 0
    end
       
    percent = math.floor(vol/inc)

    local f = io.popen("pacmd set-sink-volume  " .. sink_no .. " " .. vol )
    local f = io.popen("pacmd set-sink-mute " .. sink_no .. " false")
    sink_no = sink_no + 1 
  end 

  update()
end

function update()
  local list_sinks = awful.util.pread("pacmd" .. " list-sinks")
  
  -- iter over sinks and set the volume 
  local sink_no = 0 
  local percent = 0
  for default_sink_prop in list_sinks:gmatch("%* index: %d.*",1) do 
    for default_percent in default_sink_prop:gmatch("volume: front%-left: %d+ / +(%d+)") do 
      percent  = tonumber(default_percent)
      break
    end
    break
  end 

  local icon = "high"
  if percent < 30 then
    icon = "low"
  elseif percent < 60 then
    icon = "medium"
  end

  local icon = icons.lookup({name = "audio-volume-" .. icon, type = "status"})
  _widget:set_image(icon)
  lastid = naughty.notify({ text = ("%d %%"):format(percent),
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
  local list_sinks = awful.util.pread("pacmd" .. " list-sinks")
  
  local i = 0 
  for _ in list_sinks:gmatch("volume: front%-left: (%d+)") do 
    local f = io.popen("pacmd set-sink-mute " .. i .. " true")
    i = i + 1 
  end 
end

function mixer()
  -- Make pavucontrol drop down from under the widget. top_workspace excludes
  -- the top widget as display area
  scratch.drop("pavucontrol", "top_workspace","right", 550, 650)
end


function widget()
  _widget:buttons(awful.util.table.join(
    awful.button({ }, 3, mixer),
    awful.button({ }, 1, mixer),
    awful.button({ }, 4, increase),
    awful.button({ }, 5, decrease)
  ))
  update()
  return _widget
end
