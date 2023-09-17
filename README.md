# USPolis-Admin

This is the main repo of the USPolis Admin application. It contains the two repositories for Backend and Frontend and sets the configurations for docker.

## Cloning the repo

This is a repo with **submodules**, so make sure to git clone it correctly.

```bash
git clone --recurse-submodules <url>
```

And for pulling the submodules repos:

```bash
git pull --recurse-submodules <url>
```

I personally prefer seting an alias:

```bash
git config --global alias.clone-all 'clone --recurse-submodules'
git config --global alias.pull-all 'pull --recurse-submodules'
```

and everytime you want to clone or pull the submodule:

```bash
git clone-all
git pull-all
```
## Running

The idea is to run both the **backend** and **frontend** on **one** docker container and the **mongodb** on another.
For this, the docker compose is configured.
Running the following command should do the trick

```bash
docker compose build && docker compose up
```