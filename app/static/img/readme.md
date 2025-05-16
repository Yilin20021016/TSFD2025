圖片或markdown檔案都是透過 app.py 中的 /content/ 提供
- 圖片都應該放在 static/img 目錄下
- markdown檔案則是在 static/content 目錄下
  
```python
# Route: 動態提供 Markdown 檔案內容（例如 /content/news.md）
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

```


