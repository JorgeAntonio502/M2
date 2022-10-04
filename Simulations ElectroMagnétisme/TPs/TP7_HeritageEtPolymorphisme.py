# -*- coding: utf-8 -*-
"""
Created on Sun Sep 18 13:06:28 2022

@author: Utilisateur
"""

class Point:
    origine = 0
    
    def __init__(self, nom, abs):
        self.nom = nom
        self.abscisse_absolue = abs
    
    def affiche(self):
        print("Point : ", self.nom, "- abscisse = ", self.abscisse_absolue-Point.origine)
        print("Relative à une origine en ", Point.origine)
        
    @classmethod
    def set_origine(cls, valeur):
         Point.origine = valeur
         
    @classmethod
    def get_origine(cls):
        return Point.origine

        
"""
class Point:
    def __init__(self, x, y):
        self.__x = x
        self.__y = y

    def affiche(self):
        print("Coordonnees : ", self.__x, self.__y)
        
class PointNom(Point):
    def __init__(self, x, y, nom):
        Point.__init__(self, x, y)
        self.__nom = nom
        
    def aff_coord_nom(self):
        Point.aff_coord(self)
        print("Nom : ", nom)
        
       
a = PointNom(3, 5, "A")
a.aff_coord()
a.aff_coord_nom()
"""    

"""
class Point:
    def __init__(self, x, y):
        self.__x = x
        self.__y = y

    def affiche(self):
        print("Coordonnees : ", self.__x, self.__y)
        
class PointNom(Point):
    def __init__(self, x, y, nom):
        Point.__init__(self, x, y)
        self.__nom = nom
        
    def affiche(self):
        Point.affiche(self)
        print("  et son nom est : ", self.__nom)
        
       
liste = [PointNom(3, 5, "A"), Point(6, 7), PointNom(2, 8, "B")]

for a in liste:
    a.affiche()
""" 


a = Point("A", 3)
a.affiche()