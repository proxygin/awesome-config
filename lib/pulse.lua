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
local _widget = wibox.container.background()
_widget:set_bg(beautiful.bg_widget)
local pulse_widget = wibox.widget.imagebox()
_widget:set_widget(pulse_widget)
local inc = nil


local function change_volume(arg) 
  local list_sinks = io.popen("pacmd" .. " list-sinks"):read('*a')
  
  -- Break down volume into into %. inc = 1%
  if not inc then
    for i in list_sinks:gmatch("volume steps: (%d+)",1) do
    	inc = math.floor((tonumber(i)/100))
	break
    end
  end
  
  -- iter over sinks and set the volume 
  -- We need to interate over two values. The sink index and sink volume. Use
  -- a for-loop to loop over the volumeds, and the iterator index_iterator()
  -- to increment the index manually in each loop iteration.
  local percent = 0
  local index_iterator = list_sinks:gmatch("index: (%d)",1)

  for vol in list_sinks:gmatch("volume: front%-left: (%d+)") do 
    vol = tonumber(vol) + (inc*arg)
    if vol < 0 then
      vol = 0
    end
       
    percent = math.floor(vol/inc)
    sink_no = index_iterator()

    local f = io.popen("pacmd set-sink-volume  " .. sink_no .. " " .. vol ):read('*a')
    local f = io.popen("pacmd set-sink-mute " .. sink_no .. " false"):read('*a')
  end 

  update()
end

function update()
  local list_sinks = io.popen("pacmd" .. " list-sinks"):read('a*')
  
  -- iter over sinks and set the volume 
  local sink_no = 1 
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
  pulse_widget:set_image(icon)
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
  local list_sinks = io.popen("pacmd" .. " list-sinks"):read('*a')
  
  local i = 0 
  for _ in list_sinks:gmatch("volume: front%-left: (%d+)") do 
    local f = io.popen("pacmd set-sink-mute " .. i .. " true"):read('*a')
    i = i + 1 
  end 
end

function mixer()
  -- Make pavucontrol drop down from under the widget. top_workspace excludes
  -- the top widget as display area
  scratch.drop("pavucontrol", "top_workspace","right", 550, 650)
end


function widget()
  pulse_widget:buttons(awful.util.table.join(
    awful.button({ }, 3, mixer),
    awful.button({ }, 1, mixer),
    awful.button({ }, 4, increase),
    awful.button({ }, 5, decrease)
  ))
  update()
  return _widget
end
