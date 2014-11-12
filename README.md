open-lmis-docker
================

Docker images for [OpenLMIS](http://openlmis.org)

# About
[Docker](http://docker.com) enables container-based deployments on Linux based operating systems.  This repository is an effort to build simple docker containers of the OpenLMIS project suitable for demos and development tasks.

**These containers are not intended for production deployments.**

The design of this repository uses:

- A base image built from `docker/base/`
- OpenLMIS source code placed in `open-lmis/`
- Optionally the OpenLMIS-Manager application placed in `open-lmis-manger/`


# Directory Structure

### `docker/`

Contains setup and run scripts, configuration files and Dockerfile for base image.

### `docker/base/`

Dockerfile for base image **build this first**

### `docker/postgres/`

Configuration files for included postgres.

### `docker/tomcat/`

Configuration files for included tomcat.

### `db/`

(**Optional**) Contains database snapshot that will be used when first launching instance.

### `open-lmis/`

OpenLMIS source code.  This is added by you.

### `open-lmis-manager/`

(**Optional**) OpenLMIS-Manager application source code.  This is added by you.


# Requirements

- Docker (1.1+)
- Git (1.8+)


# Getting Started

1. Build the OpenLMIS base image:


    ```shell
    cd docker/base
    docker build -t "joshzamor/openlmis_base:latest" .
    ```

2. Add the Open-LMIS source code.  This can either be copied into place or `git clone`.  Note that building this image builds the OpenLMIS source code.  This process requires Karma which requires Firefox to be available to run it's tests.  You have 2 options around this: solve the headless Karma problem (please) or merge in this [headless-build branch](https://github.com/joshzamor/open-lmis/tree/headless-build) which disables Karma for headless builds.


    ```shell
    cd ../..
    git clone https://github.com/OpenLMIS/open-lmis.git
    ```

3. Get OpenLMIS submodules.

    ```shell
    cd open-lmis
    git submodule init
    git submodule update
    ```

4.  (optional).  Add in an initial DB snapshot.  This adds in an initial database to use with OpenLMIS upon instance run.  If ommited the standard clean OpenLMIS database will be used.

    ```shell
    cp your-db-snapshot.dump db/open_lmis.custom
    ```

5. (optional).  Get Open-LMIS-Manager.  This simple manager application will add the URL `/open-lmis-manager` that allows anyone to reset the database.  It's recommended that step 4, providing an initial db snapshot, be done if Open-LMIS-Manager is deployed.

    ```shell
    git clone https://github.com/joshzamor/open-lmis-manager.git
    ```

6. Build OpenLMIS container.

    ```shell
    cd ..
    docker build -t "joshzamor/openlmis:latest" .
    ```

7. Run OpenLMIS container.

    ```shell
    docker run -d -P --name your-name-here joshzamor/openlmis
    ```
Runs OpenLMIS with `your-name-here` and will automatically expose the Postgres and Tomcat ports.

To determine the url to access the local instance of OpenLMIS from your browser you need to know the IP address of the local instance and the port number mapped to http.

To determine the ip address, at a non-docker command prompt.

```shell
boot2docker ip
```

To determine the port mapping at a command prompt within docker type.

```shell
docker ps
```

From a browser on your local machine you would access OpenLMIS with a URL like.

```shell
http://192.168.59.103:49154/
```

# Useful volumes:

`/var/logs` 

contains system logs

`/home/openlmis` 

contains tomcat running OpenLMIS which includes Tomcat logs as well as OpenLMIS logs.

`/open-lmis-db` 

contains `open_lmis.custom` which is the database snapshot the Open-LMIS-Manager application uses to reset the database from.

### examples


`docker run -d -P -v /var/logs -v /home/openlmis -v /your/host/path/to/db-snapshot/:/open-lmis-db --name openlmis-demo joshzamor/openlmis`

This will run OpenLMIS, expose tomcat and postgres ports, allow another container to someday mount `/var/logs` and `/home/openlmis` to debug issues, mounts the hosts database snapshot at `/your/host/path/to/db-snapshot/` to the containers `/open-lmis-db` (make sure the hosts db snapshot is named `open_lmis.custom`) and finally runs it with the name `openlmis-demo`.

# Useful ports

`5432` is postgres which will allow all connections with a password.

**it's not recommended to expose postgres to the public internet**

`8080` is Tomcat which runs http to OpenLMIS.

### examples

`docker run -d -p 80:8080 -p 5432:5432 joshzamor/openlmis`

This will run OpenLMIS and map your host's ports 80 to 8080 (tomcat) and 5432 to 5432 (postgres).  *However don't expose postgres (5432) to the public internet in this fashion*.  Ensure your firewall blocks access to postgres and if you need a DB connection through the public internet, use an SSH tunnel.
