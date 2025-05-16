#!/bin/bash
set -e

echo "🔧 Initializing container..."

# 確保 /app 存在
mkdir -p /app

# 預設 app.py
if [ ! -f /app/app.py ]; then
  echo "📝 /app/app.py 不存在，自動建立中..."
  cat > /app/app.py <<EOF
from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html')

if __name__ == '__main__':
    app.run()
EOF
fi

# 預設 templates/index.html
if [ ! -f /app/templates/index.html ]; then
  echo "📝 /app/templates/index.html 不存在，自動建立中..."
  mkdir -p /app/templates
  cat > /app/templates/index.html <<EOF
<!doctype html>
<html>
<head>
  <title>Hello Flask</title>
  <link rel='stylesheet' href='/static/style.css'>
</head>
<body>
  <h1>Hello, Flask!</h1>
</body>
</html>
EOF
fi

# 預設 static/style.css
if [ ! -f /app/static/style.css ]; then
  echo "📝 /app/static/style.css 不存在，自動建立中..."
  mkdir -p /app/static
  echo "body { font-family: Arial; background-color: #f8f8f8; }" > /app/static/style.css
fi

# 設定 root 密碼
echo "root:${ROOTPWD}" | chpasswd

# 啟動 SSH
service ssh start

# 切換到 /app 並啟動 Flask
cd /app
echo "🚀 啟動 Flask 中..."
exec flask run --host=0.0.0.0 --port=5000
