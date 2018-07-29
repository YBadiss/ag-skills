# ag-skills

## Question 1

Voici la requête demandée:

```sql
SELECT COALESCE(s1.id, s.id) AS id, COALESCE(s1.name, s.name) AS name, COUNT(u.id) AS users_count, COALESCE(SUM(u.points), 0) AS points
FROM skills s
LEFT JOIN skills_users su ON s.id = su.skill_id
LEFT JOIN users u ON u.id = su.user_id
LEFT JOIN skills s1 ON s1.id = s.parent_id
GROUP BY COALESCE(s1.id, s.id);
```

Cependant, étant donné la limitation de l'énoncé

> un utilisateur ne peut avoir qu'une seule compétence

il me semble plus cohérent de ne pas avoir de table intermédiaire, qui est uniquement
utile dans le cas de relation `many-to-many`.

Si l'on déplace l'id des skills dans la table `users` alors la requête devient

```sql
SELECT COALESCE(s1.id, s.id) AS id, COALESCE(s1.name, s.name) AS name, COUNT(u.id) AS users_count, COALESCE(SUM(u.points), 0) AS points
FROM skills s
LEFT JOIN users u ON u.skill_id = s.id
LEFT JOIN skills s1 ON s1.id = s.parent_id
GROUP BY COALESCE(s1.id, s.id);
```

Bien sûr cela demande plus d'effort lors d'une transition vers un modèle `many-to-many`
mais je ne pense pas que ce soit très important: Il parait étrange de toute façon que les
points d'un utilisateur soient attribués à plusieurs skills en même temps.

Malheureusement ces deux requêtes ne fonctionne que s'il y a que deux niveaux de profondeur
dans l'arbre des `skills` (parent + enfant). C'est bien cette situation qui est décrite
dans l'énoncé, et il ne semble pas vraiment logique de toute façon d'avoir une arboresence
plus complexe pour ce qui est essentiellement une liste d'alias.

Si toutefois nous voulions une arborescence plus complexe, nous pourrions utiliser une
stored procedure récursive, ou changer le modèle pour faciliter l'accès aux données.
Par exemple, si `Footie` était l'enfant de `Foot`:

```
+-------------+
|ID|NAME      |
+-------------+
|1 |Football  |
+-------------+
|2 |Basketball|
+-------------+
|3 |Foot      |
+-------------+
|4 |Basket    |
+-------------+
|5 |Socker    |
+-------------+
|6 |Footie    |
+-------------+

+-----------------------+
|ID|CHILD_ID  |PARENT_ID|
+-----------------------+
|1 |3         |1        |
+-----------------------+
|2 |4         |2        |
+-----------------------+
|3 |5         |1        |
+-----------------------+
|4 |6         |1        |
+-----------------------+
|5 |6         |3        |
+-----------------------+
```

Dans ce cas nous pourrions utiliser la requête suivante:

```sql
SELECT COALESCE(st.parent_id, s.id) AS id, s.name AS name, COUNT(u.id) AS users_count, SUM(u.points) AS points
FROM skills s
JOIN "users" u ON u.skill_id = s.id
LEFT JOIN skill_tree st ON st.child_id = s.id
WHERE st.parent_id IN (SELECT id FROM skills1 WHERE id NOT IN (SELECT child_id FROM skill_tree)) OR st.parent_id IS NULL
GROUP BY COALESCE(st.parent_id, s.id);
```

## Question 2

Le code demandé est sur `master`.

```shell
$ cd skills
$ bundle install
$ bin/rails server # L'app tourne sur http://localhost:3000/
$ bin/rails test test # Pour lancer les tests
```
