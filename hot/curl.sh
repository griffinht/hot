#!/usr/bin/env sh

source ./curl.env
USERNAME_PASSWORD_BASE64="$(echo -n $USERNAME:$PASSWORD | base64)"






test_unauthorized() {
    # -k accept self signed cert
    # -D dump headers to stderr
    curl -k \
        -D /dev/stderr \
        "$URL"
    #HTTP/1.1 302 Moved Temporarily
    #Location: ${URL}login/?rd=${URL}
}

# tries to login and returns cookie
login_cookie() {
    #todo env var expansion
    # --data-binary read data from stdin
    echo '{"username":"authelia","password":"authelia","keepMeLoggedIn":false,"targetURL":"https://hot.localhost:4430/"}' \
        | curl -k \
            -D /dev/stdout \
            -X POST \
            --data-binary @- \
            -s \
            --output /dev/null \
            "${URL}login/api/firstfactor" | \
                grep Set-Cookie | cut -d ';' -f 1 | cut -d ' ' -f 2
}

test_cookie() {
    # todo what is local? am i using it right? is it being overridden by global cookie var?
    local cookie="$1"

    curl -k \
        -I \
        -H "Cookie: $cookie" \
        "$URL"
}

test_basic() {
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

echo test unauthorized
test_unauthorized || (echo unauthorized auth failed; exit 1)
# todo awful/missing error checking
echo test cookie login
cookie="$(login_cookie)"
echo test cookie
test_cookie "$cookie" || (echo cookie auth failed; exit 1)
echo test basic
test_basic || (echo basic auth failed; exit 1)
