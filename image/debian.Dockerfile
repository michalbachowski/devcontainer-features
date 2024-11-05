FROM debian:bookworm-20241016-slim

#
# add test user
#
RUN \
    useradd -ms /bin/bash testuser

#
# install missing packages
#
COPY \
    ensure_nanolayer.sh \
    envcert.pem \
    optcert.pem \
    /

RUN \
    set +u; \
    . /ensure_nanolayer.sh && \
    ensure_nanolayer nanolayer_location "v0.5.6" && \
    $nanolayer_location \
        install \
        apt "curl git zsh"

#
# specify fake cert
#
ENV \
    SSL_CERT_FILE=/envcert.pem

#
# init test git dir
#
RUN \
    mkdir -p /devcontainer-feature/michalbachowski/test-git-repo && \
    git init .
