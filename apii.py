from flask import Flask, Response, request, jsonify
from flask_mysqldb import MySQL

flask_app = Flask(__name__)
flask_app.config["MYSQL_HOST"] = "127.0.0.1"
flask_app.config["MYSQL_USER"] = "root"
flask_app.config["MYSQL_PASSWORD"] = "AMBET3639root"
flask_app.config["MYSQL_DB"] = "northwind"
flask_app.config["MYSQL_CURSORCLASS"] = "DictCursor"
mysql = MySQL(flask_app)

def fetch_data(query):
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    data = cursor.fetchall()
    cursor.close()
    return data

@flask_app.route("/")
def homepage():
    return """
            CUSTOMER TABLE C.R.U.D
    ====================================
    SELECTION:
    1. ADD CUSTOMERS TABLE
    2. RETRIEVE CUSTOMER TABLE
    3. UPDATE CUSTOMER TABLE
    4. DELETE CUSTOMER TABLE
    5. EXIT
    ====================================
    """

@flask_app.route("/customers", methods=["GET"])
def customers():
    query = "SELECT id, company, first_name, last_name, job_title, address, city FROM customers"
    data = fetch_data(query)
    return jsonify(data)

@flask_app.route("/customers/<int:id>", methods=["GET"])
def getcustomerid(id):
    query = f"SELECT id, company, first_name, last_name, job_title, address, city FROM customers WHERE id = {id}"
    data = fetch_data(query)
    if not data:
        return jsonify(f"Customer {id} does not exist")
    return jsonify(data)

@flask_app.route("/customers/<int:id>/orders", methods=["GET"])
def get_orders(id):
    query = f"""
        SELECT customers.id, CONCAT(customers.first_name, " ", customers.last_name) AS customer_name, orders.order_date, products.product_name
        FROM products
        INNER JOIN order_details ON products.id = order_details.product_id
        INNER JOIN orders ON order_details.order_id = orders.id
        INNER JOIN customers ON orders.customer_id = customers.id
        WHERE customers.id = {id}
        ORDER BY orders.order_date
    """
    data = fetch_data(query)
    if not data:
        return jsonify(f"Customer {id} does not have any orders")
    return jsonify(data)


#adding customers
@flask_app.route("/customers", methods=["POST"])
def customer_add():
    customer = request.get_json()
    query = f"""
        INSERT INTO customers (company, first_name, last_name, job_title, address, city)
        VALUES ('{customer['company']}', '{customer['first_name']}', '{customer['last_name']}',
                '{customer['job_title']}', '{customer['address']}', '{customer['city']}')
    """
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    mysql.connection.commit()
    cursor.close()
    return jsonify("Customer added successfully")

#updating customers
@flask_app.route("/customers/<int:id>", methods=["PUT"])
def customer_update(id):
    customer = request.get_json()
    query = f"""
        UPDATE customers
        SET company = '{customer['company']}', first_name = '{customer['first_name']}',
            last_name = '{customer['last_name']}', job_title = '{customer['job_title']}',
            address = '{customer['address']}', city = '{customer['city']}'
        WHERE id = {id}
    """
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    mysql.connection.commit()
    cursor.close()
    return jsonify(f"Customer {id} updated successfully")

#deleting customers
@flask_app.route("/customers/<int:id>", methods=["DELETE"])
def customer_delete(id):
    query = f"DELETE FROM customers WHERE id = {id}"
    cursor = mysql.connection.cursor()
    cursor.execute(query)
    mysql.connection.commit()
    cursor.close()
    return jsonify(f"Customer {id} deleted successfully")

if __name__ == "__main__":
    flask_app.run(debug=True)
