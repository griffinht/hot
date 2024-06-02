(define-module (package)
               #:use-module (guix packages)
               #:use-module (guix download)
               #:use-module (guix build-system python)
               #:use-module (guix build-system pyproject)
               #:use-module ((guix licenses) #:prefix license:)
               #:use-module (guix gexp)
               #:use-module (gnu packages python-xyz)
               #:use-module (gnu packages monitoring))

(define-public python-speedtest-cli
  (package
    (name "python-speedtest-cli")
    (version "2.1.3")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "speedtest-cli" version))
       (sha256
        (base32 "1w4h7m0isbvfy4zx6m5j4594p5y4pjbpzsr0h4yzmdgd7hip69sy"))))
    (build-system pyproject-build-system)
    (home-page "https://github.com/sivel/speedtest-cli")
    (synopsis
     "Command line interface for testing internet bandwidth using speedtest.net")
    (description
     "Command line interface for testing internet bandwidth using speedtest.net")
    (license license:asl2.0)))

(define-public python-routeros-api
  (package
    (name "python-routeros-api")
    (version "0.17.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "RouterOS-api" version))
       (sha256
        (base32 "0ll2mrzfq8rgwv80vjf4mbh4mwn2fidljza79ssnfinc1r39i60v"))))
    (build-system pyproject-build-system)
    (arguments
      '(#:phases (modify-phases %standard-phases
                   ; tests are broken/won't run i think
                   (delete 'check))))
    (propagated-inputs (list python-six))
    (home-page "https://github.com/socialwifi/RouterOS-api")
    (synopsis "Python API to RouterBoard devices produced by MikroTik.")
    (description
     "Python API to @code{RouterBoard} devices produced by @code{MikroTik}.")
    (license license:expat)))

(define-public python-mktxp
  (package
    (name "python-mktxp")
    (version "1.2.3")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "mktxp" version))
       (sha256
        (base32 "1i64y9x5cs7wd4c0kr9z1l0z7syvmx496vpkf09hch6a8hqz1knl"))))
    (build-system pyproject-build-system)
    (arguments
      '(#:phases (modify-phases %standard-phases
                   ; tests need internet i think
                   (delete 'check)
                   ;(delete 'sanity-check)
                   )))
    (propagated-inputs (list python-configobj
                             ; sanity-check reports this version as 0.0.0 even though it is version 4.0.0
                             ; https://lists.gnu.org/archive/html/bug-guix/2022-04/msg00134.html
                             (package (inherit python-humanize)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'build 'pretend-version
            ;; The version string is usually derived via setuptools-scm, but
            ;; without the git metadata available, the version string is set to
            ;; '0.0.0'.
            (lambda _
              (setenv "SETUPTOOLS_SCM_PRETEND_VERSION" #$version)))))))
                             python-prometheus-client
                             python-routeros-api
                             python-speedtest-cli
                             python-texttable
                             python-waitress))
    (home-page "https://github.com/akpw/mktxp")
    (synopsis "Prometheus Exporter for Mikrotik RouterOS devices")
    (description "Prometheus Exporter for Mikrotik @code{RouterOS} devices")
    (license #f)))
