IMAGE_TAG=griffinht/iperf

up: build
	docker compose up -d iperf3

build:
	guix pack -f docker \
		--compression=none \
		--entry-point=/bin/iperf3 \
		iperf \
		| xargs cat | docker load \
		| cut -d ':' -f 2 | tail -c +2 \
		| xargs -I % docker tag % '$(IMAGE_TAG)'

dev:
	# --compression=none faster
	# --no-substitutes slows us down checking each time, instead just guix shell iperf once then you won't need any substitutes
	guix pack -f docker \
		--no-substitutes \
		--compression=none \
		--entry-point=/bin/iperf3 \
		iperf \
		| xargs cat | docker load \
		| cut -d ':' -f 2 | tail -c +2 \
		| xargs -I % docker tag % '$(IMAGE_TAG)'
	docker run --rm -it '$(IMAGE_TAG)'
