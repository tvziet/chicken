# Chicken
> Description - Update later ...

## Table of Contents
* [General Info](#general-information)
* [Technologies Used](#technologies-used)
* [Features](#features)
* [Screenshots](#screenshots)
* [Setup](#setup)
* [API Documentation](#api-documentation)
* [Project Status](#project-status)
* [Room for Improvement](#room-for-improvement)
* [Contact](#contact)

## General Information
Update later ...

## Technologies Used

### 1. Backend Dependencies
The tech stack includes the following:
- Ruby - version 3.1.4
- Rails - version 7.1.3.3
- Postgress (Database)
- Check the [Gemfile](./Gemfile) for other dependencies. You should be careful when changing any gem versions as this  can break the application.

### 2. Frontend Dependencies
The tech stack includes the following:

Updare later ...

## Features

Ready features:

Update later ...

## Screenshots
Update later ...

## Setup

1. Without Docker
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

Incase you get any errors during installation, you can delete the **Gemfile.lock** and then run **bundle** again.

2. With Docker

Update later ...

## API Documentation
Start server and access path `/api-docs/index.html` to access the API Documentation.

## Project Status

Project is: _in progress_ 

## Room for Improvement

Room for improvement:
- Refactoring code to follow DRY & KISS principles
- Upgrading codebase to  newer ruby and rails  versions
- Clean code to remove any comments

To do:
- Prepare app for deployment

## Contact
Created by <vietleuit@gmail.com> - feel free to contact me!
