docker: envy-laptop.scm
	guix system image --image-type=docker '$<' > '$@'

loaddocker: docker
	# assume the container tag is localhost/guix:latest
	# unfortunately docker load doesn't seem to output this without extra formatting
	# (which i'd rather not parse)
	docker load < "$$(cat $<)" && echo localhost/guix:latest > '$@' || rm -f '$@'

rundocker: loaddocker
	# note control+c does not really work to stop the container :(
	docker run --rm -d -it -p 2222:22 "$$(cat $<)" > rundocker && docker attach "$$(cat $@)"; rm -f '$@'

debugdocker: rundocker
	docker exec -it "$$(cat $<)" /run/current-system/profile/bin/bash --login

sshdocker: rundocker
	ssh -p 2222 root@localhost

image: envy-laptop.scm
	guix system image --save-provenance '$<'

clean:
	rm -f docker loaddocker rundocker
