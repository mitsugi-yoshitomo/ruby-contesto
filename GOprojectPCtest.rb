require 'sdl2'
require "socket"


#ネット関係
a=UDPSocket.new
a.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)

yaju = 0

# SDL2の初期化
SDL2.init(SDL2::INIT_VIDEO | SDL2::INIT_JOYSTICK)
SDL2::TTF.init

#マスコンの　値ブレーキ　-１～-８・非常　アクセル　１～５
notch = 9

joys = SDL2::Joystick.open(0)
text = SDL2::TTF.open("Oswald-Medium.ttf",100,0)



# ウィンドウを作成
window = SDL2::Window.create("Ruby SDL2 Sample", 100, 100, 1600, 900, SDL2::Window::Flags::SHOWN)
window.fullscreen_mode = SDL2::Window::Flags::FULLSCREEN_DESKTOP

# レンダラーを作成
renderer = window.create_renderer(-1, SDL2::Renderer::Flags::ACCELERATED)
renderer.logical_size = [1600, 900]

# 背景色を設定 (赤: 255, 緑: 0, 青: 0, 不透明度: 255)
renderer.draw_color = [255, 255, 255, 255]

# 背景を塗りつぶし
renderer.clear
renderer.present

#ロードする関数
def load(renderer,filename)
  image_surface =  SDL2::Surface.load(filename)
  texture = renderer.create_texture_from(image_surface)
  image_surface.destroy
  return texture
end

GO = [
"GOprojectPC画像/01.JPG",
"GOprojectPC画像/02.JPG",
"GOprojectPC画像/03.JPG",
"GOprojectPC画像/04.JPG",
"GOprojectPC画像/05.JPG",
"GOprojectPC画像/06.JPG",
"GOprojectPC画像/07.JPG",
"GOprojectPC画像/08.JPG",
"GOprojectPC画像/09.JPG",
"GOprojectPC画像/10.JPG",
"GOprojectPC画像/11.JPG",
"GOprojectPC画像/12.JPG",
"GOprojectPC画像/13.JPG",
"GOprojectPC画像/14.JPG",
"GOprojectPC画像/15.JPG",
"GOprojectPC画像/16.JPG",
"GOprojectPC画像/17.JPG",
"GOprojectPC画像/18.JPG",
"GOprojectPC画像/19.JPG",
]
#画像を一気にロード
GOtexture = []
for s in GO
    GOtexture.append(load(renderer,s))
end

# メーター.pngをロードしてテクスチャ化
texture = load(renderer,"メーター.png")
texture1 = load(renderer,"針.png")
textureON = load(renderer,"ON.png")
textureN = load(renderer,"N.png")
textureOFF = load(renderer,"OFF.png")
center = SDL2::Point.new(125, 125)

guide_texture = load(renderer,"guide.png")
guide_flag = 0
cooltime = 0
is_cooled = false

# 画像の表示位置とサイズを指定
full_screean = SDL2::Rect.new(0, 0, 1600, 900)
dest_rect = SDL2::Rect.new(450, 600, 250, 250)
dest_rectOFF = SDL2::Rect.new(200, 400, 800, 500)
dest_rectON = SDL2::Rect.new(200, 400, 800, 500)
# イベントループ (ウィンドウを閉じるまで待機)
running = true

#距離変数
gool_distance = 183500 # ゴールのゲーム内距離（計3670枚）
speed = 0 # フレーム当たり進むゲーム内距離
distance = 0 # 現在のゲーム内距離
vframe = 0
vfream_per_distance = 50 # 動画1枚当たりゲーム内距離


#加減速度ハッシュ
A_HASH = {-5=>3, -4=>2.5, -3=>2, -2=>1.5, -1=>0.5, 0=>0, 1=>-1, 2=>-1.6, 3=>-2.4, 4=>-3, 5=>-3.5, 6=>-4, 7=>-4.5, 8=>-5, 9=>-5}

