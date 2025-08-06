import hashlib
import urllib.parse
from datetime import datetime


class ECPayOrder:
    def __init__(self):
        self.merchant_id = '3002607'
        self.hash_key = 'pwFHCqoQZGmho4w6'
        self.hash_iv = 'EkRm7iFT261dpevs'
        self.service_url = 'https://payment-stage.ecpay.com.tw/Cashier/AioCheckOut/V5'

    def generate_order(self, order_id, total_amount, item_name, return_url):
        order_data = {
            'MerchantID': self.merchant_id,
            'MerchantTradeNo': order_id,
            'MerchantTradeDate': datetime.now().strftime('%Y/%m/%d %H:%M:%S'),
            'PaymentType': 'aio',
            'TotalAmount': total_amount,
            'TradeDesc': 'TestOrder',
            'ItemName': item_name,
            'ReturnURL': return_url,
            'ChoosePayment': 'ALL',
            'EncryptType': '1',
        }

        order_data['CheckMacValue'] = self._generate_check_mac(order_data)
        return order_data

    def _generate_check_mac(self, params):
        sorted_items = sorted(params.items())
        encoded_str = f'HashKey={self.hash_key}&' + \
            '&'.join(f'{k}={v}' for k, v in sorted_items) + \
            f'&HashIV={self.hash_iv}'

        url_encoded_str = urllib.parse.quote_plus(encoded_str).lower()
        check_mac = hashlib.sha256(url_encoded_str.encode('utf-8')).hexdigest().upper()
        return check_mac
