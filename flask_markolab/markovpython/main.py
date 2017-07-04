from flask import Flask, render_template, request, url_for, flash, redirect, session, jsonify
import numpy as np
from markov import calc_markov

app = Flask(__name__)
app.secret_key = 'fsdfsdfsdfsdfsfsd'

@app.route('/dado_grafico.json')
def get_plot():
    print request.args
    N = float(request.args.get('N'))
    tend = float(request.args.get('tend'))
    t_ap = float(request.args.get('t_ap'))
    Ap = float(request.args.get('Ap'))
    dt = float(request.args.get('dt'))
    w = float(request.args.get('w'))
    print N, tend, t_ap, Ap, dt, w
    tv,N_open, iKr, v, M = calc_markov(N, tend, t_ap, Ap, dt, w)
    dado = [tv.tolist(), N_open.tolist(), iKr.tolist(), v.tolist(), M[0].tolist(),
            M[1].tolist(), M[2].tolist(), M[3].tolist(), M[4].tolist()]#, M.tolist()]
    return jsonify(dado)

@app.route('/')
def principal():
    return render_template('principal.html')

if __name__ == "__main__":
    app.run(debug=True)
