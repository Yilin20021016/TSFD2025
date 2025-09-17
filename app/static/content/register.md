

## 註冊


<body>
    <div class="table-wrapper">
        <table class="table">
            <thead>
                <tr>
                    <th style="width: 30%;">日期</th>
                    <th style="width: 20%;">一般投稿(每篇)</th>
                    <th style="width: 20%;">學生優惠投稿(每篇)</th>
                    <th style="width: 20%;">會議參與者(每人)</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>9/25 前(早鳥)</td>
                    <td>NT 6,000</td>
                    <td>NT 4,000</td>
                    <td>NT 2,000</td>
                </tr>
                <tr>
                    <td>9/26-10/05</td>
                    <td>NT 7,000</td>
                    <td>NT 5,000</td>
                    <td>NT 2,000</td>
                </tr>
                <tr>
                    <td>10/05 後</td>
                    <td>NT 8,000</td>
                    <td>NT 6,000</td>
                    <td>NT 2,000</td>
                </tr>
            </tbody>
        </table>
    </div>

<button class="btn btn-primary mb-3" style="font-size: 2vh" type="button" data-bs-toggle="collapse" data-bs-target="#registerSection" aria-expanded="false" aria-controls="registerSection">查看註冊流程與繳費程序</button>

<div class="collapse" id="registerSection">
  <div class="card card-body">

  ### 註冊流程
  * 作者收到 **「審查通知」** 後即可進行繳費。
  * 每篇稿件須至少一人繳交註冊費，單一註冊僅有一份兩日餐券。如有其他作者或作者家屬與會，需加購 __會議參與者__。
  * 未投稿任何稿件，註冊身分為 __會議參與者__
  * 每位會議參與者皆附餐券
  <br/>

  ### 繳費程序（含早鳥優惠、一般報名）
  1. 請匯款至以下帳號    
  【抬頭：台灣流體力學學會】  
  【銀行代碼：玉山銀行808，新竹分行】  
  【銀行帳號0060-940-039027】

  2. 上傳匯款證明，<a href="https://docs.google.com/forms/d/e/1FAIpQLSd7E7SS5EIcSSjrUA9GMeKxl6BH5CoViLYSAYvoZb4xPfFVYA/viewform" target="_blank">點我線上填單</a>  

  **請執行上述1、2項，方才完成註冊作業。**
  <br/><br/>

  ##### 訂房相關請至<a href="#venue" onclick="loadMarkdown('content/venue.md')">會場資訊</a>查看
  為確保順利訂房，請於 __2025年9月30日（含）__ 前 完成預約手續。

  </div>
</div>

<div hidden>
    <a class="registration-btn"
    href="#register" style = "pointer-events: none" alt = "Sign in / Registration now">
    註冊尚未開放
    </a>
</div>

</body>

<style>
          /* 只影響 Markdown 區域的所有表格 --------------------------- */

            /* ============  外框（負責寬度、圓角、陰影、捲軸） ============ */
            .table-wrapper{
            width:fit-content;     /* 寬度 = 內容本身 (表格) */
            margin: left;             /* 置左 */ 
            border: 0.1vh solidrgba(213, 213, 213, 0.45);
            border-radius: 2vh;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.38);
            }

          .md-content table,
          #markdown-container table{
            width: 100%;                /* 撐到跟外框一樣寬 */
            border-collapse: collapse;  /* 表頭／內容線條連在一起 */
            overflow:auto;
            box-shadow:0 3px 20px rgba(0,0,0,.08);
            font-family:"Segoe UI",Roboto,"Helvetica Neue",Arial,"Noto Sans",sans-serif;
            font-size:1rem;                     /* 16px，可視需要調整 */
            color:#333;
          }

          /* 表頭 ---------------------------------------------------- */
          .md-content th,
          #markdown-container th{
            font-weight:600;
            font-size:3.5vh;                  /* 稍大一點 */
            padding:2vh 3vh;
            text-align:left;                    /* 日期欄靠左 */
            border-bottom:0.4vh solid rgb(192, 192, 192);    /* 粗底線 */
            background:#fff;                    /* 白底，避免斑馬紋影響 */
          }
          .md-content th,
          #markdown-container th:not(:first-child){    
            text-align:left;
            }


          /* 表格內容 ------------------------------------------------ */
          .md-content td,
          #markdown-container td{
            font-size:3.5vh; 
            padding:2vh 3vh;
            border-bottom:0.2vh solid rgb(192, 192, 192);    /* 細底線 */
            background:#fff;     
            text-align:left; 
          }
            /* 表頭：金額欄改右對齊 */


            /* 最後一列不需要底線 */
            .md-content tr,
            #markdown-container tr:last-child td{
            border-bottom:none;
            }

          /* 表格過寬時的橫向捲軸 ------------------------------------ */
          .md-content table,
          #markdown-container table{
            display: block;
            overflow-x: auto;            /* 出現 scroll bar → 手機也不會被撐破版 */
            white-space: nowrap;         /* 視需要可拿掉；拿掉就會自動換行 */
          }

          /* 可選：讓表格置中且有圓角陰影 ------------------------------ */
          .md-content table,
          #markdown-container table{
            border-radius: 6px;
            box-shadow: 0 2px 6px rgba(0,0,0,.06);
          }
            /* ========================================
            註冊按鈕  (class="registration-btn")
            ======================================== */
            .registration-btn{
            /* 形狀 & 位置 ---------------------------------- */
            display:inline-block;     /* 寬度依文字自適應；改 block 可整塊可點 */
            padding:2.5vh 4vh;        /* 上下 / 左右，抓到你截圖那個比例 */
            border-radius:0;          /* 要圓角就改 4px、6px… */
            border:none;
            text-decoration:none;

            /* 顏色 & 字體 ---------------------------------- */
            background: rgba(70, 180, 200);       /* Bootstrap danger 紅再淡一點；自由微調 */
            color:#fff;
            font-size:3.5vh;         /* 跟截圖差不多的大字 */
            font-weight:400;          /* 不要超粗 */
            letter-spacing:0.5px;     /* 白字更清晰，可刪 */

            /* 互動態效果 ------------------------------------ */
            transition:background .2s ease, transform .05s ease;
            cursor:pointer;
            }
            .registration-btn:hover,
            .registration-btn:focus{
            background: #000000;       /* hover 深一階 */
            }
            .registration-btn:active{
            transform:translateY(1px);/* 按下微內縮，可刪 */
            }
</style>