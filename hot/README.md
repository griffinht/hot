# DEVELOPMENT
note for development everything should work by default - just visit hot.localhost but you need to expose the port!
do note you need localhost to support subdomains, which firefox does i thiunk

headers required
x-forwaded-host hot.localhost:8080
x-forwarded-for 123.123.123.123
x-forwarded-proto http

or run with the https proxy
https has the authoitative proper headers
todo this is a great place to unit test!!!! please!!
TODO UNIT TESTS
TESTING
requires https hot authelia
curl -v -U authelia:authelia --url https://hot.localhost:4430 -k




note this was an error i got once after restarting nginx
time="2023-06-24T15:46:50Z" level=error msg="unable to update last activity: dial tcp: lookup redis: i/o timeout" method=GET path=/api/verify remote_ip=10.89.15.4 stack="github.com/authelia/authelia/v4/internal/middlewares/authelia_context.go:65 (*AutheliaCtx).Error\ngithub.com/authelia/authelia/v4/internal/handlers/handler_verify.go:496     VerifyGET.func1\ngithub.com/authelia/authelia/v4/internal/middlewares/bridge.go:54           (*BridgeBuilder).Build.func1.1\ngithub.com/authelia/authelia/v4/internal/middlewares/headers.go:16          SecurityHeaders.func1\ngithub.com/authelia/authelia/v4/internal/middlewares/metrics.go:40          NewMetricsVerifyRequest.func1.1\ngithub.com/fasthttp/router@v1.4.14/router.go:427                            (*Router).Handler\ngithub.com/valyala/fasthttp@v1.43.0/http.go:154                             (*Response).StatusCode\ngithub.com/authelia/authelia/v4/internal/middlewares/strip_path.go:22       StripPath.func1.1\ngithub.com/authelia/authelia/v4/internal/middlewares/metrics.go:22          NewMetricsRequest.func1.1\ngithub.com/valyala/fasthttp@v1.43.0/server.go:2338                          (*Server).serveConn\ngithub.com/valyala/fasthttp@v1.43.0/workerpool.go:224                       (*workerPool).workerFunc\ngithub.com/valyala/fasthttp@v1.43.0/workerpool.go:196                       (*workerPool).getCh.func1\nruntime/asm_amd64.s:1594                                                    goexit"
auth requests didnt work until the error showed, then things started working again


# SECRETS
worse than a real secret manager but better than environment variables

/home/docker-user/secrets/my_secret
chmod 600 my_secret
