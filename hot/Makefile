# allow parallelism
MAKEFLAGS := --jobs

default: hot.service

hot.service: \
	authelia.proxied.service \
	gossa.proxied.service \
	grocy.proxied.service \
	invidious.proxied.service \
	libreddit.proxied.service \
	nitter.proxied.service \
	photoprism.proxied.service \
	quetre.proxied.service \
	rimgo.proxied.service \
	rss.proxied.service \
	scribe.proxied.service \
	searx.proxied.service \
	speedtest.proxied.service \
	vaultwarden.proxied.service

%.proxied.service: proxied/%/docker-compose.yml \
	proxied/%/production.env
	cd 'proxied/$*' && source ./production.env && docker compose up -d '$*'
	touch '$@'

%.service: docker-compose.yml \
	production.env
	source ./production.env && docker compose up -d '$*'
	touch '$@'

%.proxied.service: proxied/%/docker-compose.yml
	cd 'proxied/$*' && docker compose up -d '$*'
	touch '$@'

%.service: docker-compose.yml
	docker compose up -d '$*'
	touch '$@'

scribe.proxied.service: scribe.image.service

scribe.image.service:
	./proxied/scribe/build.sh
	touch '$@'

clean:
	rm *.service
