require"pwm"
a = PWM.new(16)
#超高速
a.frequency(5)
a.duty(50)
#高速
a.frequency(5)
a.duty(25)
#普通
a.frequency(5)
a.duty(10)
#遅い
a.frequency(5)
a.duty(6)