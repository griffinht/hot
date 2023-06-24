#!/usr/bin/env sh

set -e

USERNAME=authelia
PASSWORD=authelia
PROTO=https://
HOST=hot.localhost:4430
# a subdomain of the host that exists (eg $EXISTS.$HOST)
EXISTS=invidious # invidious is at invidious.hot.griffinht.com
# a subdomain of the host that does not exist
EXISTS_NOT=doesnotexist
# the path to the login page
LOGIN_PATH=login/




URL="$PROTO$HOST/"
LOGIN_URL="$URL$LOGIN_PATH"
USERNAME_PASSWORD_BASE64="$(echo -n $USERNAME:$PASSWORD | base64)"






test_unauthorized() {
    # -k accept self signed cert
    # -D dump headers to stderr
    local headers="$(curl -ks -D /dev/stdout --output /dev/null $URL)"
    echo "$headers" | grep --quiet 'HTTP/1.1 302 Moved Temporarily' || (echo "$headers"; return 1)
    echo "$headers" | grep --quiet "Location: ${URL}login/?rd=${URL}" || (echo "$headers"; return 1)
}

# tries to login and returns cookie
login_cookie() {
    #todo env var expansion
    # --data-binary read data from stdin
    echo '{"username":"authelia","password":"authelia","keepMeLoggedIn":false,"targetURL":"https://hot.localhost:4430/"}' \
        | curl -ks -D /dev/stdout --output /dev/null \
            -X POST \
            --data-binary @- \
            "${URL}login/api/firstfactor" | \
                grep Set-Cookie | cut -d ';' -f 1 | cut -d ' ' -f 2
}

get_cookie_head() {
    # todo what is local? am i using it right? is it being overridden by global cookie var?
    local cookie="$1"
    local uri="$2"
    local subdomain="$3"

    url="$PROTO$subdomain$HOST/$uri"
    printf 'head %s\n\tcookie: %s\n\n' \
        "$url" \
        "$cookie" \
        1>&2

    curl -ks \
        -I \
        -H "Cookie: $cookie" \
        "$url"
}

get_cookie_get() {
    local cookie="$1"
    local uri="$2"

    curl -k \
        -H "Cookie: $cookie" \
        "$URL$uri"
}

test_basic() {
    # -I (head) because we don't care about page content
    curl -k \
        -I \
        -H "Proxy-Authorization: Basic $USERNAME_PASSWORD_BASE64" \
        "$URL"

    return "$?"
    # these don't work i also don't think they are supposed to work
    curl -k \
        -I \
        -vv \
        --proxy-anyauth --proxy-user $USER:$PASSWORD "$URL"

    curl -k \
        --user $USER:$PASSWORD "$URL"
}

testting() {
    # grep -c return number of lines matched, which needs to be 2
    local result="$(get_cookie_head "" "" "$EXISTS".)" 
    local expected="Location: $LOGIN_URL?rd=$PROTO$EXISTS.$HOST/"
    if [ "$(echo "$result" | grep -c -e "302" -e "$expected")" -ne 2 ]; then
        printf 'error got the wrong thing:\n%s\nexpected to find\n%s\n' "$result" "$expected"
    else
        echo nice
    fi

    exit 1
}

run_tests() {
    echo test unauthorized
    test_unauthorized || (echo unauthorized auth failed; exit 1)
    # todo awful/missing error checking
    echo test cookie login
    cookie="$(login_cookie)"
    echo test cookie
    get_cookie_head "$cookie" || (echo cookie auth failed; exit 1)
    echo test basic
    test_basic || (echo basic auth failed; exit 1)

    echo auth tests done, now testing individual services

    # 302 is generic redirect for unauthorized
    # todo use a real test framework!!!! also parallelize
    # declarative vs imperative
    # you should be able to write a list of protected and unprototected domains

    # hot.domain
    get_cookie_head "" "" "" | grep -q 302
    get_cookie_head "$cookie" "" "" | grep -q 200
    # hot.domain/doesnotexist
    get_cookie_head "" "$EXISTS_NOT" | grep -q 302
    get_cookie_head "$cookie" "$EXISTS_NOT" | grep -q 404
    # doesnotexist.hot.domain, within protected hot domain
    get_cookie_head "" "" "$EXISTS_NOT." | grep -q 404 # todo make this 302 and check the location!
    get_cookie_head "$cookie" "" "$EXISTS_NOT." | grep -q 404
    # exists.hot.domain
    testting
    #get_cookie_head "" "" "$EXISTS." | grep -q 302
    get_cookie_head "$cookie" "" "$EXISTS." | grep -q 502 # actually a 200 when the service is up
    # bruh.exists.hot.domain
    get_cookie_head "" "" "$EXISTS_NOT.$EXISTS." | grep -q 404 # todo make this 302 and check the location!
    get_cookie_head "$cookie" "" "$EXISTS_NOT.$EXISTS." | grep -q 404
    # doesnotexisthot.domain
    get_cookie_head "" "" "$EXISTS_NOT" | grep -q 404
    get_cookie_head "$cookie" "" "$EXISTS_NOT" | grep -q 404
}
run_tests
