## 使用方式

1. 透過以下指令建立docker image

```
docker build -t flask-ssh-app:1.0 .
```

2. 使用Docker Desktop，將此 image 啟動成 container。

![Docker esktop](./launch_via_DockerDesktop.jpg)

3. container "每次" 啟動的時候都會檢查工作目錄下 Flask的基本檔案結構，並自動執行 app.py。 如果沒有基本結構，container 會自動產生給開發者參考。

4. 如果需要增加 python模組，可透過 SSH 以 root身份 登入去調整。

## remote_update 使用流程

1. 將更新的資訊推送至 GitHub。

2. 在本地端 powershell 輸入

```powershell
ssh-keygen -t rsa -b 4096
```
接著會出現
```powershell
Enter file in which to save the key (/Users/yourname/.ssh/id_rsa): [直接按 Enter 使用預設]
```
然後它會生成：

- id_rsa（私鑰）

- id_rsa.pub（公鑰）

這些會被儲存在 C:\Users\你的帳號\.ssh 下。  

3. 把公鑰複製到遠端
```bash
# 登入 VM
ssh ncume_web@140.115.68.3
```
```bash
# 執行以下：
nano ~/.ssh/authorized_keys
# 把你本地的 id_rsa.pub 裡的內容複製進去（整串）
```
最後透過
```
ssh -i ~/.ssh/id_rsa ncume_web@140.115.68.3
```
就可以直接連線。

### 每次更新只需要在 powershell 下，執行 remote_update.ps1，等待跑完會自動更新虛擬機端。