# -*- coding: utf-8 -*-
"""
Created on Tue Sep 13 21:10:49 2022

@author: Utilisateur
"""

import numpy as np

sigmaY = np.array([[0, 0 + 1j], [0 - 1j, 0]])
sigmaY_bis = np.copy(sigmaY)

print("\n")
print("Matrice :")
print(sigmaY)
print("taille matrice : ", sigmaY.shape)
print("\n")

print("Question (a)")
print("\n")

sigmaY_bis = np.conj(sigmaY.T)
        
print("Matrice complexe conjuguée : ", sigmaY_bis)
print("\n")
        
estH = True
for i in range(len(sigmaY_bis)):
    for j in range(len(sigmaY_bis[i])):
        if sigmaY[i][j] != sigmaY_bis[i][j] :
            estH = False
        
print("Hermiticité ? : ", estH)
print("\n")

print("Question (b)")

eigenValues, EigenVectors = np.linalg.eig(sigmaY)
print("\nEigenvalues:")
print(eigenValues)
print("\nEigenvectors:")
print(EigenVectors)
print("\n")

ket_a = EigenVectors[:,0:1]
ket_b = EigenVectors[:,1:2]
print("ket a : ", ket_a)
print("ket b : ", ket_b)
print("\n")
bra_a = np.conj(ket_a).T
bra_b = np.conj(ket_b).T
print("bra a : ", bra_a)
print("bra b : ", bra_b)
print("\n")

print("Produit scalaire entre les vecteurs propres a et b : ", np.vdot(ket_b, ket_a))
print("Produit scalaire entre les vecteurs propres a et b : ", bra_a @ ket_b)
print("\n")

print("Question (c)")
print("\n")
print("Projecteur 1 :\n ", ket_a*bra_a)
print("projecteur 2 :\n ", ket_b*bra_b)
print("\n")
print("P1 + P2 =\n ", ket_a*bra_a + ket_b*bra_b)
print("\n")
print("P1*P2 =\n ", np.dot(ket_a*bra_a, ket_b*bra_b))
print("P2*P1 =\n ", np.dot(ket_b*bra_b, ket_a*bra_a))
print("P1*P2 egal à matrice nulle ? : ", np.allclose(np.dot(ket_a*bra_a, ket_b*bra_b), 0))
print("P2*P1 egal à matrice nulle ? : ", np.allclose(np.dot(ket_b*bra_b, ket_a*bra_a), 0))








