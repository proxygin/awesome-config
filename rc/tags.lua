local layouts = config.layouts
local keydoc  = loadrc("keydoc", "proxygin/keydoc")

tags = {}
for s = 1, screen.count() do
   -- Each screen has its own tag table.
  tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9}, s, layouts[1])
end


root.buttons(awful.util.table.join(
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))

config.keys.global = awful.util.table.join(
  config.keys.global,
  keydoc.group("Tag management"),
  awful.key({ modkey, }, "Left"      , awful.tag.viewprev ),
  awful.key({ modkey, }, "Right"     , awful.tag.viewnext ),
  awful.key({ modkey, "Ctrl" }, "t"  , awful.tag.viewprev ),
  awful.key({ modkey, "Ctrl" }, "n"  , awful.tag.viewnext ),
  awful.key({ modkey, }, "Escape"    , awful.tag.history.restore, "Switch to previous tag")
)

-- Bind all key numbers to tags.
for i = 1, 9 do
  config.keys.global = awful.util.table.join(config.keys.global,
    keydoc.group("Tag management"),
    awful.key({ modkey }, i,
      function ()
        local screen = mouse.screen
        local tag = awful.tag.gettags(screen)[i]
        if tag then
          awful.tag.viewonly(tag)
        end
      end, i == 1 and "Display only this tag" or nil),

    awful.key({ modkey, "Control" }, i,
      function ()
        local screen = mouse.screen
        local tag = awful.tag.gettags(screen)[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end, i == 1 and "Toggle display of this tag" or nil),

    awful.key({ modkey, "Shift" }, i,
      function ()
	if not client.focus then
		return
	end
        local tag = awful.tag.gettags(client.focus.screen)[i]
        if client.focus and tag then
          awful.client.movetotag(tag)
        end
      end, i == 1 and "Move window to this tag" or nil),

    awful.key({ modkey, "Control", "Shift" }, i,
      function ()
        local tag = awful.tag.gettags(client.focus.screen)[i]
        if client.focus and tag then
          awful.client.toggletag(tag)
        end
      end, i == 1 and "Toggle this tag on this window" or nil),
    keydoc.group("Misc")
  )
end
