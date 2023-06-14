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

    def testing_add_customer(self):
        data = {
            "company": "Konoha",
            "first_name": "Otsutsuki",
            "last_name": "Kaguya",
            "job_title": "Self-Assistant",
            "address": "69 grove ",
            "city": "Puerto Rico"
        }
        response = self.app.post("/customers", json=data)
        self.assertEqual(response.status_code, 201)

    def testing_update_customer(self):
        data = {
            "company": "Company ZXC",
            "first_name": "Gadsf",
            "last_name": "mckn",
            "job_title": "Project Manager",
            "address": "8th Street",
            "city": "colorado"
        }
        response = self.app.put("/customers/29", json=data)
        self.assertEqual(response.status_code, 201)

    def testing_the_delete(self):
        response = self.app.delete("/customers/52")
        self.assertEqual(response.status_code, 200)
if __name__ == '__main__':
    unittest.main()
