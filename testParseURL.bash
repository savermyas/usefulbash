#!/usr/bin/env bash

source parseURL.bash

#https://mathiasbynens.be/demo/url-regex

VALID_URLS=(
"http://foo.com/blah_blah"
"http://foo.com/blah_blah/"
"http://foo.com/blah_blah_(wikipedia)"
"http://foo.com/blah_blah_(wikipedia)_(again)"
"http://www.example.com/wpstyle/?p=364"
"https://www.example.com/foo/?bar=baz&inga=42&quux"
"http://✪df.ws/123"
"http://userid:password@example.com:8080"
"http://userid:password@example.com:8080/"
"http://userid@example.com"
"http://userid@example.com/"
"http://userid@example.com:8080"
"http://userid@example.com:8080/"
"http://userid:password@example.com"
"http://userid:password@example.com/"
"http://142.42.1.1/"
"http://142.42.1.1:8080/"
"http://➡.ws/䨹"
"http://⌘.ws"
"http://⌘.ws/"
"http://foo.com/blah_(wikipedia)#cite-1"
"http://foo.com/blah_(wikipedia)_blah#cite-1"
"http://foo.com/unicode_(✪)_in_parens"
"http://foo.com/(something)?after=parens"
"http://☺.damowmow.com/"
"http://code.google.com/events/#&product=browser"
"http://j.mp"
"ftp://foo.bar/baz"
"http://foo.bar/?q=Test%20URL-encoded%20stuff"
"http://مثال.إختبار"
"http://例子.测试"
"http://उदाहरण.परीक्षा"
"http://-.~_!$&'()*+,;=:%40:80%2f::::::@example.com"
"http://1337.net"
"http://a.b-c.de"
"http://223.255.255.254"
"ftp://ftp.is.co.za/rfc/rfc1808.txt"
"http://www.ietf.org/rfc/rfc2396.txt"
"ldap://[2001:db8::7]/c=GB?objectClass?one"
"telnet://192.0.2.16:80/"
)


for i in "${VALID_URLS[@]}"; do
   parseURL $i
   echo -e "$i -> \
${URL_SCHEME:+"Scheme "\033[32m"$URL_SCHEME "}\033[0m\
${URL_AUTHORITY:+"Authority "\033[32m"$URL_AUTHORITY "}\033[0m\
${URL_USERINFO:+"Userinfo "\033[32m"$URL_USERINFO "}\033[0m\
${URL_USERNAME:+"Username "\033[32m"$URL_USERNAME "}\033[0m\
${URL_PASSWORD:+"Password "\033[32m"$URL_PASSWORD "}\033[0m\
${URL_HOST:+"Host "\033[32m"$URL_HOST "}\033[0m\
${URL_PORT:+"Port "\033[32m"$URL_PORT "}\033[0m\
${URL_PATH:+"Path "\033[32m"$URL_PATH "}\033[0m\
${URL_QUERY:+"Query "\033[32m"$URL_QUERY "}\033[0m\
${URL_FRAGMENT:+"Fragment "\033[32m"$URL_FRAGMENT "}\033[0m\
"
#, Authority: ${}${USERNAME}:${PASSWORD}@${HOST}:${PORT}"
done
