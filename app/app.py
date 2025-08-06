from flask import Flask, render_template, send_from_directory, abort
import os
print("=== app.py entered ===")

# 建立 Flask 應用實例
app = Flask(__name__)

# 📌 Route: 首頁
@app.route("/")
def index():
    try:
        # 嘗試載入 templates/index.html 並回傳給使用者
        return render_template("index.html")
    except Exception as e:
        # 若發生錯誤，印出錯誤訊息並回傳 500 錯誤頁
        print(f"[Error in / route] {e}")
        return "載入首頁時發生錯誤", 500


# 📌 Route: 動態提供 Markdown 檔案內容（例如 /content/news.md）
@app.route("/content/<path:filename>")
def serve_markdown(filename):
    try:
        # 定義 markdown 檔案所在資料夾（位於 static/content）
        content_dir = os.path.join(app.static_folder, "content")

        # 組合出實際檔案完整路徑
        file_path = os.path.join(content_dir, filename)

        # 若檔案不存在，回傳 404 錯誤
        if not os.path.isfile(file_path):
            print(f"[File Not Found] {file_path}")
            abort(404, description="找不到檔案")

        # 使用 Flask 內建方法回傳靜態檔案
        return send_from_directory(content_dir, filename)
    except Exception as e:
        # 其他錯誤回傳 500，並印出詳細錯誤內容
        print(f"[Error in /content/{filename}] {e}")
        abort(500, description="載入 Markdown 時發生錯誤")

@app.route('/robots.txt')
def robots():
    return send_from_directory(app.static_folder, 'robots.txt')

@app.route('/sitemap.xml')
def sitemap():
    return send_from_directory('static', 'sitemap.xml')

#region: ECPay Demo
import sys
from ecpay_demo.ecpay_payment import ECPayOrder
from datetime import datetime
from flask import request

ecpay = ECPayOrder()

@app.route('/ecpay_demo')
def ecpay_demo():
    try:
        return render_template("ecpay_demo.html")
    except Exception as e:
        print(f"[Error in /ecpay_demo route] {e}")
        return "載入 ECPay Demo 時發生錯誤", 500

@app.route('/checkout', methods=['POST'])
def checkout():
    order_id = 'TEST' + datetime.now().strftime('%Y%m%d%H%M%S')
    item_name = '贊助方案 A'
    total_amount = 100
    return_url = 'https://hookworm-epic-eminently.ngrok-free.app/payment-result'

    order_data = ecpay.generate_order(order_id, total_amount, item_name, return_url)
    print(order_data, file=sys.stderr)
    form_html = f'''
    <form id="ecpay-form" method="post" action="{ecpay.service_url}">
        {''.join([f'<input type="hidden" name="{k}" value="{v}"/>' for k, v in order_data.items()])}
    </form>
    <script>document.getElementById("ecpay-form").submit();</script>
    '''
    return form_html

@app.route('/payment-result', methods=['POST'])
def payment_result():
    # 這裡處理綠界的付款通知
    return '1|OK'

#endregion

# # 📌 Flask 程式主入口
if __name__ == "__main__":
    try:
        # 啟用 debug 模式，變更檔案自動 reload，並顯示錯誤追蹤
         app.run(host='0.0.0.0', debug=True)
    except Exception as e:
         # 若啟動 Flask 本身發生錯誤，顯示錯誤訊息
        print(f"[Flask App Error] {e}")
