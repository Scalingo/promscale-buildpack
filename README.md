# Scalingo Promscale Buildpack

This buildpack aims at deploying a Promscale instance on the [Scalingo](https://scalingo.com/) PaaS platform.

## Configuration

### TimescaleDB

The buildpack is expecting a PostgreSQL database with TimescaleDB enabled. TimescaleDB must be manually enabled on the database by an operator on the database administration panel. Promscale requires **admin** access to the database. The credentials to connect to the database must be defined in the environment variable `PROMSCALE_DB_URI`.

### Basic Authentication

This buildpack makes it mandatory to enable a Basic Auth protection. The application must define the `PROMSCALE_AUTH_USERNAME` and `PROMSCALE_AUTH_PASSWORD` environment variables with the credentials.

### Database Max Connections

By default, Promscale tries to use 80% of the maximum connections that the database can handle. This might be too much and you may want to reduce the number of connections used by Promscale. You may see the following error messages:

```text
FATAL: remaining connection slots are reserved for non-replication superuser connections (SQLSTATE 53300)
```

Define the environment variable `PROMSCALE_DB_CONNECTIONS_MAX` to limit the amount of connections used by Promscale.

## Defining the Version

By default we're installing the version of Promscale declared in the [`bin/compile`](https://github.com/Scalingo/promscale-buildpack/blob/master/bin/compile#L16) file. But if you want to use a specific version, you can define the environment variable `PROMSCALE_VERSION`.

```shell
$ scalingo env-set PROMSCALE_VERSION=0.3.0
```
