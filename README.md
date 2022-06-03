![railsgang](.readme/rails.png)

## → Getting started with this project

This uses `docker-compose` for simplicity of getting together a **Ruby on Rails 6** application with a **PostgreSQL** database using `docker-compose`.
## → What is this Docker V2 compose message?

Some may have Docker V2 (Experimental Support for `docker compose`). It is most likely that Docker Desktop will use V1 unless you specify otherwise. Use `docker-compose` for any commands that are `docker compose`.

<br />
<hr />
<br />

### → Docker Start basics

- **Start containers**

- If you are using Docker V2:

  ```bash
  docker compose up -d --build
  ```
- If you are not using Docker V2:

  ```bash
  docker-compose up -d --build
  ```

- **Restart Ruby instance**

- If you are using Docker V2:

  ```bash
  docker compose restart web
  ```
- If you are not using Docker V2:

  ```bash
  docker-compose restart web
  ```

- **Destroy PostgreSQL databases if you mess up or similar reason**

  This nukes the `PGDATA` contents including databases, passwords et al.

  Useful if you are testing migrations or are prototyping your database model.

  ```bash
  rm -rf ./tmp/db/* && docker compose up --force-recreate postgres
  ```

- **Stop containers**

- If you are using Docker V2:

  ```bash
  docker compose stop
  ```
- If you are not using Docker V2:

  ```bash
  docker-compose stop
  ```

<br />
<hr />
<br />

### → Start Developing

It is required to create the databases using Rails.

It is recommended to use migration files over any sort of hacks.

It is recommended to have seed data to test your models too.

- **How to interact with the Rails docker instance**

  - If you are using Docker V2:

    ```bash
    docker compose exec web /bin/bash
    ```

  - If you are not using Docker V2:

    ```bash
    docker-compose exec web /bin/bash
    ```

  **These commands will be essential**

  - `rails db:create`
  - `rails db:migrate`
  - `rails db:seed`

<br />
<hr />
<br />

### Technical Info

- **Rails version:** 6.1 (latest)

- **Ruby version:** ruby 3.x (latest)

- **Base Linux distro:** Debian Buster

### Default settings

- **PostgreSQL User**: `root` **PostgreSQL Password**: `password`
