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
class PointA(Point):
    
    def __init__(self, x, y):
        super().__init__(x, y)
        
    def affiche(self):
        print("x = ", self.get_x(), " y = ", self.get_y())
        
        
class PointNom(Point):
    def __init__(self, x, y, nom):
        super().__init__(x, y)
        self.nom = nom
        
    def aff_coord_nom(self):
        print("Coordonnees : ", self.get_x(), self.get_y(), " | nom objet : ", self.nom)
        
        
P1 = PointA(7, 6)
P1.affiche()

P2 = PointNom(5, 1, "A")
P2.aff_coord_nom()

print("\n")

liste = [Point(5, 5), Point(0, -8), PointNom(2, 5, "A")]

for point in liste:
    print(point.aff_coord())
    
"""

a = Point("A", 3)
a.affiche()