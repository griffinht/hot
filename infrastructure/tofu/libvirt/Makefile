.PHONY: phony

test:
	exit 1
	shell.sh -- tunnel3.sh shell.sh tunnel.env

Makefile: phony
	# shell.sh -- shell.sh tunnel.env
	#tofu apply
	exit 1

deploy:
	# nix shell
	cloud-init schema --config-file cloud_init.yml
	# guix shell
	tofu apply
