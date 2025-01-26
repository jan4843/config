{
  self.hammerspoon.spoons.forceBuiltinMicrophone = ''
    hs.audiodevice.watcher.setCallback(function(arg)
      if arg == "dIn " then
        return
      end
      for _, device in ipairs(hs.audiodevice.allInputDevices()) do
        if device:name():find("MacBook") then
          device:setDefaultInputDevice()
          break
        end
      end
    end)
    hs.audiodevice.watcher.start()
  '';
}
