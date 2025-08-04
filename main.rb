require"pwm"
import requests
import time
url="http://127.0.0.1:8080"
a = PWM.new(16)
sp=0
a.frequency(5)
while True:
    dt=requests.get(random_int)#シガワが送ってきた値
    while sp < dt
        sp=sp+1
        a.duty(sp)
        time.sleep(0.5)
    while sp > dt
        sp=sp-1
        a.duty(sp)
        time.sleep(0.5)
    while sp == dt
        a.duty(sp)

"""
これでpicoRubyをWi-Fiに繋げることができる#https://picoruby.github.io/wifi#supported-oses-and-browsers
シェルはコマンドが打てる場所
いろいろ書いてあるよ#https://picoruby.github.io/Net_HTTPClient.html
"""