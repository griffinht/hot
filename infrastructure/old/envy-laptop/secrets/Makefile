all: secrets \
	secrets/authelia_session \
	secrets/authelia_storage \
	secrets/authelia_jwt

secrets:
	mkdir secrets
	chmod 700 secrets || rmdir '$@'

secrets/%:
	openssl rand -hex 64 > '$@' || rm '$@'
	chmod 600 '$@' || rm '$@'

clean:
	rm -r secrets

# im literally using guix and i choose to deploy this file via scp
# forgive me for i am weak
# todo write a guix package or something
deploy:
	scp Makefile docker-user@192.168.0.6:
	ssh docker-user@192.168.0.6 guix shell make openssl -- make
