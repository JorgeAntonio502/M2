# -*- coding: utf-8 -*-
"""
Created on Tue Sep 13 18:28:12 2022

@author: Utilisateur
"""

import numpy as np


print("Question 1")
print("\n")

def ligne_car(n, c):
    string = ""
    for i in range(n):
        string = string + str(c)
    
    return string

n = 23
c = "l"
print(ligne_car(n, c))

print("\n")
print("Question 2")
print("\n")

def surf_cercle(R):
    return np.pi * R * R

R = 1
print("Surface du cercle : ", surf_cercle(R))

print("\n")
print("Question 3")
print("\n")

def vol_boite(x1, x2, x3):
    return x1*x2*x3

x1 = 5
x2 = 15
x3 = 2

print("Le volume du parallélépipède est : ", vol_boite(x1, x2, x3))

print("\n")
print("Question 4")
print("\n")

def index_max(liste):
    ref = liste[0]
    for i in range(len(liste)):
        if liste[i] > ref :
            ref = i
    return ref

serie = [5, 8, 2, 1, 9, 3, 6, 7, 9, 3]
i = index_max(serie)
print("Résultat :", i)
        