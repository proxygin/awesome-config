local gears = require("gears")

-- Theme
beautiful.init(awful.util.getdir("config") .. "/theme.lua")

-- Wallpaper
function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Naughty
for _,preset in pairs({"normal", "low", "critical"}) do
  naughty.config.presets[preset].font    = "Ubuntu 12"
  naughty.config.presets[preset].timeout = 5
  naughty.config.presets[preset].margin  = 10
end
