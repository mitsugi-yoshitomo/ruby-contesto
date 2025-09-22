require "socket"

a=UDPSocket.new
a.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
while true
  a.send("hogehoge",0,"10.40.255.255", 8080)
  print("hogehoge")
  sleep(1)
end

#10.40.255.255


