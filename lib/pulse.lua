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
local pairs     = pairs

module("proxygin/pulse")

local lastid  = nil
local pulse_widget = wibox.widget.imagebox()


-- Break down volume into into %. inc = 1%
local inc = math.floor((tonumber(io.popen("pacmd" .. " list-sinks"):read('*a'):gmatch("volume steps: (%d+)",1)())/100))

function sinks()
  return io.popen("pacmd list-sinks"):read('*a'):gmatch("index: (%d)")
end


local function change_volume(arg) 
  for sink,vol in io.popen("pacmd" .. " list-sinks"):read('*a'):gmatch("index: (%d)[^/]+front%-left: (%d+)[^/]+/") do
    local vol = tonumber(vol) + (inc*arg)
    if vol < 0 then
      vol = 0
    end

    local f = io.popen("pacmd set-sink-volume " .. sink .. " " .. vol ):read('*a')
    local f = io.popen("pacmd set-sink-mute "   .. sink ..    " false"):read('*a')
  end 

  update()
end

function update()
  -- Match default sink from the * and extract % volume 
  local percent = tonumber(io.popen("pacmd list-sinks"):read('a*'):gmatch("%* index: %d[^/]+/ +(%d+)",1)())

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
  for i in sinks() do
    print(i)
    local f = io.popen("pacmd set-sink-mute " .. i .. " true"):read('*a')
  end 
  local icon = icons.lookup({name = "audio-volume-muted", type = "status"})
  pulse_widget:set_image(icon)
  lastid = naughty.notify({ text = "muted",
        icon = icon,
        font = "Ubuntu Bold 12",
        replaces_id = lastid }).id
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
  return pulse_widget
end
