local brightness = loadrc("brightness", "proxygin/brightness")
local pulse      = loadrc("pulse", "proxygin/pulse")
local keydoc     = loadrc("keydoc", "proxygin/keydoc")
local tools      = loadrc("tools", "proxygin/tools")
local helpers    = loadrc("helpers", "proxygin/helpers")
local scratch    = require("scratch")

config.keys.global = awful.util.table.join(

  -- Awesome
  awful.key({ modkey , "Control" } , "r" , awesome.restart , "Restart Awesome") ,

  keydoc.group("Focus"),

  awful.key({ modkey , }           , "j"   , helpers.next_client        , "Focus next window")               ,
  awful.key({ modkey , }           , "k"   , helpers.prev_client        , "Focus previous window")           ,
  awful.key({ modkey , }           , "h"   , helpers.left_client        , "Focus left window")               ,
  awful.key({ modkey , }           , "s"   , helpers.right_client       , "Focus right window")              ,
  awful.key({ modkey , }           , "n"   , helpers.up_client          , "Focus window above")              ,
  awful.key({ modkey , }           , "t"   , helpers.down_client        , "Focus window below")              ,
  awful.key({ modkey , }           , "Tab" , helpers.last_client        , "Focus previously focused window") ,
  awful.key({ modkey , }           , "u"   , awful.client.urgent.jumpto , "Jump to urgent client")           ,
  awful.key({ modkey , "Control" } , "h"   , helpers.left_screen        , "Focus left screen")               ,
  awful.key({ modkey , "Control" } , "s"   , helpers.right_screen       , "Focus right screen")              ,

  keydoc.group("Layout manipulation"),

  awful.key({ modkey , }           , "+"     , helpers.incmw       , "Increase master size")   ,
  awful.key({ modkey , }           , "-"     , helpers.decmv       , "Decrease master size")   ,
  awful.key({ modkey , }           , "space" , helpers.next_layout , "Next layout")                  ,
  awful.key({ modkey , "Shift"   } , "space" , helpers.prev_layout , "Previous layout")              ,
  awful.key({ modkey , "Shift"   } , "h"     , helpers.swap_left   , "Swap with window above")       ,
  awful.key({ modkey , "Shift"   } , "s"     , helpers.swap_right  , "Swap with window below")       ,
  awful.key({ modkey , "Shift"   } , "n"     , helpers.swap_up     , "Swap with window above")       ,
  awful.key({ modkey , "Shift"   } , "t"     , helpers.swap_down   , "Swap with window below")       ,

  awful.key({ modkey, "Control", "Shift" }, "h", function (c) awful.client.movetoscreen(c,2) end),
  awful.key({ modkey, "Control", "Shift" }, "s", function (c) awful.client.movetoscreen(c,1) end),


  keydoc.group("Misc"),

  awful.key({                   }, "Print", tools.screenshot),
  awful.key({ modkey, "Control" }, "l", tools.lock_screen),
  awful.key({ modkey,           }, "Return", tools.terminal, "Spawn a terminal"), 
  awful.key({ modkey,           }, "BackSpace", tools.browser),

  -- Multimedia keys
  awful.key({ }, "#232", function () awful.util.spawn("setbrightness -") end),
  awful.key({ }, "#233", function () awful.util.spawn("setbrightness +") end),
  awful.key({ }, "#237", function () awful.util.spawn("backlight -") end),
  awful.key({ }, "#238", function () awful.util.spawn("backlight +") end),
  awful.key({ }, "#212", function () awful.util.spawn(os.getenv("HOME") .. "/scritps/toggle-touchpad") end),
  awful.key({ }, "#173", function () awful.util.spawn(os.getenv("HOME") .. "/scripts/spotify-control.sh previous") end),
  awful.key({ }, "#171", function () awful.util.spawn(os.getenv("HOME") .. "/scripts/spotify-control.sh next") end),
  awful.key({ }, "#172", function () awful.util.spawn(os.getenv("HOME") .. "/scripts/spotify-control.sh pause_play") end),
  awful.key({ }, "#128", function () awful.util.spawn(os.getenv("HOME") .. "/scripts/cycle-keymaps.sh") end),
  awful.key({ } , "XF86MonBrightnessUp"   , brightness.increase) ,
  awful.key({ } , "XF86MonBrightnessDown" , brightness.decrease) ,
  awful.key({ } , "XF86AudioRaiseVolume"  , pulse.increase)      ,
  awful.key({ } , "XF86AudioLowerVolume"  , pulse.decrease)      ,
  awful.key({ } , "XF86AudioMute"         , pulse.mute)          ,
  awful.key({ modkey,           }, "u",
    function () 
      sinks = {}
      for line in string.gmatch(awful.util.pread("paselector list"), "[^\n]+") do
              local sink_no   = line:sub(0,string.find(line,"\t"))
              local sink_desc = line:sub(string.find(line,"\t")+1,line:len())
              table.insert(sinks, { sink_desc, function() awful.util.spawn_with_shell("paselector move " .. sink_no ) end})
      end
      
      mypaselector = awful.menu.new( { items = sinks, theme = { width = 300, } } )
      mypaselector:show()
   end, "Change audio output"),

  -- Help
  awful.key({ modkey, }, "F1", keydoc.display),
  --
  -- Use scratchdrop to emulate game-console
  awful.key({ modkey }, "|", function () scratch.drop("urxvtcd", "top") end)

)

config.keys.client = awful.util.table.join(
  keydoc.group("Window-specific bindings"),
  awful.key({ modkey , }           , "f"      , helpers.fullscreen           , "Fullscreen")                ,
  awful.key({ modkey , "Shift"}    , "c"      , helpers.close_window         , "Close")                     ,
  awful.key({ modkey , }           , "o"      , helpers.movetoscreen         , "Move to the other screen")  ,
  awful.key({ modkey , "Control" } , "space"  , awful.client.floating.toggle , "Toggle floating")           ,
)

keydoc.group("Misc")

config.mouse.client = awful.util.table.join(
  awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize)
)
