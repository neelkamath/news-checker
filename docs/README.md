# Installing

## [Develop locally](local.md)

## [Forking the repository](fork.md)

## [Deploy Your Own Instance](deploy.md)

# Documentation

## Server

[Heroku](https://www.heroku.com) is the server used.

## Database

[Heroku Postgres](https://www.heroku.com/postgres) is the RDBMS used.

```
                                               Table "public.reported"
    Column     |       Type        | Collation | Nullable |      Default      | Storage  | Stats target | Description 
---------------+-------------------+-----------+----------+-------------------+----------+--------------+-------------
 type          | character varying |           | not null |                   | extended |              | 
 article_title | character varying |           | not null |                   | extended |              |
 date          | date              |           | not null | CURRENT_TIMESTAMP | plain    |              | 
Check constraints:
    "reported_type_check" CHECK (type::text = ANY (ARRAY['fake'::character varying, 'satire'::character varying, 'faux_satire'::character varying, 'real'::character varying]::text[]))
```

# Notes

- If you've forked the repository, note that the [GitLab CI file](../.gitlab-ci.yml) is set to automatically deploy the app to Heroku for commits on the `master` branch where the CI has passed.
- If the database is to be updated (such as a new table has been created), you can reflect these changes in [db.dart](../lib/components/db.dart).
- There must be an attribution link to [News API](https://newsapi.org) (this project already has one). 
