FROM pipelinecomponents/base-entrypoint:0.5.0 as entrypoint

FROM node:16.13.1-alpine
COPY --from=entrypoint /entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
ENV DEFAULTCMD eslint

WORKDIR /app/

# Generic
#RUN apk add --no-cache
COPY app /app/

# Node
ENV PATH "$PATH:/app/node_modules/.bin/"
RUN yarn install --frozen-lockfile && yarn cache clean
ENV NODE_PATH=/app/node_modules/

WORKDIR /code/

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF

# Labels
LABEL \
    maintainer="Robbert Müller <dev@pipeline-components.dev>" \
    org.label-schema.description="Eslint in a container for gitlab-ci" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Eslint" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://pipeline-components.gitlab.io/" \
    org.label-schema.usage="https://gitlab.com/pipeline-components/eslint/blob/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://gitlab.com/pipeline-components/eslint/" \
    org.label-schema.vendor="Pipeline Components"
