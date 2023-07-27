docker: envy-laptop.scm
	# --network flag is important!
	#  tells guix not to enable networking services which would conflict with docker causing ssh-daemon to fail to start!
	guix system image --image-type=docker --network '$<' > '$@'

loaddocker: docker
	# assume the container tag is localhost/guix:latest
	# unfortunately docker load doesn't seem to output this without extra formatting
	# (which i'd rather not parse)
	#docker load < "$$(cat $<)" && echo localhost/guix:latest > '$@' || rm -f '$@'
	docker load < "$$(cat $<)" && echo guix:latest > '$@' || rm -f '$@'

rundocker: loaddocker
	# note control+c does not really work to stop the container :(
	docker run --rm -d -it -p 2222:22 "$$(cat $<)" > rundocker 
	#docker run --rm -d -it --network=none "$$(cat $<)" > rundocker && docker attach "$$(cat $@)"; rm -f '$@'

monitordocker: rundocker
	docker attach "$$(cat $<)"; rm -f '$<'

debugdocker: rundocker
	docker exec -it "$$(cat $<)" /run/current-system/profile/bin/bash --login

sshdocker: rundocker
	ssh -p 2222 root@localhost

stopdocker: rundocker
	docker stop "$$(cat $<)"

image: envy-laptop.scm
	guix system image --save-provenance '$<'

clean:
	rm -f docker loaddocker rundocker
