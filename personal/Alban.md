# Compte-rendu personnel de Alban Kraus

(This document is only related to the school project's evaluation)

## Vue chronologique — organisation du travail et commentaires

Ce projet a été réalisé en soirée, après le travail à l'école, et de
manière un peu irrégulière. Nous avons bien sûr eu des difficultés,
mais nous avons réussi à ne pas rester bloqués trop longtemps. Nos
ambitions ont cependant dû être revues à la baisse ces dernières
semaines, la date de rendu approchant rapidement.

Au tout début, nous avons tous les trois pensé et adopté une
architecture répondant au sujet. Valentin a proposé un planning de
travail.

J'ai donc commencé par travailler sur la réplication de bases
PostgreSQL. Je suis l'auteur principal du fichier
[`postgresql.md`](../postgresql.md).  J'ai bien compris que toute
tentative de réplication à l'échelle du système de fichiers serait
vaine, puisque chaque base a sa manière propre d'organiser ses
données. Les seules solutions sont alors de rediriger les requêtes
modificatrices vers toutes les bases, ce qui est possible puisque « le
système est en état nominal », ou de les synchroniser périodiquement,
au risque de ne pas avoir les mêmes identifiants. La dernière solution
est sans doute plus rapide à mettre en place, mais il y aura un léger
temps de latence ; le sujet ne mentionne aucune exigence sur ce
point. Puisqu'un outil existe, la première solution a été retenue, car
elle est plus jolie.

J'ai ensuite commencé à documenter et tester cet outil, *pgpool
II*. C'est Amina qui s'est chargée de le Dockeriser, en se basant sur
[mon document](../pg-pool-II.md).

L'initialisation de la base a été une légère difficulté technique ; en
regardant le code de l'image officielle amd64 de PostgreSQL, j'ai vu
qu'il fallait faire un script qui s'articule autour d'une boucle
infinie et le mettre dans le ENTRYPOINT. Répondre aux `docker stop`
m'a paru important, donc j'ai trouvé la commande `trap`. Cette idée a
été reprise dans d'autres conteneurs du projet.

Pendant ce temps, Valentin a travaillé sur Geoserver, ce qui ne devait
pas être une mince affaire (mais j'ai du mal à estimer le temps qu'il
y a passé), et Amina sur HAProxy et Keepalived (si je me souviens
bien).

Progressivement, les domaines de compétence de chacun ont fondu ;
Geoserver posait beaucoup de problèmes à Valentin. Je l'ai aidé à
déboguer certaines choses. Il a trouvé la solution du partage NFS pour
que tous les Geoservers aient la même config, mais il fallait encore
leur dire de se synchroniser. Je m'en suis chargé, j'ai trouvé la
requête à faire, mais il fallait maintenant la lancer sur tous
(facile) et trouver un déclencheur. On pouvait se passer du
déclencheur ([hard-reload](../foreman/geoserver-hard-reload)), et
lancer périodiquement la requête, mais comme pour Postgres cela
laissait la porte ouverte à un Geoserver diffusant de la donnée non
actuelle. J'ai quand même trouvé *inotify*, qui permet de lancer un
programme lors d'un accès au système de fichiers, et j'ai écrit
[un script](../foreman/geoserver-reload) non documenté ayant la double
fonction de lancer un *incron* et d'y répondre. J'aurais été très
satisfait de cette solution si elle avait marché ; malheureusement,
lors du lancement de la commande, l'erreur « exec failed: No such file
or directory » était lancée. (Voir mon message de commit
24790f7c82aa4c4d3ff879f9d072879ef29d529e) Je la suspectais difficile à
résoudre, donc Valentin m'a suggéré d'abandonner.

Pendant que j'écrivais mes petits scripts shell avec la lenteur qui
m'est propre, Valentin et Amina ont revu l'architecture : au lieu de
mettre plusieurs services dans un gros conteneur, ils ont opté pour
garder des petits conteneurs et fixer la machine sur laquelle ils
tourneraient. Je n'ai que vaguement suivi leur démarche, juste ce
qu'il faut pour me convaincre qu'ils restaient dans le sujet. Amina a
dû consacrer quelques minutes pour m'expliquer les quelques zones
d'ombre, et pendant que je dessinais un schéma elle s'est souvenue de
la solution du problème que nous posait Keepalived à l'époque.

Enfin fut arrivé le moment du Docker-compose. Sauf lors de corrections
de petits bogues, nous travaillions tous ensemble autour du PC de
Valentin, afin de trouver vite les erreurs et les solutions.

Enfin, vendredi soir, Valentin et Amina se sont réparti les dernières
documentations ; c'est le seul partage qui n'a pas été équitable, mais
le temps était compté, je n'avais pas Internet chez moi, je passerai
le gros du samedi 24 avril dans le train ou à faire du rangement pour
préparer des visites de mon appartement, donc ça m'arrangeait de ne
pas avoir à m'occuper de cela en plus.

Mis à part ce point, nous sommes tous les trois satisfaits de la
répartition du travail, tous les trois heureux d'avoir triomphé des
difficultés, et tous les trois déçus de ne pas avoir pu faire
davantage. (Consul dans un conteneur pour Amina, *inotify* et le
collecteur de statistiques de Postgres pour moi).



## Commentaires sur l'architecture

Félicitations à Amina pour avoir réussi à mettre en place les
Keepalived, ils sont les éléments clés du système résilient (utiles à
la fois pour les connexions à Geoserver et entre Geoserver et les
bases). Côté répartition de charge, les HAProxy et les pgpool feront
du bon travail.

Notre architecture est un peu scalable, puisqu'il est possible de
créer davantage de branches, mais cette mise à l'échelle reste limitée
par les fortes contraintes posées sur les nœuds : Geoserver sur
celui-ci, Postgres sur celui-là, ... De plus, il y a beaucoup de noms
d'hôte et d'adresses IP en dur dans les fichiers de configuration, et
il n'est pas toujours facile de les remplacer (p.ex. pgpool).

Je vois deux points sensibles :

* le montage NFS des fichiers de configuration de Geoserver : si la
carte SD de la Pi hôte meurt, les Geoserver risquent de tomber (nous
aurions même dû tester, si ça se trouve ils gardent tout en mémoire) ;

* Consul



## Améliorations

– pour éviter les décalages : *inotify* (j'en ai parlé plus haut) ;

– certains de nos scripts shells sont assez fragiles et risquent de
  mal supporter certaines situations anormales (je pense aux `start
  server ; while true ; do wait 100 ; done`) ;

– la Pi maître, qui héberge Consul et le partage de fichiers, est un
  point sensible ; puisque nous avons réussi à répliquer Postgres, il
  devrait être possible de faire de même avec Consul...

Il n'y a aucun point obscur, j'ai bien compris l'ensemble du projet et
le travail de mes camarades.


## Conclusion

Ce dont je me souviendrai après la fin de ce projet, c'est l'élégance
des scripts shell, la documentation de Geoserver qui s'attache plus à
décrire sur quels boutons il faut cliquer pour ajouter une couche
plutôt que de décrire l'organisation de son répertoire de
configuration et son API REST (ou alors on n'a pas regardé au bon
endroit), et la lenteur fragile des Raspberries (un Geoserver et
Postgres qui tournent ? Plus de mémoire, une seconde d'attente entre
la frappe et l'écho d'un caractère, une minute pour lancer Emacs, et
je ne parle pas des `docker-compose up` de vingt minutes. Quant aux
passionnantes difficultés liées à l'ARM, nous n'avons pas eu le temps
de les examiner et toutes les surmonter.) Et c'est un projet qui nous
a plu et que, à ce qu'il nous semble, nous avons réussi.
