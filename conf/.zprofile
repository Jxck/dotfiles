export http_proxy="http://{{user}}:{{pass}}@{{host}}:{{port}}"
export https_proxy="http://{{user}}:{{pass}}@{{host}}:{{port}}"
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$https_proxy
export all_proxy=$http_proxy
export ALL_PROXY=$http_proxy
export no_proxy="localhost,127.0.0.1,/var/run/docker.sock"
export NO_PROXY=$no_proxy

export SOCKS5_USER="{{user}}"
export SOCKS5_PASSWD="{{pass}}"
