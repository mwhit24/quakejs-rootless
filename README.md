<div align="center">
 
# QuakeJS Rootless Project

## Play multiplayer Quake III Arena in your browser with Podman / Docker

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-awakenedpower%2Fquakejs--rootless-blue?style=for-the-badge&logo=docker)](https://hub.docker.com/r/awakenedpower/quakejs-rootless)

## Demo

Try it live: **[gibs.oldschoolfrag.com](https://gibs.oldschoolfrag.com/)**

</div>

## About

This project is a fully local QuakeJS server fork based on @treyyoder's original repository. The primary goal of this fork is to deliver a modern, lightweight, and secure alternative. 
To achieve this, the original game code was refactored to support modern npm packages, resulting in a meaningful reduction of critical and high-severity vulnerabilities.

| Component | This Fork |
|-----------|-----------|
| Base OS | **Debian 13 Docker Hardened Image** |
| Node.js | **22.x LTS** |
| Web Server | **Nginx Light** |
| Networking | **Single Port Multiplexed via Nginx** |
| Container User | **non-root** |
| npm packages | **Modernized, with compatibility fixes** |

### Out of Scope
- Recompile original game code from ioquake3 (still old game code)
- Introduce new functionality

## Quick Start

### Using Podman (Recommended)

```bash
podman run -d \
  --name quakejs \
  -p 8080:8080 \
  docker.io/awakenedpower/quakejs-rootless:latest
```

### Using Docker Run

```bash
docker run -d \
  --name quakejs \
  -p 8080:8080 \
  docker.io/awakenedpower/quakejs-rootless:latest
```

Then open your browser and navigate to `http://localhost:8080` to start playing!

### Using Docker Compose

Create a `docker-compose.yml` file:

```yaml
services:
  quakejs:
    container_name: quakejs
    image: awakenedpower/quakejs-rootless:latest
    ports:
      - '8080:8080'
    restart: unless-stopped
```

Then run:

```bash
docker-compose up -d
```

### Using Kubernetes with Helm

This repository includes a Helm chart in `.helm/`. The CI workflow builds and pushes a `linux/amd64` image, then packages the chart as an OCI artifact with the image pinned as `tag@sha256:<digest>`.

Local install:

```bash
helm install quake .helm \
  --namespace quakejs \
  --create-namespace
```

Install from the published OCI Helm chart:

```bash
helm install quake oci://ghcr.io/jackbrenn/quakejs-rootless/helm/quake \
  --namespace quakejs \
  --create-namespace
```

<details>
<summary>ArgoCD Application example</summary>

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: quake
  namespace: argocd
spec:
  project: default
  source:
    repoURL: oci://ghcr.io/jackbrenn/quakejs-rootless/helm
    chart: quake
    targetRevision: 0.1.0
    helm:
      values: |
        ingress:
          enabled: true
          className: ""
          hosts:
            - host: quake.example.com
              tls: false
  destination:
    server: https://kubernetes.default.svc
    namespace: quakejs
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

</details>

Important values:

```yaml
image:
  repository: docker.io/awakenedpower/quakejs-rootless
  tag: latest

ingress:
  enabled: false
  className: ""
  hosts:
    - host: quake.example.com
      tls: false

quake:
  fsGame: baseq3
```

For ArgoCD, consume the published OCI Helm chart and override values there rather than editing rendered manifests.

## Building from Source

### Building with Podman (Recommended)
You must login to dhi.io (Free with a Dockerhub user) to download the hardened images.

1. **Clone the repository:**
```bash
git clone https://github.com/JackBrenn/quakejs-rootless.git
cd quakejs-rootless
```

2. **Build the image:**

```bash
podman login dhi.io
podman build -t quakejs-rootless:latest .
```

3. **Run the container:**
```bash
podman run -d \
  --name quakejs \
  -p 8080:8080 \
  quakejs-rootless:latest
```

### Building with Docker

1. **Clone the repository:**
```bash
git clone https://github.com/JackBrenn/quakejs-rootless.git
cd quakejs-rootless
```
2. **Build the image:**
```bash
docker login dhi.io
docker build -t quakejs-rootless:latest .
```

3. **Run the container:**
```bash
docker run -d \
  --name quakejs \
  -p 8080:8080 \
  quakejs-rootless:latest
```

## Configuration

### Server Configuration

The server configuration can be customized by modifying `server.cfg`.

### Ports

- **8080** - Multiplexed Web interface and Game server port. Web requests are handled by Nginx directly, while WebSocket game traffic is seamlessly forwarded internally. This makes proxying behind SSL natively supported via a single port.

## Credits & Acknowledgments
This wouldn't be possible without these projects or contributors:
- **[@jonasbg](https://github.com/jonasbg)** - Hardened Kubernetes Helm chart and OCI publishing workflow
- **[@treyyoder](https://github.com/treyyoder)** - Original [quakejs-docker](https://github.com/treyyoder/quakejs-docker) implementation that made fully local QuakeJS servers possible
- **[@nerosketch](https://github.com/nerosketch)** - [QuakeJS fork](https://github.com/nerosketch/quakejs.git) with local server capabilities
- **[@inolen](https://github.com/inolen)** - Original [QuakeJS](https://github.com/inolen/quakejs) project
- **[@mescanne](https://github.com/mescanne)** - Single-port multiplexing concept via Nginx WebSocket routing

## License

MIT
