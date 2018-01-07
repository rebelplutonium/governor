#!/bin/sh

GOVERNOR_SECRETS_VERSION=0.0.4 &&
    TEMP=$(mktemp -d) &&
    echo "${GPG_SECRET_KEY}" > ${TEMP}/gpg_secret_key &&
    gpg --batch --import ${TEMP}/gpg_secret_key &&
    echo "${GPG_OWNER_TRUST}" > ${TEMP}/gpg_owner_trust &&
    gpg --batch --import-ownertrust ${TEMP}/gpg_owner_trust &&
    rm -rf ${TEMP} &&
    pass init ${GPG_KEY_ID} &&
    pass git init &&
    pass git config user.name "${USER_NAME}" &&
    pass git config user.email "${USER_EMAIL}" &&
    pass git remote add origin https://${GOVERNOR_SECRETS_HOST_NAME}:${GOVERNOR_SECRETS_HTTPS_HOST_PORT}/${GOVERNOR_SECRETS_ORIGIN_ORGANIZATION}/${GOVERNOR_SECRETS_ORIGIN_REPOSITORY}.git &&
    if [ -z "${USE_VERSIONED_GOVERNOR_SECRETS}" ]
    then
        pass git fetch origin master &&
            pass git checkout origin/master
    else
        pass git fetch --tags origin ${GOVERNOR_SECRETS_VERSION} &&
            pass git checkout origin/${GOVERNOR_SECRETS_VERSION}
    fi &&
    ln -sf /usr/local/bin ${HOME}/.password-store/.git/hooks/pre-commit &&
    sed -e "s#\${EXTERNAL_NETWORK_NAME}#${EXTERNAL_NETWORK_NAME}#" -e "w/opt/docker/workspace/docker-compose.yml" /opt/docker/extension/docker-compose.yml &&
    if [ "cqT1SgUR" != "$(pass show alpha)" ]
    then
        echo failed pass sanity check &&
            exit 64
    fi &&
    export EXPIRY="${EXPIRY}" &&
    export UPSTREAM_ID_RSA="$(pass show upstream_id_rsa)" &&
    export ORIGIN_ID_RSA="$(pass show origin_id_rsa)" &&
    export REPORT_ID_RSA="$(pass show report_id_rsa)" &&
    export AWS_ACCESS_KEY_ID="$(pass show aws-access-key-id)" &&
    export AWS_SECRET_ACCESS_KEY="$(pass show aws-secret-access-key)" &&
    export AWS_DEFAULT_REGION="$(pass show aws-default-region)" &&
    export GPG_SECRET_KEY="${GPG_SECRET_KEY}" &&
    export GPG2_SECRET_KEY="${GPG2_SECRET_KEY}" &&
    export GPG_OWNER_TRUST="${GPG_OWNER_TRUST}" &&
    export GPG2_OWNER_TRUST="${GPG2_OWNER_TRUST}" &&
    export GPG_KEY_ID="${GPG_KEY_ID}" &&
    cd /opt/docker/workspace &&
    docker-compose up -d