#ノッチ段数ハッシュ
N_HASH = {-5=>"P5", -4=>"P4", -3=>"P3", -2=>"P2", -1=>"P1", 0=>" N", 1=>"B1", 2=>"B2", 3=>"B3", 4=>"B4", 5=>"B5", 6=>"B6", 7=>"B7", 8=>"B8", 9=>"EB"}

#スティック角度→ノッチ段数変換関数
def Angle_to_N(a)
  if -32768 == a
    n = 9
  elsif -32768 < a && a <= -31483
    n = 8
  elsif -31483 < a && a <= -27885
    n = 7
  elsif -27885 < a && a <= -24554
    n = 6
  elsif -24554 < a && a <= -20946
    n = 5
  elsif -20946 < a && a <= -17348
    n = 4
  elsif -17348 < a && a <= -14007
    n = 3
  elsif -14007 < a && a <= -10409
    n = 2
  elsif -10409 < a && a <= -6811
    n = 1
  elsif -6811 < a && a < 7802
    n = 0
  elsif 7802 <= a && a < 14044
    n = -1
  elsif -14044 <= a && a < 20025
    n = -2
  elsif -20025 <= a && a < 26226
    n = -3
  elsif -26226 <= a && a < 32767
    n = -4
  else
    n = -5
  end
  return n
end

train_isnt_runnning = true
debugcount = 0
count = 0

