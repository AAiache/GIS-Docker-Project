PostgreSQL synchronization
==========================

# Summary

In the context of our project, the main criterion is avoiding data
loss.  A resilient mechanism of data replication should be
conducted. Load balancing and high availability are secondary
criteria.

Replication of postgresql databases is *not easy*. Some mechanisms are
allowed by the way Postgresql is designed, but no solution is provided
by default. External tools will be needed.

The following sections are based on Postgresql 9.4 documentation.

In particular, each Postgresql server has its own way to store the
data. That means that one PG server cannot read directly the block
filesystem of an other running PG server. Thus, the two first methods
presented will be a bit tough.

To ease the task, the subject explicitely states that data alteration
should be done only when the system is in nominal state. But it does
not state anything about serving not up-to-date data (i.e. load
balancing combined with asynchronous replication).

I would suggest the 5th solution.


# Primary reference

A StackOverflow thread with link to PG reference page :
[http://stackoverflow.com/questions/1292107](http://stackoverflow.com/questions/1292107/synchronize-two-pg-databases)

Little PG news, to be dug up: [http://www.postgresql.org/about/news/1360/](http://www.postgresql.org/about/news/1360/)

# Vocabulary

A *primary*, or *master* is a (in general, the only) server that can
be connected and have read/write access to the data.

A *standby* or *slave* is a server that have read-only access to the
data. If the server can be connected from outside, it is *hot*, else
it is *warm*.

A *asynchronous* high-availability solution allow some delay before
the changes are propagated to all servers. The load balancing and
availability is preserved, but some data can be lost, and some servers
may deliver not updated data.

A *synchronous* HA solution preserves data integrity. A write
transaction is not commited before all servers have executed
it. During that time, all servers are unable to serve requests, so
this solution may generate a disponibility failure.



# 1st Solution: sharing the hard drive

Mettre en place un serveur NFS. En théorie, toute la donnée est
stockée sur une des machines, partagée sur le réseau, et servie à
l'extérieur par plusieurs serveurs sur des machines différentes.

Problème : Postgres ne supporte qu'un seul serveur à la fois (les
autres ne doivent pas accéder à la donnée) => pas de load-balancing +
spof.

     ____              ____
    /____\            /____\
    |    |            |    |
    | 0  |            | 0  |
    \____/            \____/
       A                A
        \              /
         \            /
          \          /
           -------_---
           |     / \ |
           |    | o ||
           | ==--X_/ |
           -----------




# 2nd Solution: mirroring the filesystems


L'idée est de recopier les blocs modifiés lors de la mise à jour d'une
des bases sur l'autre système de fichiers. Idem, non supporté (sauf
si un seul serveur à la fois).

        ____              ____
       /____\            /____\
       |    |            |    |
       | 0  |            | 0  |
       \____/            \____/
         A                  A
         |                  |
         |                  |
    -------_---        -------_---
    |     / \ |        |     / \ |
    |    | o ||<------>|    | o ||
    | ==--X_/ |        | ==--X_/ |
    -----------        -----------

[DRBD](https://en.wikipedia.org/wiki/Distributed_Replicated_Block_Device)
    

# 3rd solution: warm standby

À nouveau, il n'y a qu'un seul serveur actif à la fois. Plusieurs
serveurs en stand-by écoutent le log des écritures, et peuvent prendre
la relève si le serveur principal tombe.

                      ____
                     /____\
                     |    |
                     | 0  |
                     \____/
                       A
                       |
        ____           |            ____
       /____\         /|\          /____\
       |    |        / | \         |    |
       | O ,---<----'  |  `----->---.O  |
       \__|_/          |           \_|__/
          |            |             |
          V            V             V
    -------_---   -------_---    -------_---
    |     / \ |   |     / \ |    |     / \ |
    |    | o ||   |    | o ||    |    | o ||
    | ==--X_/ |   | ==--X_/ |    | ==--X_/ |
    -----------   -----------    -----------

[Documentation](http://www.postgresql.org/docs/9.4/static/warm-standby.html)

Problème : possible perte de données si les serveurs en standby ne
parviennent pas à gérer le flux.


# 4th solution: master-slaves (asynchrounous)

Plusieurs serveurs esclaves en lecture seule, et un serveur maître
capable d'écrire de la donnée. Il evoie ensuite à tous les esclaves la
requête effectuée.


          A            A             A
          |            |             |
        __|_          _V__          _V__
       /____\        /____\        /____\
       |    |        |    |        |    |
       | 0  |< - - - | 0  | - - - >| 0  |
       \____/        \____/        \_|__/
          A            A             A
          |            |             |
          V            V             V
    -------_---   -------_---    -------_---
    |     / \ |   |     / \ |    |     / \ |
    |    | o ||   |    | o ||    |    | o ||
    | ==--X_/ |   | ==--X_/ |    | ==--X_/ |
    -----------   -----------    -----------

Slony-I


# 5th solution: broadcast statements (synchronous)

Toutes les requêtes sont transmises par un middleware à tous les
serveurs. Attention, pas garanti d'avoir le même id (ou alors exécuter
sur un serveur, puis select et insert sur les autres avec la bonne
valeur). Utiliser des requêtes en 2 morceaux (prepare / commit).

Pgpool II et Sequoia (Java/jdbc)


# 6th solution: asynchronous multi-master

De temps en temps, on synchronise les masters en réglant les conflits
à la main... Ce n'est pas vraiment ce qu'il nous faut.
