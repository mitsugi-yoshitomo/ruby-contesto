require 'sdl2'
require "socket"

while true
  #定数・関数定義

  A_HASH = {
    9=>-5,
    8=>-5,
    7=>-4.5,
    6=>-4,
    5=>-3.5,
    4=>-3,
    3=>-2.4,
    2=>-1.6,
    1=>-1,
    0=>0,
    -1=>0.5,
    -2=>1.5,
    -3=>2,
    -4=>2.5,
    -5=>3
  }

  N_HASH = {
    9=>"EB", 
    8=>"B8",
    7=>"B7",
    6=>"B6",
    5=>"B5",
    4=>"B4",
    3=>"B3",
    2=>"B2",
    1=>"B1",
    0=>" N",
    -1=>"P1",
    -2=>"P2",
    -3=>"P3",
    -4=>"P4",
    -5=>"P5"
  }

  MOVIEING_IMAGES = [
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

  #変数宣言

  running = true
  notchlock = false
  train_isnt_runnning = true
  is_cooled = false

  notch = 9
  guide_flag = 0
  cooltime = 0
  sleepcount = 0
  debugcount = 0
  count = 0
  speed = 0
  distance = 0
  vframe = 0
  gool_distance = 183500 # ゴールのゲーム内距離（計3670枚）

  texture_movie = []

  #ライブラリ初期設定

  udp = UDPSocket.new
  udp.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)

  SDL2.init(SDL2::INIT_VIDEO | SDL2::INIT_JOYSTICK)
  SDL2::TTF.init

  joys = SDL2::Joystick.open(0)
  text = SDL2::TTF.open("Oswald-Medium.ttf", 100, 0)

  #ウィンドウを作成
  window = SDL2::Window.create("Ruby SDL2", 100, 100, 1600, 900, SDL2::Window::Flags::SHOWN)
  window.fullscreen_mode = SDL2::Window::Flags::FULLSCREEN_DESKTOP

  #レンダラーを作成
  renderer = window.create_renderer(-1, SDL2::Renderer::Flags::ACCELERATED)
  renderer.logical_size = [1600, 900]

  #背景色を設定
  renderer.draw_color = [0, 0, 0, 255]
  renderer.clear
  renderer.present

  #動画をローディング
  def load(renderer,filename)
    image_surface =  SDL2::Surface.load(filename)
    texture = renderer.create_texture_from(image_surface)
    image_surface.destroy
    return texture
  end
  for i in MOVIEING_IMAGES
      texture_movie.append(load(renderer,i))
  end

  #アセットをローディング
  texture_meter = load(renderer,"meter.png")
  texture_pointer = load(renderer,"pointer.png")
  texture_notch_ON = load(renderer,"ON.png")
  texture_notch_N = load(renderer,"N.png")
  texture_notch_OFF = load(renderer,"OFF.png")
  texture_guide = load(renderer,"guide.png")

  center = SDL2::Point.new(125, 125)
  full_screean = SDL2::Rect.new(0, 0, 1600, 900)
  dest_rect = SDL2::Rect.new(450, 600, 250, 250)

  # イベントループ（ウィンドウを閉じるまで待機）
  while running
    if vframe < 3000 || speed > 45
      distance = distance + speed.to_i*(-0.05*speed.to_i+4.25)
    else
      distance = distance + speed.to_i*(0.00125*(speed.to_i**2)-0.15*speed.to_i+5.375)
    end

    vframe = distance.to_i / 50 #distanceが50になったら1フレーム進む
    sleep 0.03
  
    #描画処理
    renderer.clear

    #描画のシステム - 縦に20枚写したら値を0に戻す → 横に10枚写したら値を0に戻して次にロードしたものを写す
    renderer.copy(texture_movie[vframe/200], SDL2::Rect.new(800*(vframe%200/20), 450*(vframe%20), 800, 450), full_screean)

    #メーターを表示
    renderer.copy(texture_meter, nil, dest_rect)

    #ガイドを表示
    renderer.copy(texture_guide, SDL2::Rect.new(0, 900*guide_flag, 1600, 900), full_screean)
    
    #スピードを表示
    text1 = text.render_blended("km/h", [0, 255, 0])
    text1_ = renderer.create_texture_from(text1)
    renderer.copy(text1_, nil, SDL2::Rect.new(885, 785, 120, 75))

    #残り距離を表示
    gool_distancet1 = gool_distance - distance
    text4 = text.render_blended((((3355-vframe)/3).floor).to_s + "m", [0, 255, 0])
    text4_ = renderer.create_texture_from(text4)
    renderer.copy(text4_, nil, SDL2::Rect.new(1300, 385, 200, 150))

    text2 = text.render_blended((speed.to_i).to_s, [0, 255, 0])
    text2_ = renderer.create_texture_from(text2)
    if speed.to_i < 10
      renderer.copy(text2_, nil, SDL2::Rect.new(800, 680, 80, 200))
    else
      renderer.copy(text2_, nil, SDL2::Rect.new(720, 680, 160, 200))
    end

    #現在段数を表示
    text3 = text.render_blended(N_HASH[notch],[0, 255, 0])
    text3_ = renderer.create_texture_from(text3)
    renderer.copy(text3_, nil, SDL2::Rect.new(250, 680, 150, 200))
    
    #OFF描画
    if notch >= 9
      renderer.copy(texture_notch_ON, nil, SDL2::Rect.new(50, 400, 800, 500))
    else
      renderer.copy(texture_notch_OFF, nil, SDL2::Rect.new(50, 400, 800, 500))
    end 
    if notch >= 8
      renderer.copy(texture_notch_ON, nil, SDL2::Rect.new(50, 430, 800, 500))
    else
      renderer.copy(texture_notch_OFF, nil, SDL2::Rect.new(50, 430, 800, 500))
    end
    if notch >= 7
      renderer.copy(texture_notch_ON, nil, SDL2::Rect.new(50, 460, 800, 500))
    else
      renderer.copy(texture_notch_OFF, nil, SDL2::Rect.new(50, 460, 800, 500))     
    end
    if notch >= 6
      renderer.copy(texture_notch_ON, nil, SDL2::Rect.new(50, 490, 800, 500))
    else
      renderer.copy(texture_notch_OFF, nil, SDL2::Rect.new(50, 490, 800, 500))
    end
    if notch >= 5
      renderer.copy(texture_notch_ON, nil, SDL2::Rect.new(50, 520, 800, 500))
    else
      renderer.copy(texture_notch_OFF, nil, SDL2::Rect.new(50, 520, 800, 500))
    end
    if notch >= 4
      renderer.copy(texture_notch_ON, nil, SDL2::Rect.new(50, 550, 800, 500))
    else
      renderer.copy(texture_notch_OFF, nil, SDL2::Rect.new(50, 550, 800, 500))
    end
    if notch >= 3
      renderer.copy(texture_notch_ON, nil, SDL2::Rect.new(50, 580, 800, 500))
    else
      renderer.copy(texture_notch_OFF, nil, SDL2::Rect.new(50, 580, 800, 500))
    end
    if notch >= 2
      renderer.copy(texture_notch_ON, nil, SDL2::Rect.new(50, 610, 800, 500))
    else
      renderer.copy(texture_notch_OFF, nil, SDL2::Rect.new(50, 610, 800, 500))
    end
    if notch >= 1
      renderer.copy(texture_notch_ON, nil, SDL2::Rect.new(50, 640, 800, 500))
    else
      renderer.copy(texture_notch_OFF, nil, SDL2::Rect.new(50, 640, 800, 500))
    end
    renderer.copy(texture_notch_N, nil, SDL2::Rect.new(50, 670, 800, 500))
    if notch <= -1
      renderer.copy(texture_notch_ON, nil, SDL2::Rect.new(50, 700, 800, 500))
    else
      renderer.copy(texture_notch_OFF, nil, SDL2::Rect.new(50, 700, 800, 500))
    end
    if notch <= -2
      renderer.copy(texture_notch_ON, nil, SDL2::Rect.new(50, 730, 800, 500))
    else
      renderer.copy(texture_notch_OFF, nil, SDL2::Rect.new(50, 730, 800, 500))
    end
    if notch <= -3
      renderer.copy(texture_notch_ON, nil, SDL2::Rect.new(50, 760, 800, 500))
    else
      renderer.copy(texture_notch_OFF, nil, SDL2::Rect.new(50, 760, 800, 500))
    end
    if notch <= -4
      renderer.copy(texture_notch_ON, nil, SDL2::Rect.new(50, 790, 800, 500))
    else
      renderer.copy(texture_notch_OFF, nil, SDL2::Rect.new(50, 790, 800, 500))
    end
    if notch <= -5
      renderer.copy(texture_notch_ON, nil, SDL2::Rect.new(50, 820, 800, 500))
    else
      renderer.copy(texture_notch_OFF, nil, SDL2::Rect.new(50, 820, 800, 500))
    end
    
    renderer.copy_ex(texture_pointer, nil, dest_rect, (speed*113/60)-113, center, SDL2::Renderer::FLIP_NONE)

    renderer.present

    #イベント管理 - ゲームパッドの入力を受け取る
    while event = SDL2::Event.poll
      case event
      when SDL2::Event::Quit
        running = false
      when SDL2::Event::JoyAxisMotion
        if not notchlock
          notch = Angle_to_N(joys.axis(1))
        end
        puts(notch)
      end
    end

    #ガイド表示フラグの管理
    if guide_flag == 0 && notch < 0
      guide_flag = 1
    end
    if guide_flag == 1 && notch == -5 && speed > 35
      guide_flag = 2
    end
    if guide_flag == 2 && notch == 0 && vframe > 2400
      guide_flag = 3
    end
    if guide_flag == 3 && (notch > 0 || vframe > 3000) && cooltime == 0 && is_cooled == false && notchlock == false
      cooltime = 100
    elsif guide_flag == 3 && is_cooled
      guide_flag = 4
    end
    if guide_flag == 4 || guide_flag == 6 || (vframe > 3000 && speed > 50)
      if vframe > 3000 && speed > 50
        guide_flag = 6
        notch = 9
        notchlock = true
      elsif ((vframe > 3155 && speed > 30) || vframe > 3455) && notchlock == false
        guide_flag = 6
        notch = 7
        notchlock = true
      elsif speed == 0
        guide_flag = 5
      end
    end
    if guide_flag == 5
      sleepcount = sleepcount + 1
      if sleepcount == 330
        running = false
      end
    end
    if cooltime > 0
      cooltime = cooltime - 1
      if cooltime == 0
        is_cooled = true
      end
    end

    #速度計算（秒間約33回）
    a_of_frame = A_HASH[notch] * 0.03
    resistance_of_frame = (speed ** 2 * 0.00008 + speed * 0.03) * 0.03
    vvalue_of_frame = a_of_frame - resistance_of_frame
    if train_isnt_runnning && notch >= 0
      speed = 0.0
    elsif train_isnt_runnning && notch < 0
      speed = speed + vvalue_of_frame
      train_isnt_runnning = false
    elsif train_isnt_runnning == false && notch < 0
      speed = speed + vvalue_of_frame
    elsif train_isnt_runnning == false && notch == 0
      speed = speed + vvalue_of_frame / 4
    elsif train_isnt_runnning == false && notch > 0
      if speed > 0.0
        speed = speed + vvalue_of_frame
      else
        train_isnt_runnning = true
      end  
    end

    count = count + 1
    if count == 3
      udp.send(speed.to_s,0,"10.40.255.255", 8080)
      count = 0
    end  
    
    debugcount = debugcount + 1
    if debugcount == 33
      puts(vframe)
      debugcount = 0
    end
  end


text.destroy
renderer.destroy
window.destroy
end

# SDL2の終了処理
#texture.destroy
#renderer.destroy
#window.destroy
SDL2.quit