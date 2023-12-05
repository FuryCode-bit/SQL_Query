# Flask
from flask import Flask, render_template, request
from database.connection import test_connection, database_connection, execute_query

app = Flask(__name__)

@app.route("/")
def hello_world():
        test_connection()
        return "<h2>Posta de Bacalhau!</h2>"

@app.route("/execute_query", methods=['POST'])
def query_http():
    if request.method == 'POST':
        sql_query = request.form['sql_query']
        print(sql_query)
        columns, rows = execute_query(f"{sql_query}")

        return render_template('table.html', columns=columns, rows=rows)
    else:
        return "Invalid Method"

@app.route("/sql")
def sql():
    return render_template('query.html')


if __name__ == "__main__":
    app.run(debug=True)