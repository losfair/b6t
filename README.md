# b6t

Minimal containerized [Blueboat](https://github.com/losfair/blueboat) suitable for self-hosting.

## Usage

```bash
docker run -d -p 127.0.0.1:3000:3000 --name b6t -v "$PWD/b6t-data:/data" ghcr.io/losfair/b6t:latest

# Deploy a hello world app
mkdir -p ./b6t-data/minio/apps/hello
echo 'Router.get("/", () => new Response("Hello from b6t"))' > ./index.js
tar -cvf ./b6t-data/minio/apps/hello/1.tar ./index.js
echo '{"version":"1","package":"hello/1.tar","env":{}}' > ./b6t-data/minio/apps/hello/metadata.json

# Curl it!
curl -H "X-Blueboat-Metadata: hello/metadata.json" http://localhost:3000
```

## Caveats

`b6t` is specialized for deploying Blueboat on a single-machine and being used as a base image for packaging Blueboat
apps into a standalone Docker image, so the configuration is tweaked for this use case:

- The FoundationDB instance is configured in `single` mode.
- Features that depend on Kafka (at-least-once background tasks, logging-to-kafka) are not enabled because Kafka's memory footprint is too high.

## License

`b6t` itself is licensed under MIT, and all Blueboat *binaries* included in the b6t Docker image are available under the same license:

- `blueboat-server`
- `blueboat-mds`

The Docker image also contains various third-party software, which is licensed under the terms of the respective licenses:

- `minio` (AGPL-3.0)
- `foundationdb` (Apache-2.0)
