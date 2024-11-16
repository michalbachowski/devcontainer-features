FROM bitnami/java:1.8-debian-12

#
# add test user
#
RUN \
    useradd -ms /bin/bash testuser

#
# copy files
#
COPY \
    ensure_nanolayer.sh \
    /

COPY \
    test-cert.pem \
    /usr/local/share/ca-certificates/custom-ca-cert.crt

#
# install missing packages
#
RUN install_packages curl git zsh
