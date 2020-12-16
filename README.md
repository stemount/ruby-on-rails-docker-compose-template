![](.readme/rails.png)

#### → Getting started with this project

This uses `docker-compose` for simplicity of getting together a Ruby on Rails 6 application with a PostgreSQL database.

**Start containers**

```bash
docker-compose up -d
```

**Restart Ruby instance**

```bash
docker-compose restart web
```

**Destroy PostgreSQL databases if you mess up or similar reason**

This nukes the `PGDATA` contents including databases, passwords et al.

Useful if you are testing migrations or are prototyping your database model.

```bash
rm -rf ./tmp/db/* && docker-compose up --force-recreate postgres
```

**Stop containers**

```bash
docker-compose stop
```

---

#### → Start Developing

It is required to create the databases using Rails.

It is recommended to use migration files over any sort of hacks.

It is recommended to have seed data to test your models too.

- **How to interact with the Rails docker instance**

  ```bash
  docker-compose exec web /bin/bash
  ```
  
  **These commands will be essential**
  
  - `rails db:create`
  - `rails db:migrate`
  - `rails db:seed`
  
---

###### Technical Info

**Rails version:** 6.1

**Ruby version:** ruby 2.7.2

**Base Linux distro:** Debian Buster

###### Default settings

**PostgreSQL User**: `root` **PostgreSQL Password**: `password`
