import unittest
from flask import Flask
import json
import apii

class FlaskAppTestCase(unittest.TestCase):
    def setUp(self):
        self.app = apii.flask_app.test_client()

    def test_get_customers(self):
        response = self.app.get('/customers')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.get_data(as_text=True))

    def test_get_customer(self):
        response = self.app.get('/customers/1')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.get_data(as_text=True))

if __name__ == '__main__':
    unittest.main()
