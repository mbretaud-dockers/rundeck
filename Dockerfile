FROM openjdk:8u121-jdk-alpine

# https://github.com/xataz/docker-rundeck/blob/master/Dockerfile

# Install packages
RUN BUILD_DEPS="wget" && apk add -U openjdk8-jre libressl ca-certificates openssh-client su-exec tini ${BUILD_DEPS}

# Arguments
ARG HTTP_PORT=4440
ARG RUNDECK_VER=2.9.4
ARG ADMIN_PASSWORD=""
ARG USER_NAME="user"
ARG USER_PASSWORD=""

# Environment variables
ENV HTTP_PORT=${HTTP_PORT}
ENV URI_ACCESS="http://localhost:${HTTP_PORT}"
ENV ADMIN_PASSWORD=${ADMIN_PASSWORD}
ENV USER_NAME=${USER_NAME}
ENV USER_PASSWORD=${USER_PASSWORD}
ENV UID=991
ENV GID=991
ENV RDECK_BASE=/opt/rundeck
ENV RDECK_JAR=${RDECK_BASE}/bin/rundeck.jar

# Copy jar
RUN mkdir -p ${RDECK_BASE}/bin
COPY rundeck-jars/rundeck-launcher-${RUNDECK_VER}.jar ${RDECK_JAR}
RUN apk del ${BUILD_DEPS}
RUN rm -rf /tmp/* /var/cache/apk/*

# Expose port
EXPOSE ${HTTP_PORT}

ADD rundeck.defaults ${RDECK_BASE}/rundeck.defaults
ADD rootfs /
RUN chmod +x /usr/local/bin/startup

# Volume
RUN mkdir -p ${RDECK_BASE}
RUN mkdir -p ${RDECK_BASE}/etc
RUN mkdir -p ${RDECK_BASE}/projects
VOLUME ${RDECK_BASE}/etc
VOLUME ${RDECK_BASE}/projects

# Entrypoint
ENTRYPOINT ["/usr/local/bin/startup"]

# Command
CMD ["java", "-jar", "/opt/rundeck/bin/rundeck.jar", "-b", "/opt/rundeck"]