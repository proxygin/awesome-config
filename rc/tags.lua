local layouts = config.layouts
local keydoc  = loadrc("keydoc", "proxygin/keydoc")

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

config.keys.global = awful.util.table.join(
  config.keys.global,
  keydoc.group("Tag management"),
  awful.key({ modkey, }, "Left"      , function() awful.tag.viewprev() end ),
  awful.key({ modkey, }, "Right"     , function() awful.tag.viewnext() end ),
  awful.key({ modkey, "Ctrl" }, "t"  , function() awful.tag.viewprev() end ),
  awful.key({ modkey, "Ctrl" }, "n"  , function() awful.tag.viewnext() end ),
  awful.key({ modkey, }, "Escape"    , awful.tag.history.restore, "Switch to previous tag")
)

-- Bind all key numbers to tags.
for i = 1, 9 do
  config.keys.global = awful.util.table.join(config.keys.global,
    keydoc.group("Tag management"),
    awful.key({ modkey }, i,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end, i == 1 and "Display only this tag" or nil),

    awful.key({ modkey, "Control" }, i,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end, i == 1 and "Toggle display of this tag" or nil),

    awful.key({ modkey, "Shift" }, i,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end, i == 1 and "Move window to this tag" or nil),

    awful.key({ modkey, "Control", "Shift" }, i,
      function ()
        local tag = client.focus.screen.tags[i]
        if client.focus and tag then
            if client.focus then
              client.focus:toggle_tag(t)
            end
        end
      end, i == 1 and "Toggle this tag on this window" or nil),
    keydoc.group("Misc")
  )
end
end )
