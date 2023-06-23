#!/usr/bin/env sh

source ./curl.env
USERNAME_PASSWORD_BASE64="$(echo -n $USERNAME:$PASSWORD | base64)"






test_unauthorized() {
    # -k accept self signed cert
    # -D dump headers to stderr
    curl -k \
        -D /dev/stderr \
        "$URL"
    HTTP/1.1 302 Moved Temporarily
    Location: ${URL}login/?rd=${URL}
}

# tries to login and returns cookie
login() {
    #todo env var expansion
    # --data-binary read data from stdin
    echo '{"username":"authelia","password":"authelia","keepMeLoggedIn":false,"targetURL":"https://hot.localhost:4430/"}' \
        | curl -k \
            -D /dev/stderr \ 
            -X POST \
            --data-binary @- \ 
            "${URL}login/api/firstfactor"

    cat testfile | grep Set-Cookie | cut -d ';' -f 1 | cut -d ' ' -f 2
}

test_login_basic() {
    # -I because we don't care about page content
    curl -k \
        -I \
        -H "Proxy-Authorization: Basic $USERNAME_PASSWORD_BASE64" \
        "$URL"

    exit $?
    # these don't work i also don't think they are supposed to work
    curl -k \
        -I \
        -vv \
        --proxy-anyauth --proxy-user $USER:$PASSWORD "$URL"

    curl -k \
        --user $USER:$PASSWORD "$URL"
}

test_login_basic
