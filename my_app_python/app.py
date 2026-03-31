from flask import Flask
import requests

app = Flask(__name__)

@app.route("/")
def home():
    url = "https://dog.ceo/api/breeds/image/random/3"  
    response = requests.get(url)
    data = response.json()
    images = data["list"]  

    # 生成 HTML
    img_html = "".join([f'<img src="{img}" width="300">' for img in images])

    return f"""
    <h1>3 Random Dogs 🐶🐶🐶</h1>
    {img_html}
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)