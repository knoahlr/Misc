import numpy as np
import pandas as pd
import scipy as sp
from scipy.optimize import curve_fit
from scipy import signal
import cv2
import matplotlib.pyplot as plt
from sympy import sympify, latex, diff, symbols, sqrt, lambdify, exp

from pathlib import Path

import os, sys

def currents(b, IC):

    I_C = 1.8795e-12
    I_E = 1.146e-14 
    n_c = 1.2934
    n_e = 1.0107
    alphaF = 0.996
    alphaR = 0.725

    if IC: return alphaF*I_E*( np.exp(0.67/(n_e*0.0259)) - 1) - I_C*(np.exp(b/(n_c*0.0259)) - 1)
    else: return (1-alphaF)*I_E*( np.exp(0.67/(n_e*0.0259)) - 1) + (1-alphaR)*I_C*(np.exp(b/(n_c*0.0259)) - 1)


if __name__ == "__main__":

    alphaF = 0.996
    alphaR = 0.725

    measuredIc = [0.52, 1.379, 1.546, 1.56, 1.563, 1.563, 1.567, 1.568, 1.570, 1.572]
    measuredIb = [0.5, 0.005, 0.010, 0.006936, 0.006815, 0.006826, 0.006823, 0.006835, 0.006832, 0.006829]
    measuredIb = [value * (10**-3) for value in measuredIb]
    measuredIc = [value * (10**-3) for value in measuredIc]
    Vc = np.linspace(0, 0.9, 10)
    Vbc = 0.67-Vc
    Ic = currents(Vbc, True)
    Ib = currents(Vbc, False)

    errorIb = [(abs(measuredIb[index] - Ib[index])/measuredIb[index] ) *100 for index in range(len(measuredIb))]

    errorIc = [(abs(measuredIc[index] - Ic[index])/measuredIc[index] ) *100 for index in range(len(measuredIc))]

    figure = plt.figure()
    axis = figure.gca()

    
    axis.plot(Vbc, Ic, '--ro', label="Calculated Ic")
    axis.plot(Vbc, Ib, '--bo', label="Calculated Ib")
    axis.plot(Vbc, measuredIc, '--go', label="Measured Ic")
    axis.plot(Vbc, measuredIb, '--co', label="Measured Ib")
    axis.set_xlabel('VBC (V)')
    axis.set_ylabel("Current (A)")
    axis.grid(linewidth=0.5)

    dataTable = pd.DataFrame()

    dataTable['VBC'] = Vbc
    dataTable['IC'] = Ic
    dataTable['IB'] = Ib
    dataTable['MeasuredIc'] = measuredIc
    dataTable['MeasuredIb'] = measuredIb
    dataTable['errorIc'] = errorIc
    dataTable['errorIb'] = errorIb

    dataTable.to_csv(r'D:\OneDrive - Carleton University\School\Courses Y4\Winter\ELEC 3908\Labs\Lab 2\Data\tableImprove2.csv')

    plt.xlim( Vbc[0]+0.2, Vbc[-1]-0.2)
    
    plt.legend()
    plt.show()
    print(Ic,"\n\n\n\n",Ib)