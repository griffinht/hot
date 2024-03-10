(define-module (griffinht packages misc)
               #:use-module (guix packages)
               #:use-module (guix download)
               #:use-module (guix git-download)
               #:use-module (guix build-system copy)
               #:use-module (guix build-system gnu)
               #:use-module ((guix licenses) #:prefix license:)
               #:use-module (guix gexp)
               #:use-module (gnu packages docker)
               #:use-module (gnu packages autotools)
               #:use-module (gnu packages containers)
               #:use-module (gnu packages base)
               #:use-module (gnu packages linux))

; copied from https://issues.guix.gnu.org/66887

(define-public catatonit
  (package
    (name "catatonit")
    (version "0.1.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/openSUSE/catatonit")
             ; include fix for a build error that was merged shortly after 0.1.7
             (commit "cf1fd8a1cc9a40a2c66019d9546891912419d747")))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0ac3vfs5d1ka6q21wr4cya9ka8w4c3z1syzdq9sgrks7qnnkxm2h"))))
    (build-system gnu-build-system)
    (native-inputs (list autoconf automake libtool))
    (synopsis "Container init")
    (description "A container init that is so simple it's effectively brain-dead.")
    (home-page "https://github.com/openSUSE/catatonit")
    (license license:gpl3)))
