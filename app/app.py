from flask import Flask, jsonify
import mysql.connector
import os

app = Flask(__name__)

def get_db_connection():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME")
    )
#111
@app.route("/health")
def health():
    return jsonify(status="ok")

@app.route("/users")
def users():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT NOW()")
    result = cursor.fetchone()
    cursor.close()
    conn.close()
    return jsonify(db_time=str(result[0]))

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
