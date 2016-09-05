BUTTON = 7
BUTTON_DEBOUNCE_MS = 5000 -- debounce and rate-limit at once

host = {
  address = "192.168.23.42";
  port = 23421;
}

function button_init()
  gpio.trig(BUTTON, "down", button_callback)
  gpio.mode(BUTTON, gpio.INT)
end

function rimshot ()
  socket = net.createConnection(net.UDP, 0)
  socket:connect(host.port, host.address)
  socket:send("rimshot\n")
  socket:close()
  print("ba-dumm-tss!")
end

function button_callback()
  gpio.mode(BUTTON, gpio.INPUT)
  tmr.alarm(0, BUTTON_DEBOUNCE_MS, tmr.ALARM_SINGLE, button_init)
  rimshot()
end

button_init()
