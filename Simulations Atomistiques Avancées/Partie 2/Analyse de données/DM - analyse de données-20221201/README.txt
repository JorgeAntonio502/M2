Ce dossier contient les codes utilisés pour obtenir les différentes fonctions radiales.

Il y a trois fichiers .c:
- "distribution_function_OO", pour étudier les paires d'oxygène
- "distribution_function_SiSi", pour étudier les paires de silicium
- "distribution_function_SiO", pour étudier les paires Oxygène/Silicium

Ils sont configurés pour lire "pos_300K" et "pos_3500K".
Pour lire l'un ou l'autre, il est nécessaire de changer le nom du fichier d'entrée dans la section "configuration fichiers" des codes.

Une fois exécutés, ouvrir "plot.gnu" depuis gnuplot pour observer la fonction g(r) calculée.
