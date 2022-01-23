# Setup
backblaze > `My Account` > `App Key` > `Add a New Application Key`

- `keyName`=`hot`
- `bucketName`=`hot-griffinht-com`
- `capabilities`=`Read and Write`

Enter `applicationKey` here (`Copy to Clipboard`): ...

done

`.env file`
```
RESTIC_B2_ID=<id>
RESTIC_B2_KEY=<key>
RESTIC_PASSWORD=<password>
```

# Restore
https://restic.readthedocs.io/en/latest/050_restore.html

### log in to running restic container
`docker exec -it $(docker ps -aqf name=restic) sh`
### set environment variables for restic (see `restic/entrypoint.sh`)
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
### restore
`restic restore <snapshot> --target /`

read the docs (https://restic.readthedocs.io/en/latest/050_restore.html) to see how to browse snapshots so you can figure out which snapshot to restore from