require"pwm"
require"net"
CYW43.init("JP")
CYW43.enable_sta_mode()
CYW43.connect_timeout( "ibaraki",  "ibarakiken", 0x00400004)
CYW43.connect_timeout( "ibaraki",  "ibarakiken", 0x00400004)
ssid = "ibaraki"
import requests
import time
url="http://127.0.0.1:8080"
a = PWM.new(16)
sp=0
a.frequency(5)
while True:
    host = "10.40.251.45"
    path = "/"
    req =  "GET #{path} HTTP/1.1\r\n"
    req += "Host: #{host}\r\n"
    req += "Connection: close\r\n"
    req += "\r\n"
    data = Net::HTTPUtil.format_response(TCPClient.request(host, 8080, req, false))
    #上のコードがし少し違う
    puts data
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
インターネットつなぐコード
require"pwm"
require"net"
irb>CYW43.init("JP")
=> 0
irb>
irb> CYW43.enable_sta_mode()
=> true
irb> ssid = "ibaraki"
=> "ibaraki"
irb> CYW43.connect_timeout( "ibaraki",  "ibarakiken", 0x00400004)
=> CYW43_arch_wifi_connect_timeout_ms() failed (CYW43::ConnectTimeout)
irb> CYW43.connect_timeout( "ibaraki",  "ibarakiken", 0x00400004)
Net::HTTPClient.new("abehiroshi.la.coocan.jp:80")#
                     ^                      ^^ポート番号^

URLメモ http://abehiroshi.la.coocan.jp/
               ^     ホスト名        ^^パス^
"""