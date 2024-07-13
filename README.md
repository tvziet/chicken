# README

## How to setup

### Without Docker
- Config environment variables:
    - Copy the content of `.env.example` to `.env` file:
        ```bash
        cp .env.example .env
        ```

- Config database:
    - Create databases:
        ```bash
        rails db:create
        ```
    
    - Run migration:
        ```bash
        rails db:migrate
        ```

    - Seed the data:
        ```bash
        rails db:seed
        ```

- Config routes:
    - Enable routing for APIs: Set the value of `ATTACHED_API` to 1
    - Enable routing for Admin: Set the value of `ATTACHED_ADMIN` to 1
