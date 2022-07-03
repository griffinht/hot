# Setup
backblaze > `My Account` > `App Key` > `Add a New Application Key`

- `keyName`=`hot`
- `bucketName`=`hot-griffinht-com`
- `capabilities`=`Read and Write`

click the create key button or something
then put the info in to a file called .env for docker compose environment
note if some things have special characters then they may need to be escaped with ''

`.env file`
```
RESTIC_B2_ID=<id>
RESTIC_B2_KEY=<key>
RESTIC_PASSWORD=<password>
```

# Restore
https://restic.readthedocs.io/en/latest/050_restore.html

### log in to running restic container
`docker exec -it $(docker ps -aq --filter name=restic) sh`

(executes an interactive shell (`sh`) in the container that is running restic)

### set environment variables for restic (see `restic/entrypoint.sh`)
(you can just copy this block in to your `docker exec -it` shell)
```
export B2_ACCOUNT_ID="$RESTIC_B2_ID"
export B2_ACCOUNT_KEY="$RESTIC_B2_KEY"

export RESTIC_PASSWORD="$RESTIC_PASSWORD"

BUCKET='hot-griffinht-com'
REPOSITORY='hot'
export RESTIC_REPOSITORY='b2:'"$BUCKET"':'"$REPOSITORY"

BACKUP='/data/public'
CACHE='/restic/cache'
```
### figure out which snapshot to restore from
Read the docs (https://restic.readthedocs.io/en/latest/050_restore.html) to see how to browse snapshots so you can figure out which snapshot to restore from. The snapshot you restore from may not be the most recent snapshot.
### restore
`restic restore <snapshot> --target /`

using `--target /` should restore snapshots back to the correct live docker volume
