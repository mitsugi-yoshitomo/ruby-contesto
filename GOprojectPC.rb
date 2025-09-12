require 'sdl2'

# SDL2の初期化
SDL2.init(SDL2::INIT_VIDEO)

#マスコンの　値ブレーキ　-１～-８・非常　アクセル　１～５
notch = 0


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
center = SDL2::Point.new(250, 250)
# 画像の表示位置とサイズを指定
full_screean = SDL2::Rect.new(0, 0, 1600, 900)
dest_rect = SDL2::Rect.new(900, 150, 500, 500)
dest_rectOFF = SDL2::Rect.new(200, 400, 800, 500)
dest_rectON = SDL2::Rect.new(200, 400, 800, 500)
# イベントループ (ウィンドウを閉じるまで待機)
running = true

#距離変数
gool_distance = 183500 # ゴールのゲーム内距離
speed = 0.0 # フレーム当たり進むゲーム内距離
distance = 0 # 現在のゲーム内距離
vfream_per_distance = 50 # 動画1枚当たりゲーム内距離

#加減速度ハッシュ
A_HASH = {-5=>3, -4=>2.5, -3=>2, -2=>1.5, -1=>0.5, 0=>0, 1=>-1, 2=>-1.6, 3=>-2.4, 4=>-3, 5=>-3.5, 6=>-4, 7=>-4.5, 8=>-5, 9=>-5}

train_isnt_runnning = true
debugcount = 0

while running
  distance = distance + speed.to_i #スピードが1ならdistanceも1増える
  vframe = distance / vfream_per_distance#distanceが50になったら1フレーム進む
  sleep 0.03

 
  # 描画処理
  renderer.clear
  #描画のシステム具体的に「縦に20枚写したら値を0に戻す。横に10枚写したら値を0戻して次にロードしたものを写す。
  renderer.copy(GOtexture[vframe/200], SDL2::Rect.new(800*(vframe%200/20), 450*(vframe%20), 800, 450), full_screean)
  #メーターの描画プログラム
  renderer.copy(texture, nil, dest_rect)
  #OFF描画
  
  if notch >= 9
    renderer.copy(textureON, nil, SDL2::Rect.new(200, 210, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(200, 210, 800, 500))
  end 
  if notch >= 8
    renderer.copy(textureON, nil, SDL2::Rect.new(200, 240, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(200, 240, 800, 500))
  end
  if notch >= 7
    renderer.copy(textureON, nil, SDL2::Rect.new(200, 270, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(200, 270, 800, 500))     
  end
  if notch >= 6
    renderer.copy(textureON, nil, SDL2::Rect.new(200, 300, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(200, 300, 800, 500))
  end
  if notch >= 5
    renderer.copy(textureON, nil, SDL2::Rect.new(200, 330, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(200, 330, 800, 500))
  end
  if notch >= 4
    renderer.copy(textureON, nil, SDL2::Rect.new(200, 360, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(200, 360, 800, 500))
  end
  if notch >= 3
    renderer.copy(textureON, nil, SDL2::Rect.new(200, 390, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(200, 390, 800, 500))
  end
  if notch >= 2
    renderer.copy(textureON, nil, SDL2::Rect.new(200, 420, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(200, 420, 800, 500))
  end
  if notch >= 1
    renderer.copy(textureON, nil, SDL2::Rect.new(200, 450, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(200, 450, 800, 500))
  end
  renderer.copy(textureN, nil, SDL2::Rect.new(200, 480, 800, 500))
  if notch <= -1
    renderer.copy(textureON, nil, SDL2::Rect.new(200, 510, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(200, 510, 800, 500))
  end
  if notch <= -2
    renderer.copy(textureON, nil, SDL2::Rect.new(200, 540, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(200, 540, 800, 500))
  end
  if notch <= -3
    renderer.copy(textureON, nil, SDL2::Rect.new(200, 570, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(200, 570, 800, 500))
  end
  if notch <= -4
    renderer.copy(textureON, nil, SDL2::Rect.new(200, 600, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(200, 600, 800, 500))
  end
  if notch <= -5
    renderer.copy(textureON, nil, SDL2::Rect.new(200, 630, 800, 500))
  else
    renderer.copy(textureOFF, nil, SDL2::Rect.new(200, 630, 800, 500))
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
    when SDL2::Event::KeyDown#KeyDownのクラスである場合
      case event.sym
      when SDL2::Key::UP#数値がUPである場合
        if not notch == 9
          notch = notch + 1
                 
        end
      when SDL2::Key::DOWN#数値がDOWNである場合
        if not notch == -5
          notch = notch - 1
          
        end
      end
    end
    puts event.class
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

  elsif train_isnt_runnning == false && notch > 0
    if speed > 0.0
      speed = speed + vvalue_of_flame
    else
      train_isnt_runnning = true
    end  
  end

  debugcount = debugcount + 1
  if debugcount == 33
    puts(speed, vvalue_of_flame*33)
    debugcount = 0
  end
end

# SDL2の終了処理
texture.destroy
renderer.destroy
window.destroy
SDL2.quit



