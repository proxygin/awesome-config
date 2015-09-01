loadrc("xrun", "proxygin/xrun")
--

-- Start idempotent commands
local execute = {
   -- Start PulseAudio
   "pulseaudio --check || pulseaudio -D",
   "setxkbmap custom-dvorak",
   "xset -b",	-- Disable bell
   -- Default browser
   "xdg-mime default " .. config.browser .. ".desktop " ..
      "x-scheme-handler/http " ..
      "x-scheme-handler/https " ..
      "text/html",
   -- Default MIME types
   "xdg-mime default evince.desktop application/pdf",
   --"xdg-mime default gpicview.desktop image/png image/x-apple-ios-png image/jpeg image/jpg image/gif",
   -- dbus-mediakeys
   --"dbus-mediakeys &"
   "xrdb -merge " .. os.getenv("HOME") .. "/.Xresources",
}

os.execute(table.concat(execute, ";"))

-- Spawn various X programs
--xrun("polkit-gnome-authentication-agent-1",
--     "/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1")
--xrun("NetworkManager Applet", "nm-applet")
--xrun("Commman Applet", "connman-ui-gtk")
awful.util.spawn_with_shell("connman-ui-gtk 2> /dev/null")
