# -*- coding: utf-8 -*-
"""
Created on Tue Sep 13 17:32:07 2022

@author: Utilisateur
"""

print("Question 1 :")
print("\n")

for i in range(21):
    res = 7 * i
    print("7 x ", i, " = ", res)

    
print("\n")    
print("Question 2 :")
print("\n")

euros = 1
dollar = 1.65

while euros < 16385 :
    dollars = euros * dollar
    print(euros, "euros = ", dollars, " dollars")
    euros = euros * 2
    
print("\n")    
print("Question 3 :")
print("\n")

nb = 1
for i in range(13):
    print(nb)
    nb = nb * 3
    
print("\n")    
print("Question 4 :")
print("\n")

largeur = 8
hauteur = 5
profondeur = 2

print(f"Le volume d'un parallélépipède rectangle de largeur {largeur}, hauteur {hauteur} et profondeur {profondeur} est : ", largeur*hauteur*profondeur)

print("\n")    
print("Question 5 :")
print("\n")

nbSec = 500000
cpt = 0

nbJ = nbSec / 86400
cpt = nbSec % 68400

nbH = cpt / 3600
cpt = cpt % 3600

nbM = cpt / 60
cpt = cpt % 60

nbS = cpt

print(f"{nbJ:.0f} jours {nbH:.0f} heures {nbM:.0f} minutes et {nbS:.0f} secondes")

print("\n")    
print("Question 6 :")
print("\n")


for i in range(21):
    res = 7 * i
    if res % 3 == 0 :
        print("7 x ", i, " = ", res, " *")
    else :
        print("7 x ", i, " = ", res)
        
print("\n")    
print("Question 7 :")
print("\n")

suite = ""

for i in range (1, 9, 1):
    print(suite)
    suite = suite + " " + str(i)
    
print("\n")    
print("Question 8 :")
print("\n")
    
suite = "1 2 3 4 5 6 7"

for i in range(0, 14, 2):
    print(suite[:len(suite)-i])
    
    
