-- run a command only if the client does not already exist

local xrun_now = function(name, cmd)
  local basename = cmd:gsub("(S*) .*","%1")
  local count = tonumber(awful.util.pread("pgrep -x -c " .. cmd))
  if count == 0 then
    print("Starting " .. basename .. " via '" .. cmd .. "'.")
    awful.util.spawn(cmd or name, false)
  else
    print("Not starting " .. basename .. ". Already running.")
  end
end

-- Run a command if not already running.
xrun = function(name, cmd)
   -- We need to wait for awesome to be ready. Hence the timer.
   local stimer = timer { timeout = 0 }
   local run = function()
      stimer:stop()
      xrun_now(name, cmd)
   end
   stimer:connect_signal("timeout", run)
   stimer:start()
end
