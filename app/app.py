from flask import Flask, render_template, send_from_directory, abort, request
import sys
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
        print(f"[Error in / route] {e}", file=sys.stderr)
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
            print(f"[File Not Found] {file_path}", file=sys.stderr)
            abort(404, description="找不到檔案")

        # 使用 Flask 內建方法回傳靜態檔案
        return send_from_directory(content_dir, filename)
    except Exception as e:
        # 其他錯誤回傳 500，並印出詳細錯誤內容
        print(f"[Error in /content/{filename}] {e}", file=sys.stderr)
        abort(500, description="載入 Markdown 時發生錯誤")

@app.route('/robots.txt')
def robots():
    return send_from_directory(app.static_folder, 'robots.txt')

@app.route('/sitemap.xml')
def sitemap():
    return send_from_directory('static', 'sitemap.xml')

#region: ECPay Demo

from ecpay_demo.ecpay_payment import ECPayOrder, OrderInfo

ecpay = ECPayOrder()

@app.route('/ecpay_demo')
def ecpay_demo():
    try:
        return render_template("ecpay_demo.html")
    except Exception as e:
        print(f"[Error in /ecpay_demo route] {e}", file=sys.stderr)
        return "載入 ECPay Demo 時發生錯誤", 500

@app.route('/checkout', methods=['POST'])
def checkout():
    try:
        request_data = request.form
        order = OrderInfo(
            paper_id=request_data.get('paper-id', ''),
            name=request_data.get('name', ''),
            phone_number=request_data.get('phone-number', ''),
            receipt=request_data.get('receipt', request_data.get('name', '')),
            tax_id=request_data.get('tax-id', '00000000'),
            num_meals=int(request_data.get('num-meal', 0)),
            num_normal=int(request_data.get('num-normal', 0)),
            num_students=int(request_data.get('num-student', 0)),
            trade_desc='TestOrder'
        )
        order_data = ecpay.generate_order(order)
        form_html = f'''
        <form id="ecpay-form" method="post" action="{ecpay.service_url}">
            {''.join([f'<input type="hidden" name="{k}" value="{v}"/>' for k, v in order_data.items()])}
        </form>
        <script>document.getElementById("ecpay-form").submit();</script>
        '''
        return form_html
    except Exception as e:
        print(f"[Error in /checkout route] {e}", file=sys.stderr)
        return "處理訂單時發生錯誤", 500

@app.route('/payment-result', methods=['POST'])
def payment_result():
    try:
        # 這裡處理綠界的付款通知
        print("[Payment Result] Received payment notification", file=sys.stderr)
        request_data = request.form.to_dict()
        print(f"[Payment Result] request_data: {request_data}", file=sys.stderr)
        return '1|OK'
    except Exception as e:
        print(f"[Error in /payment-result route] {e}", file=sys.stderr)
        return "處理付款結果時發生錯誤", 500

#endregion

# # 📌 Flask 程式主入口
if __name__ == "__main__":
    try:
        # 啟用 debug 模式，變更檔案自動 reload，並顯示錯誤追蹤
         app.run(host='0.0.0.0', debug=False)
    except Exception as e:
         # 若啟動 Flask 本身發生錯誤，顯示錯誤訊息
        print(f"[Flask App Error] {e}", file=sys.stderr)
