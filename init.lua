BUTTON = 7
BUTTON_DEBOUNCE_MS = 5000 -- debounce and rate-limit at once
NOISE_DEBOUNCE_MS = 30 -- should fix the "random trigger" problem

host = {
  address = "10.214.226.24";
  port = 23421;
}

sum = 0
i   = 1

function button_init()
  gpio.trig(BUTTON, "down", button_lowCallback)
  gpio.mode(BUTTON, gpio.INT)
end

function button_lowCallback()
  tmr.alarm(0, 1, tmr.ALARM_SEMI, button_count)
  gpio.trig(BUTTON, "none") 
end

function button_count()
  if(i > NOISE_DEBOUNCE_MS) then
    i = 0
    tmr.unregister(0)
    if(sum < 5) then
       sum = 0
       rimshot()
    else
       sum = 0
       print("Too noisy!")
       button_init()
    end
  else
    i = i + 1
    sum = sum + gpio.read(BUTTON)
    tmr.start(0)
  end
end
    

function rimshot ()
  gpio.trig(BUTTON, "none")
  socket = net.createConnection(net.UDP, 0)
  socket:connect(host.port, host.address)
  socket:send("rimshot\n")
  socket:close()
  print("ba-dumm-tss!")
  tmr.alarm(0, BUTTON_DEBOUNCE_MS, tmr.ALARM_SINGLE, button_init)
end
    
button_init()
