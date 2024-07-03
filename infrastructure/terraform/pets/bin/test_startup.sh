scp startup.sh "${SSH_HOST?}":
ssh "${SSH_HOST?}" ./startup.sh