while running

  if vframe<3000 || speed>45
    distance = distance + speed.to_i*(-0.05*speed.to_i+4.25)
  else
    distance = distance + speed.to_i*(0.00125*(speed.to_i**2)-0.15*speed.to_i+5.375)
  end
  
  vframe = distance.to_i / vfream_per_distance#distanceが50になったら1フレーム進む
  sleep 0.03

 
  # 描画処理
  renderer.clear
  #描画のシステム具体的に「縦に20枚写したら値を0に戻す。横に10枚写したら値を0戻して次にロードしたものを写す。
  renderer.copy(GOtexture[vframe/200], SDL2::Rect.new(800*(vframe%200/20), 450*(vframe%20), 800, 450), full_screean)
  #メーターの描画プログラム
  renderer.copy(texture, nil, dest_rect)

  #ガイドの表示
  renderer.copy(guide_texture, SDL2::Rect.new(0, 900*guide_flag, 1600, 900), full_screean)
  
  #スピードを表示
  text1 = text.render_blended("km/h",[0,255,0])
  text1_ = renderer.create_texture_from(text1)
  renderer.copy(text1_, nil, SDL2::Rect.new(885, 785, 120, 75))

  text2 = text.render_blended((speed.to_i).to_s,[0,255,0])
  text2_ = renderer.create_texture_from(text2)
  if speed.to_i < 10
    renderer.copy(text2_, nil, SDL2::Rect.new(800, 680, 80, 200))
  else
    renderer.copy(text2_, nil, SDL2::Rect.new(720, 680, 160, 200))
  end

  #ノッチを表示
  text3 = text.render_blended(N_HASH[notch],[0,255,0])
  text3_ = renderer.create_texture_from(text3)
  renderer.copy(text3_, nil, SDL2::Rect.new(250, 680, 150, 200))
  
  #OFF描画
  
  if notch >= 9
    renderer.copy(textureON, nil, SDL2::Rect.new(50, 400, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(50, 400, 800, 500))
  end 
  if notch >= 8
    renderer.copy(textureON, nil, SDL2::Rect.new(50, 430, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(50, 430, 800, 500))
  end
  if notch >= 7
    renderer.copy(textureON, nil, SDL2::Rect.new(50, 460, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(50, 460, 800, 500))     
  end
  if notch >= 6
    renderer.copy(textureON, nil, SDL2::Rect.new(50, 490, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(50, 490, 800, 500))
  end
  if notch >= 5
    renderer.copy(textureON, nil, SDL2::Rect.new(50, 520, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(50, 520, 800, 500))
  end
  if notch >= 4
    renderer.copy(textureON, nil, SDL2::Rect.new(50, 550, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(50, 550, 800, 500))
  end
  if notch >= 3
    renderer.copy(textureON, nil, SDL2::Rect.new(50, 580, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(50, 580, 800, 500))
  end
  if notch >= 2
    renderer.copy(textureON, nil, SDL2::Rect.new(50, 610, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(50, 610, 800, 500))
  end
  if notch >= 1
    renderer.copy(textureON, nil, SDL2::Rect.new(50, 640, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(50, 640, 800, 500))
  end
  renderer.copy(textureN, nil, SDL2::Rect.new(50, 670, 800, 500))
  if notch <= -1
    renderer.copy(textureON, nil, SDL2::Rect.new(50, 700, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(50, 700, 800, 500))
  end
  if notch <= -2
    renderer.copy(textureON, nil, SDL2::Rect.new(50, 730, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(50, 730, 800, 500))
  end
  if notch <= -3
    renderer.copy(textureON, nil, SDL2::Rect.new(50, 760, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(50, 760, 800, 500))
  end
  if notch <= -4
    renderer.copy(textureON, nil, SDL2::Rect.new(50, 790, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(50, 790, 800, 500))
  end
  if notch <= -5
    renderer.copy(textureON, nil, SDL2::Rect.new(50, 820, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(50, 820, 800, 500))
  end
  
  #ON描画
  #renderer.copy(textureON, nil, dest_rectON)
  #針の描画のプログラム
  renderer.copy_ex(texture1, nil, dest_rect, (speed*113/60)-113, center, SDL2::Renderer::FLIP_NONE)

  renderer.present


  while event = SDL2::Event.poll#eventに,SDL2::Event.pollクラスを入れてる
    case event
    when SDL2::Event::Quit
      running = false
    when SDL2::Event::JoyAxisMotion
      notch = Angle_to_N(joys.axis(1))
    end
    # puts event.class
  end

  if guide_flag == 0 && notch < 0
    guide_flag = 1
  end
  if guide_flag == 1 && notch == -5 && speed > 35
    guide_flag = 2
  end
  if guide_flag == 2 && notch == 0 && vframe > 2400
    guide_flag = 3
  end
  if guide_flag == 3 && notch > 0 && cooltime == 0 && is_cooled == false
    cooltime = 100
  elsif is_cooled
    guide_flag = 4
  end

  #速度計算（秒間約33回）
  a_of_flame = A_HASH[notch] * 0.03
  resistance_of_flame = (speed ** 2 * 0.00008 + speed * 0.03) * 0.03
  vvalue_of_flame = a_of_flame - resistance_of_flame
  if train_isnt_runnning && notch >= 0
    speed = 0.0
  elsif train_isnt_runnning && notch < 0
    speed = speed + vvalue_of_flame
    train_isnt_runnning = false
  elsif train_isnt_runnning == false && notch < 0
    speed = speed + vvalue_of_flame
  elsif train_isnt_runnning == false && notch == 0
    speed = speed + vvalue_of_flame / 4
  elsif train_isnt_runnning == false && notch > 0
    if speed > 0.0
      speed = speed + vvalue_of_flame
    else
      train_isnt_runnning = true
    end  
  end
  
  if cooltime > 0
    cooltime = cooltime - 1
    if cooltime == 0
      is_cooled = true
    end
  end
  debugcount = debugcount + 1
  if debugcount == 33
    puts(vframe)
    debugcount = 0
  end
  count = count + 1
  if count == 3
    a.send(speed.to_s,0,"10.40.255.255", 8080)
    count = 0
  end  
  #yaju = yaju + 1
  #puts(yaju)
end

# SDL2の終了処理
texture.destroy
renderer.destroy
window.destroy
SDL2.quit




