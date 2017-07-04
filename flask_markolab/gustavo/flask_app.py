from flask import Flask, render_template, request, url_for, flash, redirect, session
import matlab.engine
import numpy as np

app = Flask(__name__)
app.secret_key = 'fsdfsdfsdfsdfsfsd'

eng = matlab.engine.start_matlab()

@app.route('/get_plot/<valor>')
def get_plot(valor):
    (t, g, iKr,v, M) = eng.Markov_function(float(valor), nargout=5)
    print 'get plot', valor
    valores1 = g[0]
    valores2 = v[0]
    return render_template('principal2.html',  valores1=valores1, valores2=valores2)


@app.route('/')
def principal():
    valor = np.random.normal(100,10)
    print 'get', valor
    (t, g, iKr,v, M) = eng.Markov_function(float(valor), nargout=5)
    valores1 = g[0]
    valores2 = iKr[0]
    return render_template('principal2.html',  valores1=valores1, valores2=valores2)

if __name__ == "__main__":
	app.run(debug=True)
