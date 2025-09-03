import hashlib
import urllib.parse
from datetime import datetime
from dataclasses import dataclass

@dataclass
class OrderInfo:
    paper_id: str
    name: str
    phone_number: str
    receipt: str
    tax_id: str
    num_normal: int = 0
    num_students: int = 0
    num_meals: int = 0
    trade_desc: str = 'TestOrder'

class ECPayOrder:
    def __init__(self):
        self.merchant_id = '3002607'
        self.hash_key = 'pwFHCqoQZGmho4w6'
        self.hash_iv = 'EkRm7iFT261dpevs'
        self.service_url = 'https://payment-stage.ecpay.com.tw/Cashier/AioCheckOut/V5'
        self.return_url = 'https://tsfd2025.me.ncu.edu.tw/payment-result'

    def generate_order(self, order: OrderInfo):
        trade_date = datetime.now()
        if trade_date.date() < datetime(2025, 9, 26).date():
            cost_normal = 6000
            cost_student = 4000
        elif trade_date.date() < datetime(2025, 10, 6).date():
            cost_normal = 7000
            cost_student = 5000
        else:
            cost_normal = 8000
            cost_student = 6000

        item_name = f'訂購日期 {trade_date.strftime("%m/%d %H:%M")}'
        if order.num_normal > 0:
            item_name += f'#一般身分 {order.num_normal}人 x {cost_normal}'
        if order.num_students > 0:
            item_name += f'#學生 {order.num_students}人 x {cost_student}'
        if order.num_meals > 0:
            item_name += f'#餐券 {order.num_meals}份 x 2000'

        total_amount = (order.num_normal * cost_normal) + (order.num_students * cost_student) + (order.num_meals * 2000)
        order_data = {
            'MerchantID': self.merchant_id,
            'MerchantTradeNo': self._generate_order_id(),
            'MerchantTradeDate': datetime.now().strftime('%Y/%m/%d %H:%M:%S'),
            'PaymentType': 'aio',
            'TotalAmount': total_amount,
            'TradeDesc': order.trade_desc,
            'ItemName': item_name,
            'ReturnURL': self.return_url,
            'ChoosePayment': 'ALL',
            'EncryptType': '1',
            'Remark': f'{order.name}/{order.phone_number}/{order.tax_id}/{order.receipt}',
            'CustomField1': str(order.num_normal),
            'CustomField2': str(order.num_students),
            'CustomField3': str(order.num_meals),
            'CustomField4': order.paper_id
        }

        order_data['CheckMacValue'] = self._generate_check_mac(order_data)
        return order_data
    
    def _generate_order_id(self):
        return 'TEST' + datetime.now().strftime('%Y%m%d%H%M%S')

    def _generate_check_mac(self, params):
        sorted_items = sorted(params.items())
        encoded_str = f'HashKey={self.hash_key}&' + \
            '&'.join(f'{k}={v}' for k, v in sorted_items) + \
            f'&HashIV={self.hash_iv}'

        url_encoded_str = urllib.parse.quote_plus(encoded_str).lower()
        check_mac = hashlib.sha256(url_encoded_str.encode('utf-8')).hexdigest().upper()
        return check_mac
