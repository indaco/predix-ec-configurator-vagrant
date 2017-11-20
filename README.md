# Predix Enterprise Connect Configurator - Vagrant Box

Vagrant `ubuntu/trusty64` box setup with all you need to use [predix-ec-configurator](https://github.com/indaco/predix-ec-configurator):

- Git
- Cloud Foundry CLI
- Go 1.9.2
- Nginx
- PostgreSQL

## How to use it?

If you just want to give predix-ec-configurator a test ride, you need few things to be done before getting started with it.

Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and [Vagrant](https://www.vagrantup.com/) and then install the following Vagrant plugins:

```shell
$ vagrant plugin install vagrant-proxyconf
$ vagrant plugin install vagrant-triggers
```

**Note:** if you skip those steps and try to build the VM, plugins will be automatically installed, but you will get an error and need to re-run the build to fix it.

Clone this repos:

```shell
$ git clone https://github.com/indaco/predix-ec-configurator-vagrant
$ cd predix-ec-configurator-vagrant
```

Edit `configs.json` file with your Predix.io credentials:

```shell
"predix": {
    "domain": "run.aws-usw02-pr.ice.predix.io",
    "api": "https://api.system.aws-usw02-pr.ice.predix.io",
    "username": "<your-predix-username>",
    "password": "<your-predix-password>"
}
```

**Notes:**

- If you are not on Predix Basic make sure to update the domain and the api endpoint too.
- f you are behind a proxy be sure to setup `HTTP_PROXY` and `HTTPS_PROXY` variables on your machine and edit `proxy.json` file with the url.

Alright, It is now time to build the VM:

```shell
$ vagrant up
```

Once the setup is finished, open a browser window at `http://localhost:8080` and start configuring your scenario.

When your scenario configuration is finished, you should see what you get from the app into the `output` folder on your local machine.

Now, you follow the instruction as reported on the screen and on the generated markdown file.

## Miscellaneous

1. You can connect to Postgres on VM it using:

  ```shell
  Hostname: localhost
  Port: 65432
  Database: ecdemodb
  Username: ecdemouser
  Password: ecdemo
  ```

2. A new _ecdemodb_ database and a sample _playground_ table with dummy data have already been created.

3. If you need to ssh into the Vagrant box,

  ```shell
  $ vagrant ssh
  ```

--------------------------------------------------------------------------------

### DISCLAIMER

This is **not** an official development neither from the [GE Digital's Predix Team](https://github.com/predixdev) and [GE Digital's Enterprise Connect Team](https://github.com/Enterprise-Connect)
