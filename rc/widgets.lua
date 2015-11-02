local wibox   = require("wibox")
local vicious = require("vicious")
local keydoc  = loadrc("keydoc", "proxygin/keydoc")
local clock   = loadrc("calendar", "proxygin/calendar")
local memory  = loadrc("memory", "proxygin/memory")
local battery = loadrc("battery", "proxygin/battery")
local helpers = loadrc("helpers", "proxygin/helpers")
local pulse   = loadrc("pulse", "proxygin/pulse")

-- Separators
local sepopen = wibox.widget.imagebox()
sepopen:set_image(beautiful.icons .. "/widgets/left.png")
local sepclose = wibox.widget.imagebox()
sepclose:set_image(beautiful.icons .. "/widgets/right.png")
local spacer = wibox.widget.imagebox()
spacer:set_image(beautiful.icons .. "/widgets/spacer.png")
local spacer2 = wibox.widget.textbox(" | ")
local spacer_arrow0 = wibox.widget.imagebox()
spacer_arrow0:set_image(beautiful.icons .. "/widgets/arrow1.png")


-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", config.terminal },
                                    { "Key bindings", keydoc.display }
                                  }
                        })
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

mytaglist.buttons = awful.util.table.join(
                      awful.button({ }        , 1 , awful.tag.viewonly)     ,
                      awful.button({ modkey } , 1 , awful.client.movetotag) ,
                      awful.button({ }        , 3 , awful.tag.viewtoggle)   ,
                      awful.button({ modkey } , 3 , awful.client.toggletag) ,
                      awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                      awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                      awful.button({ }, 1, helpers.toggle_window),
                      awful.button({ }, 4, helpers.next_client),
                      awful.button({ }, 5, helpers.prev_client)
                     )

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                            awful.button({ }, 1, helpers.next_layout),
                            awful.button({ }, 3, helpers.prev_layout),
                            awful.button({ }, 4, helpers.next_layout),
                            awful.button({ }, 5, helpers.prev_layout)
                           ))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(spacer_arrow0)
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(pulse.widget())
    right_layout:add(battery.widget())
    right_layout:add(memory.widget())
    right_layout:add(clock.widget())
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)

    --for k,i in pairs(mywibox[1]) do
    --   print(k,i)
    --end
    --print(mywibox[s].geometry())
end

config.keys.global = awful.util.table.join(
  config.keys.global,
  awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end, "Prompt for a command"),
  awful.key({ modkey }, "w", function ()
    awful.prompt.run({ prompt = "Web: " }, mypromptbox[mouse.screen].widget,
      function (command)
        awful.util.spawn(config.browser .. " 'https://duckduckgo.com/?q=" .. command .. "'", false)
        awful.tag.viewonly(tags[screen.count()][2])
      end)
    end, "Web Search"
  )
)
