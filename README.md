# USPolis-Admin

This is the main repo of the USPolis Admin application. It contains the two repositories for Backend and Frontend and sets the configurations for docker.

## Running

The idea is to run both the **backend** and **frontend** on **one** docker container and the **mongodb** on another.
For this, the docker compose is configured.
Running the following command should do the trick

```bash
docker compose build && docker compose up
```

## VSCode Usage

To use with vscode, you must first intall the extensions `Remote Explorer` and `Docker`.

After raising the containers, openning the `Remote Explorer` should reveal two docker containers of the compose we've done: one for the **applications** and another for the **database**

Click connecto to the database one and start coding!

## Connecting to MongoDB

### Connect to Container

To interact with your mongodb raised on docker compose, you must first connect to the container itself. To do this, you can use either the VSCode Remote Explorer and attach a VSCode instance to the container, or use your own ```docker``` command on terminal, like this:

```bash
docker exec -it uspolis-admin-mongodb-1 /bin/bash
```

### Launch MongoSH

Now that we're connected, we must launch the ```mongosh```, the cli program to interact with the running database. However, we must inform the credentials on the command, becouse our database is being created with user and password in our docker-compose file. For now, our credentials are **user:pass**, so the command is this one:

```bash
mongosh -u user -p pass
```

Once you-ve launched it, you can start using the mongosh commands, that you can find in MongoDB documentation. An example is the command to list databases:

```mongosh
show dbs
```