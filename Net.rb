require "socket"

a=UDPSocket.new
a.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
a.send("aaaa",0,"10.40.255.255", 8080)

#10.40.255.255


