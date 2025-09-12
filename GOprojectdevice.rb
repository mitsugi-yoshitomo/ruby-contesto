
#irb
require"pwm"
require"net"
ssid = "system"   #"Lyric_River"            #"ibaraki"
psfrees = "systemken" #"lyricriver"            #"ibarakiken"
wpa2 = 0x00400004
puts("通信始め")
CYW43.init("JP")
CYW43.enable_sta_mode()
CYW43.connect_timeout(ssid,  psfrees, wpa2)
CYW43.connect_timeout(ssid,  psfrees, wpa2)
url="http://10.40.247.96:8080"
a = PWM.new(16)
is_not_running = true
speed=0
dt=0
a.frequency(100)
s = Net::UDPServer.new(8080)

puts("IPアドレス送ってる")
host = "10.40.247.96"
path = "/"
req =  "GET #{path} HTTP/1.1\r\n"
req += "Host: #{host}\r\n"
req += "Connection: close\r\n"
req += "\r\n"
Net::HTTPUtil.format_response(Net::TCPClient.request("10.40.251.45", 8080, "GET / HTTP/1.1\r\n\r\n", false))

while true do
    puts("データ取ってる")
    data = s.receive()#シガワが送ってきた値
    puts("データ取ったよ")
    puts(data)
    if data != nil
        speed = data.to_i
    end
    #上のコードがし少し違う
    if is_not_running == true && speed!=0
        dt=24
        is_not_running = false
    elsif is_not_running == false && speed==0
        dt=0
        is_not_running = true
    else
        dt=speed
    end
    puts(dt)
    
=begin    if sp < dt
        puts("速度変えてるよプラス")
        sp=sp+5
        a.duty(dt)
        Machine.busy_wait_ms(1000)
    elsif sp > dt
        puts("速度変えてるよマイナス")
        #sp=sp-5
        a.duty(dt)
        Machine.busy_wait_ms(1000)
    elsif sp == dt
        a.duty(dt)
    end
    puts(sp)
=end


    a.duty(dt)
    Machine.busy_wait_ms(100)

end

=begin
これでpicoRubyをWi-Fiに繋げることができる#https://picoruby.github.io/wifi#supported-oses-and-browsers
シェルはコマンドが打てる場所
いろいろ書いてあるよ#https://docs.python.org/ja/3.13/py-modindex.html#https://picoruby.github.io/Net_HTTPClient.html
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
=end