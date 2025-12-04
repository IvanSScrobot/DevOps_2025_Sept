from flask import Flask
import psycopg2
import os

app = Flask(__name__)

def get_db_connection():
    conn = psycopg2.connect(
        host=os.environ.get("DB_HOST"),
        database=os.environ.get("DB_NAME"),
        user=os.environ.get("DB_USER"),
        password=os.environ.get("DB_PASSWORD"),
    )
    return conn


def init_db():
    """Create the table if it doesn't exist yet."""
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS request_times (
            id SERIAL PRIMARY KEY,
            requested_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
        );
    """)
    conn.commit()
    cur.close()
    conn.close()


@app.route("/", methods=["GET"])
def index():
    try:
        conn = get_db_connection()
        cur = conn.cursor()

        # 1) Insert current time for this request
        cur.execute("INSERT INTO request_times (requested_at) VALUES (NOW());")
        conn.commit()

        # 2) Get all times from the table
        cur.execute("SELECT requested_at FROM request_times ORDER BY id DESC;")
        rows = cur.fetchall()

        cur.close()
        conn.close()

        # Build a simple HTML page
        list_items = "".join(f"<li>{r[0]}</li>" for r in rows)
        html = f"""
        <!DOCTYPE html>
        <html>
          <head>
            <title>Request Times</title>
          </head>
          <body>
            <h1>Request times (most recent first)</h1>
            <p>Every time you refresh this page, a new timestamp is added.</p>
            <ul>
              {list_items}
            </ul>
          </body>
        </html>
        """
        return html

    except Exception as e:
        return f"Error: {str(e)}"


if __name__ == "__main__":
    # Make sure the table exists before handling requests
    init_db()
    app.run(host="0.0.0.0", port=8080)
