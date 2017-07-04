# coding: latin1
import numpy as np
import matplotlib.pyplot as plt
from math import exp

def calc_markov(N=100, tend=2000, t_ap=400, Ap=15, dt=0.1, w=2000):
    '''
        tend = 2000; #tempo de simulação
        t_ap = 400; #empo de aplicação do pulso
        Ap = 15; # voltagem de estimulação
        dt = 0.1; # tempo de transição
        w = 2000; # largura do pulso
        f = 1; # frequencia
    '''
    f = 1
    Delay = 1000*1/f - w;
    v_resting = -80; # potencial de repouso
    #Parâmetros Biofísicos
    R = 8314.0;                       # [J/kmol*K]
    Frdy = 96485.0;                   # [C/mol]  cy
    Temp = 310.0;                     # [K]
    FoRT = float(float(Frdy)/float(R)/float(Temp));
    #Parâmetros do canal IKr
    Ko = 4.0;                       # Extracellular K   [mM]
    Ki = float(135.0);                     # Intracelular K   [mM]
    ek = (1.0/FoRT)*np.log(Ko/Ki);	  # [mV]
    GKr = 0.0186;                 #mS/uF
    totalLoop = int(int(tend/dt)  + int(N)) + 1;
    tv = np.zeros(totalLoop)
    #########################################################################
    #tend  = 2000;
    t = 0;  # initial time
    i = 0;  # counter for vector of transition times
    tv[0] = 0;
    #########################################################################
    #Modelagem por Markov (Método de Monte Carlo)
    n = 5; # Entre com o número de estados do canal
    nC1 = 0; nC2 = 0; nC3 = 0; nI = 0; nO = 0;
    # Gera número aleatório entre 0 e n para definir o estado de cada canal
    i = 0;
    while i < N:
        r = np.random.uniform(0, 1);
        e = round(r*(n-1)) + 1;
        if e == 1:
            nC1 = nC1 + 1;
        elif e == 2:
            nC2 = nC2 + 1;
        elif e == 3:
            nC3 = nC3 + 1;
        elif e == 4:
            nI = nI + 1;
        else:
            nO = nO + 1;
        i = i + 1;
    INICIAL = [nC1, nC2, nC3, nI, nO]
    #########################################################################
    v = np.zeros(totalLoop)
    alfa0 = np.zeros(totalLoop)
    beta0 = np.zeros(totalLoop)
    alfa1 = np.zeros(totalLoop)
    beta1 = np.zeros(totalLoop)
    alfai = np.zeros(totalLoop)
    betai = np.zeros(totalLoop)
    alfai3 = np.zeros(totalLoop)
    psi = np.zeros(totalLoop)
    N_open= np.zeros(totalLoop)
    N_close_1= np.zeros(totalLoop)
    N_close_2= np.zeros(totalLoop)
    N_close_3= np.zeros(totalLoop)
    N_inativo= np.zeros(totalLoop)
    while t < float(tend):
        if t <= t_ap:                                            #[ms]
            v[i] = v_resting;                                            #[mV]
        elif  (t > t_ap) and (t < t_ap + tend) and (np.mod(t + (1000 - t_ap),(w + Delay)))<= w:
            v[i] = Ap;               # trem de pulso retangular;
        else:
            v[i] = v_resting;                                            #[mV]
        alfa0[i] = 0.0171*exp(0.0330*v[i]);# ms^-1
        beta0[i] = 0.0397*exp(-0.0431*v[i]);# ms^-1
        alfa1[i] = 0.0206*exp(0.0262*v[i]);# ms^-1
        beta1[i] = 0.0013*exp(-0.0269*v[i]);# ms^-1 #
        alfai[i] = 0.1067*exp(0.0057*v[i]);# ms^-1
        betai[i] = 0.0065*exp(-0.0454*v[i]);# ms^-1
        alfai3[i] = 8.04e-5*exp(6.98e-7*v[i]); # ms^-1
        psi[i] = (beta1[i]*betai[i]*alfai3[i])/(alfa1[i]*alfai[i]);
        kf = 0.0261; # ms^-1
        kb = 0.1483; # ms^-1
        j= 0;
        while j  < nO:
            r = np.random.uniform(0, 1);
            if r <= beta1[i]*dt:
                nO = nO - 1;
                nC3 = nC3 + 1;
            elif r > beta1[i]*dt and r <= (beta1[i] + alfai[i])*dt:
                nO = nO - 1;
                nI = nI + 1;
            else:
                nO = nO;
            j = j +1;
        j=0;
        while j < nC1:
            r = np.random.uniform(0, 1); # gera n números aleatórios entre 0 e 1 para determinar a transição entre os estados.
            if r <= alfa0[i]*dt:
                nC1 = nC1 - 1;
                nC2 = nC2 + 1;
            else:
                nC1 = nC1;
            j = j +1;
        j = 0;
        while j < nC2:
            r = np.random.uniform(0, 1);
            if r <= beta0[i]*dt:
                nC1 = nC1 + 1;
                nC2 = nC2 - 1;
            elif r > beta0[i]*dt and r <= (beta0[i]+ kf)*dt:
                nC3 = nC3 + 1;
                nC2 = nC2 - 1;
            else:
                nC2 = nC2;
            j = j +1;
        j = 0;
        while j < nC3:
            r = np.random.uniform(0, 1);
            if r <= kb*dt:
                nC3 = nC3 - 1;
                nC2 = nC2 + 1;
            elif r > kb*dt and r <= (kb + alfa1[i])*dt:
                nC3 = nC3 - 1;
                nO = nO + 1;
            elif r > (kb + alfa1[i])*dt  and r <= (kb + alfa1[i] + alfai3[i])*dt:
                nC3 = nC3 - 1;
                nI = nI + 1;
            else:
                nC3 = nC3;
            j = j +1;
        j=0;
        while j < nI:
            r = np.random.uniform(0, 1);
            if r <= betai[i]*dt:
                nI = nI - 1;
                nO = nO + 1;
            elif r > betai[i]*dt  and r <= (betai[i] + psi[i])*dt:
                nI = nI -1;
                nC3 = nC3 + 1;
            else:
                nI = nI;
            j = j + 1;
        N_open[i]= nO;
        N_close_1[i] = nC1;
        N_close_2[i] = nC2;
        N_close_3[i] = nC3;
        N_inativo[i] = nI;
        t = t + dt;
        tv[i] = t;
        i = i + 1;
   # while loop
    M = [N_close_1, N_close_2, N_close_3, N_inativo,N_open]; # Matriz com a evolução dos estados de cada canal
    #Corrente IKr
    OKr = N_open/N;
    iKr = GKr*OKr*(v - ek);#uA/uF
    return tv,N_open, iKr, v, M;
