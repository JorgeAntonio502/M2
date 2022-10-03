# -*- coding: utf-8 -*-
"""
Created on Sat Sep 17 19:48:47 2022

@author: Utilisateur
"""

import numpy as np

class Livre :
    
    def __init__(self, titre, auteur, nb_pages):
        self.titre = titre
        self.auteur = auteur
        self.nb_pages = nb_pages
        
    def get_titre(self):
        return self.titre
    
    def get_nb_pages(self):
        return self.nb_pages
    
    def set_auteur(self, auteur):
        self.auteur = auteur
        
    def set_titre(self, titre):
        self.titre = titre
        
    def set_nb_pages(self, nb):
        if nb > 0 :
            self.nb_pages = nb
        else :
            print("Nombre de pages entré négatif ou nul => erreur")
        
    def affiche(self):
        print("titre : ", self.titre, " | auteur : ", self.auteur, " | nombre de pages : ", self.nb_pages, "\n")
        
        
class PointAxe :
    
    def __init__(self, nom, abscisse):
        self.nom = nom
        self.abscisse = abscisse
        self.origine = 0
        self.absAbsol = np.abs(self.origine - self.abscisse)
        
    def affiche(self):
        print("nom : ", self.nom, " | abscisse : ", np.abs(self.abscisse-self.origine), " | Origine d'abscisse absolue : ", self.origine, "\n")
        
    def translate(self, transl):
        self.abscisse = self.abscisse + transl
        
    def set_origine(self, valeur):
        self.origine = valeur 
    

# Exercice 1

print("Exercice 1 :\n")


L1 = Livre("titre1", "auteur1", 120)
L2 = Livre("titre2", "auteur2", 200)

L1.affiche()
L2.affiche()

L1.set_nb_pages(150)
L2.set_nb_pages(325)

L1.affiche()
L2.affiche()

print("Nombre total de pages : ", str(L1.get_nb_pages() + L2.get_nb_pages()))
print("\n")

# Exercice 2

print("Exercice 2 :\n")

P = PointAxe("P1", 5)
P.affiche()

P.translate(-9)
P.affiche()

print("\n")

# Exercice 3

print("Exercice 3 :\n")

P1 = PointAxe("B", 6)
P1.affiche()
P1.set_origine(2)
P1.affiche()

# Correction

print("\nCorrection\n")

# Sans décorateurs

class Livrebis:
    def __init__(self, titre, auteur, nb):
        self.__titre = titre
        self.__auteur = auteur
        self.__nb = nb
        
    def get_nb_pages(self):
        return self.__nb
    
    def set_nb_pages(self, n):
        if n > 0:
            self.__nb = n
            
    def affiche(self):
        print(self.__titre, self.__auteur, self.__nb)
        
L1 = Livrebis("titre", "auteur", 23)
L1.affiche()
L1.set_nb_pages(243)
L1.affiche()

# Avec décorateurs

print("\nCorrection avec décorateurs\n")

class Livrebis_2:
    def __init__(self, titre, auteur, nb):
        self.__titre = titre
        self.__auteur = auteur
        self.__nb = nb  # Pour contrôler cohérence de nb
        
    @property
    def titre(self):
        return self.__titre
    
    @property
    def auteur(self):
        return self.__auteur
    
    @property
    def nb(self):
        return self.__nb
    
    @nb.setter
    def nb(self, nb):
        if nb > 0:
            self.__nb = nb
        else:
            self.__nb = 0 # Valeur par défaut    
        
    def affiche(self):
        print(self.__titre, self.__auteur, self.__nb)
        
L2 = Livrebis_2("titrjhbhe", "auteuyjtgftyr", 453)
L2.nb = 234
L2.affiche()
      
    


