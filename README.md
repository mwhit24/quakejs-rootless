

<div align="center">
  
For a more advanced and modern setup consider **[lklacar/q3js](https://github.com/lklacar/q3js)** - it's a modern and feature-rich implementation.

**For simplicity:** This project provides a **single-container solution** that's perfect for smaller setups.

---
  
# QuakeJS Rootless Project

## Play multiplayer Quake III Arena in your browser with Podman / Docker

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-awakenedpower%2Fquakejs--rootless-blue?style=for-the-badge&logo=docker)](https://hub.docker.com/r/awakenedpower/quakejs-rootless)

A fully self-contained, Dockerized QuakeJS server running on Debian 13 and Node.js 22.x LTS

## Demo

Try it live: **[gibs.oldschoolfrag.com](https://gibs.oldschoolfrag.com/)**

</div>

## About

This project provides a completely local QuakeJS server that runs entirely in Docker. No external dependencies, no content servers, no proxies - just pure Quake III Arena gaming in your browser.

The primary goal is to repackage the work done by @treyyoder into a modern, lightweight, and secure container.

**Key improvements in this fork:**
- Modern base: Docker Hardened Image (Debian 13), Node.js 22.x LTS, Nginx-light
- Security: Significant CVE reduction, goal of zero High or Critical CVEs, runs as non-root
- Updated NPM packages where possible
- Multiplexed web and game traffic over a single port
- Small image size (~280MB)

**What this fork has not done (so far):**
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
    # To use the pre-built image:
    image: awakenedpower/quakejs-rootless:latest
    ports:
      - '8080:8080'
    restart: unless-stopped
```

Then run:

```bash
docker-compose up -d
```

## Building from Source

### Building with Podman (Recommended)

1. **Clone the repository:**
```bash
git clone https://github.com/JackBrenn/quakejs-rootless.git
cd quakejs-rootless
```

2. **Build the image:**
```bash
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

## What's Different?

This fork builds upon the excellent work of [@treyyoder/quakejs-docker](https://github.com/treyyoder/quakejs-docker) with the following updates:

| Component | Original | This Fork |
|-----------|----------|-----------|
| Base OS | Ubuntu 20.04 | **Debian 13 Docker Hardened Image** |
| Node.js | 14.x | **22.x LTS** |
| Web Server | Apache 2 | **Nginx Light** |
| Networking | Dual Port | **Single Port Multiplexed via Nginx** |
| CVEs | 5 critical, 14 high, 999+ medium | **0 critical, 0 high, 2 medium, 15 low** |
| Container User | root | **non-root** |
> *CVE counts as of 04.04.2026 — will vary over time as vulnerabilities are discovered and patched. Results provided by Docker Scout.*

## 🙏 Credits & Acknowledgments
This wouldn't be possible without these projects or contributors:
- **[@treyyoder](https://github.com/treyyoder)** - Original [quakejs-docker](https://github.com/treyyoder/quakejs-docker) implementation that made fully local QuakeJS servers possible
- **[@nerosketch](https://github.com/nerosketch)** - [QuakeJS fork](https://github.com/nerosketch/quakejs.git) with local server capabilities
- **[@inolen](https://github.com/inolen)** - Original [QuakeJS](https://github.com/inolen/quakejs) project
- **[@mescanne](https://github.com/mescanne)** - Single-port multiplexing concept via Nginx WebSocket routing

## License

MIT

---

<div align="center">

*For best security: Rootless container + Podman + Nginx + firewall + regular updates*

</div>
