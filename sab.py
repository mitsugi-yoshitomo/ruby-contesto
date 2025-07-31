require"pwm"
import requests
a = PWM.new(16)
import time
sp=0
a.frequency(5)
while True:
    dt=requests.get(random_int)#シガワが送ってきた値
    while sp < dt:
        sp=sp+1
        a.duty(sp)
        time.sleep(0.5)
    while sp > dt:
        sp=sp-1
        a.duty(sp)
        time.sleep(0.5)
    while sp == dt:
        a.duty(sp)
