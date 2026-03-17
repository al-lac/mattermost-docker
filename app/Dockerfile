FROM alpine:3.22.2

# Some ENV variables
ENV PATH="/mattermost/bin:${PATH}"
ENV MM_INSTALL_TYPE=docker

# Build argument to set Mattermost edition
ARG PUID=1000
ARG PGID=1000
ARG MM_LISTEN_PORT=8000
ARG TARGETOS
ARG TARGETARCH
ARG MM_VERSION

# Install some needed packages
RUN apk add --no-cache \
	ca-certificates \
	curl \
	jq \
	libc6-compat \
	libffi-dev \
	libcap \
	linux-headers \
	mailcap \
	netcat-openbsd \
	xmlsec-dev \
	tzdata \
	su-exec \
	&& rm -rf /tmp/*

# Get Mattermost
RUN mkdir -p /mattermost/data /mattermost/plugins /mattermost/client/plugins \
        && MM_ARTIFACT="mattermost-${MM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz" \
        && MM_URL="https://github.com/al-lac/mattermost-docker/releases/download/${MM_VERSION}/${MM_ARTIFACT}" \
        && curl --fail --show-error --location --retry 12 --retry-all-errors --retry-delay 5 --output "/tmp/${MM_ARTIFACT}" "${MM_URL}" \
        && tar -C /mattermost --strip-components=1 -xvzf "/tmp/${MM_ARTIFACT}" \
        && rm -f "/tmp/${MM_ARTIFACT}" \
        && cp /mattermost/config/config.json /mattermost/config.json.save \
        && rm -rf /mattermost/config/config.json \
        && addgroup -g ${PGID} mattermost \
        && adduser -D -u ${PUID} -G mattermost -h /mattermost mattermost \
        && chown -R mattermost:mattermost /mattermost/config.json.save /mattermost/plugins /mattermost/client/plugins \
        && setcap cap_net_bind_service=+ep /mattermost/bin/mattermost

# Configure entrypoint and command
COPY priv-entrypoint.sh /
COPY entrypoint.sh /
ENTRYPOINT ["/priv-entrypoint.sh"]

WORKDIR /mattermost
CMD ["mattermost"]

# Expose port 8000 of the container
EXPOSE $MM_LISTEN_PORT

# Declare volumes for mount point directories
VOLUME ["/mattermost/data", "/mattermost/logs", "/mattermost/config", "/mattermost/plugins", "/mattermost/client/plugins"]
