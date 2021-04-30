# Scalingo Promscale Buildpack

This buildpack aims at deploying a Promscale instance on the [Scalingo](https://scalingo.com/) PaaS platform.

## Configuration

### TimescaleDB

The buildpack is expecting a PostgreSQL database with TimescaleDB enabled. TimescaleDB must be manually enabled on the database by an operator on the database administration panel. The credentials to connect to the database must be defined in the environment variable `PROMSCALE_DB_URI`. The default Scalingo user does not work for Promscale. You should use the user `promscale_user` as defined below. The SQL query requires a md5 hashed password with the following command:

```bash
DB_PASSWORD="mon mot de passe"
echo -n "${DB_PASSWORD}promscale_user" | md5sum | cut -d' ' -f1
```

Create and configure the Promscale user with the following commands. Replace `$HASHED_PASSWORD` with the output of the above command.

```sql
CREATE ROLE promscale_user LOGIN NOSUPERUSER NOCREATEDB CREATEROLE;
ALTER ROLE promscale_user ENCRYPTED PASSWORD 'md5$HASHED_PASSWORD';

CREATE DATABASE promscale_database ENCODING UTF8 LC_COLLATE 'en_US.utf8' LC_CTYPE 'en_US.utf8' TEMPLATE template0 OWNER promscale_user;
GRANT ALL PRIVILEGES ON DATABASE promscale_database TO promscale_user;
```

### Basic Authentication

This buildpack makes it mandatory to enable a Basic Auth protection. The application must define the `PROMSCALE_AUTH_USERNAME` and `PROMSCALE_AUTH_PASSWORD` environment variables with the credentials.

### Database Max Connections

By default, Promscale tries to use 80% of the maximum connections that the database can handle. This might be too much and you may want to reduce the number of connections used by Promscale. You may see the following error messages:

```text
FATAL: remaining connection slots are reserved for non-replication superuser connections (SQLSTATE 53300)
```

Define the environment variable `PROMSCALE_DB_CONNECTIONS_MAX` to limit the amount of connections used by Promscale.

### PostgreSQL Extensions

Promscale requires the TimescaleDB extension to work. It is also possible to install a [Promscale extension](https://github.com/timescale/promscale_extension) to improve the performance. Thos can't be enabled by `promscale_user`. Hence, disable them on Promscale by setting these environment variables: `PROMSCALE_INSTALL_EXTENSIONS=false` and `PROMSCALE_UPGRADE_EXTENSIONS=false`.

## Defining the Version

By default we're installing the version of Promscale declared in the [`bin/compile`](https://github.com/Scalingo/promscale-buildpack/blob/master/bin/compile#L16) file. But if you want to use a specific version, you can define the environment variable `PROMSCALE_VERSION`.

```shell
$ scalingo env-set PROMSCALE_VERSION=0.3.0
```
