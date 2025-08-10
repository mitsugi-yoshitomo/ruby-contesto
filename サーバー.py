# モジュール
import random
import flask
import time

app = flask.Flask(__name__)

# 記事一覧のページ
@app.route('/', methods=['GET'])
def view_articles_route():
  # メッセージを入れる
  time_int = int(time.time())%100
  # 記事一覧のページを表示する
  #time.sleep(3)
  return str(time_int)


app.run(host='0.0.0.0',port=8080)

"""
pythonでシステムシェルを開く
#ツール⇒システムシェルを開く
Flaskのインストール
#Flaskインストールコマンド：pip install Flask

"""
