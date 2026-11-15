# Landing

## Production with Docker Compose

Docker Desktop must be running. From the repository root, create the host
directories and start the app:

```sh
mkdir -p /Users/rob/azinger.io/db /Users/rob/azinger.io/log
./start-landing-prod.sh
```

The start script builds the image from the current source and starts the
container in the background. Stop it with `./stop-landing-prod.sh`.
The stop script also removes orphaned containers from the same Compose project.

The app listens on host port 3000 and container port 80. Compose uses the
`azinger-io-landing:main` image, mounts `config/master.key` read-only, and
prepares the production databases on startup. Keep the master key private and
back it up separately. The `db` directory also holds Active Storage uploads.
The container is named `azinger-io-landing-main-container` and its network is
`azinger-io-landing-main-network`; Docker names cannot use the image tag's
colon.

From `landing/`, you can also use Compose directly:

```sh
docker compose logs -f     # follow container output
docker compose down        # stop and remove the container and network
docker compose up -d       # start again using the existing image
```

`down` does not delete the bind-mounted databases, uploads, or logs. Rebuild
with `docker compose up -d --build` after changing the app. Rails writes to
both `log/production.log` and the container output, prefixing its entries with
`[landing]`. Output from other processes, such as Puma, is not prefixed. Back
up the data directories; for consistent SQLite backups, stop the app first or
use SQLite's backup facility.

From the repository root, follow the last 100 lines and new Rails log entries:

```sh
./logs-landing.sh              # production
./logs-landing.sh development  # local development
```

Press Ctrl-C to stop following. The script follows the configured
`LANDING_DATA_ROOT` for production or `LANDING_LOG_DIR` for development.
Use `docker compose logs -f` for all container output, including Puma.

Run `./clear-landing-log.sh` from the repository root to clear the production
log file without stopping the app. This removes every entry in the file,
including entries from other apps sharing it; Docker's container logs are
unaffected.

## Local development

Run `bin/rails server` normally. Development uses
`/Users/rob/azinger.io/db/development.sqlite3` and
`/Users/rob/azinger.io/log/development.log`, separate from production. Create
the directories above first, then run `bin/rails db:prepare` if needed. The
test database remains in `storage/test.sqlite3`.

If you want to keep an existing `storage/development.sqlite3`, stop the old
server and copy it to the new location before preparing the database. Do not
overwrite an existing database; copy any existing logs separately if needed.
Existing production databases in `storage/` likewise must be backed up and
moved to the host `db` directory before the first container startup if you
want to retain their data.

Production and development cannot both bind port 3000. While the container
is running, use `bin/rails server -p 3001` for development. The Cloudflare
tunnel can continue to point to `localhost:3000` for production.

For another host or isolated run, set `LANDING_DATA_ROOT` for Compose (the
directory containing `db` and `log`) and optionally `LANDING_PORT` for the
host port. For local Rails, `LANDING_DB_DIR` and `LANDING_LOG_DIR` override
the individual directories.
