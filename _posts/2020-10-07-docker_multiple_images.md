---
layout: single
title: "Exporting Multiple Docker Images Alongside Docker-Compose"
date: 2020-10-07 12:00:00 -0000
categories: docker docker-compose
excerpt: You can't export containers together in one larger container. You can, however, maintain the link between them with docker-compose.
---

It is possible to export a Docker container for use on another machine.

However, what if you have two containers locally that are connected with `docker-compose`, and you want to export them together?

Unfortunately, you can't quite do that. However, exporting them both together with your compose file is not that difficult.

# Exporting

Let's look at an example. Say I have a `project/` directory, with two subdirectories: `project/frontend/` and `project/backend/`, and each has its own `Dockerfile`. A `project/docker-compose.yml` that connects them together might look like this:

```yml
version: "3.2"
services:
  backend:
    build: ./backend
    volumes:
      - ./backend:/app/backend
    ports:
      - "8000:8000"
    stdin_open: true
    tty: true
    command: python3 manage.py runserver 0.0.0.0:8000
  frontend:
    build: ./frontend
    volumes:
      - ./frontend:/app
      # One-way volume to use node_modules from inside image
      - /app/node_modules
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
    depends_on:
      - backend
    stdin_open: true
    command: yarn start
```

Here, `docker-compose` has defined several important aspects about the project, including where the code is located. If I run `docker-compose up`, it will start both environments. It will refer to the two `Dockerfile`s in their subdirectories, and then will create containers accordingly. If you open Docker Desktop, you should see the two containers running together under a section named after the folder your `.yml` file is in.

|![Example Docker Desktop](/assets/images/docker/docker_desktop.png)|
| *For example. My directory is called canoe_docker.* |

Now you can export the running containers to `.tar` files. To do so, first look at the running processes with `docker ps`. For example, this is what my terminal prints out:
```bash
CONTAINER ID        IMAGE                   COMMAND                  CREATED             STATUS              PORTS                    NAMES
1b7cf2821d4e        canoe_docker_frontend   "docker-entrypoint.s…"   4 hours ago         Up 5 minutes        0.0.0.0:3000->3000/tcp   canoe_docker_frontend_1
902987a44d0a        canoe_docker_backend    "python3 manage.py r…"   4 hours ago         Up 5 minutes        0.0.0.0:8000->8000/tcp   canoe_docker_backend_1
```

Then commit them with the following commands. Make sure to change it to your own container_id, and your own name for the image.

```bash
docker commit 902987a44d0a my_backend
docker commit 1b7cf2821d4e my_frontend
```

Next, save them to a tarball (this will take a while). The tarball can have any name you like.
```bash
docker save my_backend > backend.tar
docker save my_frontend > frontend.tar
```

Finally, you need a new `docker-compose.yml`. This _only_ needs to be changed to reflect that you are no longer using directories, but Docker images. We will change the `build` argument, and remove the `volumes`.

```yml
version: "3.2"
services:
  backend:
    image: my_backend
    ports:
      - "8000:8000"
    stdin_open: true
    tty: true
    command: python3 manage.py runserver 0.0.0.0:8000
  frontend:
    image: my_frontend
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
    depends_on:
      - backend
    stdin_open: true
    command: yarn start
```

So now you have three files to export:

```bash
backend.tar
frontend.tar
docker-compose.yml  # This should be the updated one.
```

# Importing

Once you get your files to a new machine, spinning up Docker is trivial! Make sure that you are in the right directory, then load the tarballs into Docker (this will take a loooong time): 

```bash
docker load --input frontend.tar && docker load --input backend.tar
```

Finally, run them.

```bash
docker-compose up
```