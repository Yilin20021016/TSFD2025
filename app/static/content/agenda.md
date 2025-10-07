
<center>
  <a class="booking-btn" href="./static/docs/TSFD2025大會議程_詳細發表議程1006版.pdf" download>點我下載議程</a><br/>
  <iframe src="./static/docs/TSFD2025大會議程_詳細發表議程1006版.pdf#navpanes=0&view=Fit" style="border: none; width: 1000px; height: 750px"></iframe>
</center>

<style>
  body {
    overflow-y: hidden;
  }
  
  .booking-btn {
      /* 形狀 & 位置 ---------------------------------- */
      margin-bottom: 10px;
      display: inline-block;     /* 寬度依文字自適應；改 block 可整塊可點 */
      padding: 10px 15px;        /* 上下 / 左右，抓到你截圖那個比例 */
      border-radius: 4px;          /* 要圓角就改 4px、6px… */
      border: none;
      text-decoration: none;

      /* 顏色 & 字體 ---------------------------------- */
      background: rgba(70, 180, 200);       /* Bootstrap danger 紅再淡一點；自由微調 */
      color: #fff;
      font-size: 2.5vh;         /* 跟截圖差不多的大字 */
      font-weight: 400;          /* 不要超粗 */
      letter-spacing: 0.5px;     /* 白字更清晰，可刪 */

      /* 互動態效果 ------------------------------------ */
      transition: background .2s ease, transform .05s ease;
      cursor: pointer;
  }

  .booking-btn:hover, .booking-btn:focus {
    background: #000000;       /* hover 深一階 */
  }

  .booking-btn:active {
    transform: translateY(1px);/* 按下微內縮，可刪 */
  }
</style>