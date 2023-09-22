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