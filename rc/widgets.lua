local wibox   = require("wibox")
local vicious = require("vicious")
local keydoc  = loadrc("keydoc",   "proxygin/keydoc")
local clock   = loadrc("calendar", "proxygin/calendar")
local memory  = loadrc("memory",   "proxygin/memory")
local battery = loadrc("battery",  "proxygin/battery")
local helpers = loadrc("helpers",  "proxygin/helpers")
local pulse   = loadrc("pulse",    "proxygin/pulse")

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
mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", config.terminal },
                                    { "Key bindings", keydoc.display }
                                  }
                        })
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

local taglist_buttons = awful.util.table.join(
                      awful.button({ }, 1, function(t) t:view_only() end),
                      awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                      awful.button({ }        , 3 , awful.tag.viewtoggle),
                      awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                      awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                      awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                    )

local tasklist_buttons = awful.util.table.join(
                      awful.button({ }, 1, helpers.toggle_window),
                      awful.button({ }, 4, helpers.next_client),
                      awful.button({ }, 5, helpers.prev_client)
                     )

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                            awful.button({ }, 1, helpers.next_layout),
                            awful.button({ }, 3, helpers.prev_layout),
                            awful.button({ }, 4, helpers.next_layout),
                            awful.button({ }, 5, helpers.prev_layout)
                           ))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)


    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)


    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(s.mytaglist)
    left_layout:add(s.mypromptbox)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(spacer_arrow0)
    right_layout:add(wibox.widget.systray())
    right_layout:add(pulse.widget())
    right_layout:add(battery.widget())
    right_layout:add(memory.widget())
    right_layout:add(clock.widget())
    right_layout:add(s.mylayoutbox)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(s.mytasklist)
    layout:set_right(right_layout)

    s.mywibox:set_widget(layout)
end)

config.keys.global = awful.util.table.join(
  config.keys.global,
  awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end, "Prompt for a command"),
  awful.key({ modkey }, "w", function ()
    awful.prompt.run({ prompt = "Web: " }, awful.screen.focused().mypromptbox.widget,
      function (command)
        awful.spawn(config.browser .. " 'https://duckduckgo.com/?q=" .. command .. "'", false)
        awful.tag.viewonly(tags[screen.count()][2])
      end)
    end, "Web Search"
  )
)
