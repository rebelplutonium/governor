#!/bin/bash

export EXTERNAL_NETWORK_NAME=$(uuidgen) &&
    export EXPIRY=$(($(date +%s)+60*60*24*7)) &&
    sudo docker network create --label expiry=${EXPIRY} ${EXTERNAL_NETWORK_NAME} &&
    cleanup(){
        sudo docker network rm ${EXTERNAL_NETWORK_NAME}
    } &&
    trap cleanup EXIT &&
    sudo \
        docker \
        container \
        run \
        --interactive \
        --tty \
        --rm \
        --name governor \
        --network ${EXTERNAL_NETWORK_NAME} \
        --env EXTERNAL_NETWORK_NAME=${EXTERNAL_NETWORK_NAME} \
        --env PROJECT_NAME=governor \
        --env CLOUD9_PORT=16842 \
        --env USER_NAME="Emory Merryman" \
        --env USER_EMAIL=emory.merryman@gmail.com \
        --env SECRETS_HOST_NAME=github.com \
        --env SECRETS_HOST_PORT=443 \
        --env SECRETS_ORIGIN_ORGANIZATION=nextmoose \
        --env SECRETS_ORIGIN_REPOSITORY=secrets \
        --env GPG_KEY_ID=D65D3F8C \
        --env GPG_SECRET_KEY="$(cat private/gpg_secret_key)" \
        --env GPG2_SECRET_KEY="$(cat private/gpg2_secret_key)" \
        --env GPG_OWNER_TRUST="$(cat private/gpg_owner_trust)" \
        --env GPG2_OWNER_TRUST="$(cat private/gpg2_owner_trust)" \
        --env EXPIRY=${EXPIRY} \
        --label expiry=${EXPIRY} \
        --env DISPLAY \
        --mount type=bind,source=/var/run/docker.sock,destination=/var/run/docker.sock,readonly=true \
        rebelplutonium/governor:0.0.0