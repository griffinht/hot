(use-modules (griffinht deploy))

(list
  (machine
    ; 'managed-host is a machine that is already running the Guix system and available over the network (via ssh)
    (operating-system (load "system.scm"))
    (environment managed-host-environment-type)
    (configuration
      (local-machine-ssh-configuration))))
