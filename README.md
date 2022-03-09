# Scalingo Promscale Buildpack

This buildpack aims at deploying a Promscale instance on the [Scalingo](https://scalingo.com/) PaaS platform.

## Configuration

### TimescaleDB

The buildpack is expecting a PostgreSQL database with TimescaleDB Community Edition enabled. TimescaleDB Community Edition must be manually enabled on the database by an operator on the database administration panel.

The credentials to connect to the database must be defined in the environment variable `SCALINGO_POSTGRESQL_URL`. The default Scalingo user does not work out of the box for Promscale. You should add it the privilege `CREATEROLE`. The SQL query, by replacing `username` with the actual username, is:

```sql
ALTER ROLE username WITH CREATEROLE;
```

This is also mandatory to update the connection string in the environment variable `SCALINGO_POSTGRESQL_URL`. The SSL mode **must** be `require`.

After the initial start of Promscale, it is safe to remove the `CREATEROLE` attribute:

```sql
ALTER ROLE username WITH NOCREATEROLE;
```

### Basic Authentication

This buildpack makes it mandatory to enable a Basic Auth protection. The application must define the `PROMSCALE_WEB_AUTH_USERNAME` and `PROMSCALE_WEB_AUTH_PASSWORD` environment variables with the credentials.

### Database Max Connections

By default, Promscale tries to use 80% of the maximum connections that the database can handle. This might be too much and you may want to reduce the number of connections used by Promscale. You may see the following error messages:

```text
FATAL: remaining connection slots are reserved for non-replication superuser connections (SQLSTATE 53300)
```

Define the environment variable `PROMSCALE_DB_CONNECTIONS_MAX` to limit the amount of connections used by Promscale.

### PostgreSQL Extensions

Promscale requires the TimescaleDB extension to work. It is also possible to install a [Promscale extension](https://github.com/timescale/promscale_extension) to improve the performance. Those can't be enabled by the default PostgreSQL user. Hence, disable them on Promscale by setting these environment variables: `PROMSCALE_STARTUP_INSTALL_EXTENSIONS=false` and `PROMSCALE_STARTUP_UPGRADE_EXTENSIONS=false`.

## Defining the Version

By default we're installing the version of Promscale declared in the [`bin/compile`](https://github.com/Scalingo/promscale-buildpack/blob/master/bin/compile#L16) file. But if you want to use a specific version, you can define the environment variable `PROMSCALE_VERSION`.

```shell
scalingo env-set PROMSCALE_VERSION=0.10.0
```

## Upgrade

Upgrading Promscale may require to execute a migration script on the database. In this case, you may face the error:

```
Failed to acquire the migration lock to upgrade the schema version and unable to run with the old version. Please ensure that no other Promscale connectors with the old schema version are running.
```

To fix this issue, you first need to scale the Promscale application down to 0 container, then deploy the new version, and last scale the Promscale back up.
