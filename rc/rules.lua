awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = config.keys.client,
                     buttons = config.mouse.client } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { instance = "exe" },
      properties = { floating = true } },
    { rule = { class = "pavucontrol" },
      properties = { floating = true } },
    { rule = { class = "Firefox", name = "Downloads" }, --The download window of iceweasel
      properties = { floating = true } },
    { rule = { class = "feh" },
      properties = { floating = true } },
    { rule = { class = "Vlc" },
      properties = { floating = true } },
    { rule = { class = "URxvt" },
      properties = { opacity = 0.9 ,
                     size_hints_honor = false } },
    { rule = { class = "x-terminal-emulator" },
      properties = { border_width = 0,
                     border_color = "black",
                     size_hints_honor = false,
                     opacity = 0.9 } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}