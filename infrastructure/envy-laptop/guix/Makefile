guix.docker: bootstrap.scm
	# --network flag is important!
	#  tells guix not to enable networking services which would conflict with docker causing ssh-daemon to fail to start!
	guix system image --image-type=docker --network '$<' > '$@'

load.docker: guix.docker
	# assume the container tag is localhost/guix:latest
	# unfortunately docker load doesn't seem to output this without extra formatting
	# (which i'd rather not parse)
	#docker load < "$$(cat $<)" && echo localhost/guix:latest > '$@' || rm -f '$@'
	docker load < "$$(cat $<)" && echo guix:latest > '$@' || rm -f '$@'

run.docker: load.docker
	# note control+c does not really work to stop the container :(
	docker run --rm -d -it -p 2222:22 "$$(cat $<)" > '$@' 
	#docker run --rm -d -it --network=none "$$(cat $<)" > '$@' && docker attach "$$(cat $@)"; rm -f '$@'

monitor.docker: run.docker
	docker attach "$$(cat $<)"; rm -f '$<'

debug.docker: run.docker
	docker exec -it "$$(cat $<)" /run/current-system/profile/bin/bash --login

ssh.docker: run.docker
	ssh -p 2222 root@localhost

stop.docker: run.docker
	docker stop "$$(cat $<)"

deploy.docker: system.scm run.docker
	guix deploy "$<"

image: bootstrap.scm
	guix system image --save-provenance '$<'

clean:
	rm -f docker loaddocker rundocker
