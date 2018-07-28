# ag-skills

## Question 1

Voici la requête demandée:

```sql
SELECT COALESCE(s1.id, s.id) AS id, COALESCE(s1.name, s.name) AS name, COUNT(u.id) AS users_count, COALESCE(SUM(u.points), 0) AS points
FROM skills s
LEFT JOIN users u ON s.id = u.skill_id
LEFT JOIN skills s1 ON s1.id = s.parent_id
GROUP BY COALESCE(s1.id, s.id);
```

Malheureusement cette requête ne fonctionne que s'il y a un seul niveau de profondeur dans
l'arbre des `skills`. C'est bien cette situation qui est décrite dans l'énoncé, et il ne
semble pas vraiment logique d'avoir une telle arboresence pour ce qui est essentiellement
des alias.

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
```


TODO:

- Add navigation between pages
- Allow deleting users and skills (and cascade)
- Allow updating skill of a user, and parent of a skill
- Add tests
