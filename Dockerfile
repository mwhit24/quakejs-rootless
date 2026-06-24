# Railway-friendly build.
#
# The upstream Dockerfile (kept as Dockerfile.upstream) builds from
# dhi.io/debian-base — a Docker Hardened Image that requires a paid Docker
# subscription, so Railway's builder gets 401 Unauthorized and can't build it.
#
# Instead we start FROM the already-built image the maintainer published to
# GHCR (public, no auth) and just layer our server.cfg on top.
FROM ghcr.io/jackbrenn/quakejs-rootless:latest

# Image runs as nonroot (UID 65532); keep the cfg owned by that user.
COPY --chown=65532:65532 server.cfg /quakejs/base/baseq3/server.cfg
COPY --chown=65532:65532 server.cfg /quakejs/base/cpma/server.cfg

EXPOSE 8080
