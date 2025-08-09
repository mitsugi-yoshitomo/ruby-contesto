# モジュール
import random
import flask

app = flask.Flask(__name__)

# 記事一覧のページ
@app.route('/', methods=['GET'])
def view_articles_route():
  # メッセージを入れる
  random_int = random.randint(1,100)
  # 記事一覧のページを表示する
  return str(random_int)

app.run(host='0.0.0.0',port=8080)

"""
pythonでシステムシェルを開く
#ツール⇒システムシェルを開く
Flaskのインストール
#Flaskインストールコマンド：pip install Flask

"""
