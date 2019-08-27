import matplotlib.pyplot as plt

import numpy as np 
import sympy as sp
import sys, os



def create_harmonics(n):
	
	func = 0
	t = sp.symbols('t')


	for index in range(n):


		func += 1/(2*index+1) * sp.cos((2*index+1)*sp.pi*t) * np.power(-1, index)


	return sp.sympify( 1/2 + 2/sp.pi * func), t


if __name__ == "__main__":
	
	n = 20

	series, t = create_harmonics(n)

	t_data = np.linspace(-5, 5, 1000)

	ft_data = []

	for i in range(len(t_data)):

		ft_data.append(series.evalf(subs={t:t_data[i]}))

	plt.plot(t_data, ft_data, 'b-')

	plt.axis([-5,5, -0.5,1.5])
	plt.savefig('square')
	plt.show()
	
	



