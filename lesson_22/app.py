import os
from flask import Flask
import requests
from dotenv import load_dotenv

app = Flask(__name__)

@app.route("/")
def home():
    # Example external dependency usage:
    # Call GitHub API just to show requests library works
    api_url = os.getenv("API_URL", "https://api.github.com")

    response = requests.get(api_url)
    status = response.status_code

    return f"""
    <h1>Hello from Flask!</h1>
    <p>We made an HTTP call using the <b>requests</b> dependency.</p>
    <p>{api_url} API status: {status}</p>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
