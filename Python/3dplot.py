
from mpl_toolkits.mplot3d.axes3d import Axes3D
import matplotlib.pyplot as plt

import numpy as np 
import sympy as sp
import sys, os
import time






if __name__ == "__main__":
	
    thetaData = np.linspace(0, 360,360)
    uData = np.linspace(1,10,200)
    vData = np.linspace(1,10,200)
    

    fig = plt.figure()
    ax = fig.add_subplot(1, 1 , 1, projection='3d')

 
    for thetaIndex in range(len(thetaData)):

        tfuncData = []
        full = []
        for index in range(len(uData)):


            innerCos = uData[index]*sp.cos(thetaData[thetaIndex]) + vData[index]*sp.cos(thetaData[thetaIndex])
    
            full.append(sp.cos(2*np.pi*innerCos))

        
        # tfuncData = np.array(tfuncData)
        full = np.array(full)

        ax.plot_trisurf(uData, vData, full, linewidth=0.2)

        plt.show()
        # plt.show()
plt.show()
