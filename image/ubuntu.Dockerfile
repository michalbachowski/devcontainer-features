FROM eclipse-temurin:23.0.1_11-jre-noble

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

COPY \
    pip.conf /etc/pip.conf

#
# install missing packages
#
RUN \
    set +u; \
    . /ensure_nanolayer.sh && \
    ensure_nanolayer nanolayer_location "v0.5.6" && \
    $nanolayer_location \
        install \
        apt-get "curl git zsh"
