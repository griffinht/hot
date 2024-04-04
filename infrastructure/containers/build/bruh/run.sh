echo hi

cp /bruh/passwd /etc/passwd

mkdir -p /etc/ssh
ssh-keygen -A
#mkdir /run/ssh
#mkdir /run/sshd

"$(which sshd)" -f /bruh/sshd_config -D -e
