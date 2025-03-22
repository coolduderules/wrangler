<!-- vale off -->
# Wrangler
<!-- vale on -->

[![Software License](https://img.shields.io/badge/license-MIT-informational.svg?style=for-the-badge)](LICENSE)
[![Pipeline Status](https://img.shields.io/gitlab/pipeline-status/op_so/docker/wrangler?style=for-the-badge)](https://gitlab.com/op_so/docker/wrangler/pipelines)

A [Node.js](https://nodejs.org/) Docker image with Cloudflare [`Wrangler`](https://developers.cloudflare.com/workers/wrangler/):

* **lightweight** image based on a debian-slim,
* `multiarch` with support of **amd64** and **arm64**,
* **automatically** updated by comparing software bill of materials (`SBOM`) changes,
* image **signed** with [Cosign](https://github.com/sigstore/cosign),
* a **software bill of materials (`SBOM`) attestation** added using [`Syft`](https://github.com/anchore/syft),
* available on **Docker Hub** and **Quay.io**.

[![GitLab](https://shields.io/badge/Gitlab-554488?logo=gitlab&style=for-the-badge)](https://gitlab.com/op_so/docker/wrangler) The main repository.

[![Docker Hub](https://shields.io/badge/dockerhub-1D63ED?logo=docker&logoColor=white&style=for-the-badge)](https://hub.docker.com/r/jfxs/wrangler) The Docker Hub registry.

[![Quay.io](https://shields.io/badge/quay.io-E5141F?logo=docker&logoColor=white&style=for-the-badge)](https://quay.io/repository/ifxs/wrangler) The Quay.io registry.

<!-- vale off -->
## Running Wrangler in local
<!-- vale on -->

```shell
docker run -t --rm -v $(pwd):/data jfxs/wrangler /bin/sh -c "export WRANGLER_SEND_METRICS=false && export CLOUDFLARE_ACCOUNT_ID=<account_id> && export CLOUDFLARE_API_TOKEN=<api_token> && npx wrangler pages deploy /data/public --project-name my-project"
```

<!-- vale off -->
## Running Wrangler in Gitlab-CI
<!-- vale on -->

Example of usage with Gitlab-CI:

| CI/CD Protected/Masked Variables | Description           | Type     |
| -------------------------------- | --------------------- | -------- |
| `CLOUDFLARE_ACCOUNT_ID`          | Cloudflare account ID | Variable |
| `CLOUDFLARE_API_TOKEN`           | Cloudflare API token  | Variable |

```yaml
 ...
cloudflare-publish:
  image: jfxs/wrangler:latest
  stage: publish
  variables:
    WRANGLER_SEND_METRICS: "false"
  script:
    - if [ -z "$CLOUDFLARE_ACCOUNT_ID"]; then echo "CLOUDFLARE_ACCOUNT_ID is empty!" && exit 1; fi
    - if [ -z "$CLOUDFLARE_API_TOKEN"]; then echo "CLOUDFLARE_API_TOKEN is empty!" && exit 1; fi
    - npx wrangler pages deploy /data/public --project-name my-project
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
```

## Built with

Docker latest tag is [--VERSION--](https://gitlab.com/op_so/docker/wrangler/-/blob/main/Dockerfile) and has:

<!-- vale off -->
--SBOM-TABLE--
<!-- vale on -->

[`Dockerhub` Overview page](https://hub.docker.com/r/jfxs/wrangler) has the details of the last published image.

## Versioning

Docker tag definition:

* the Wrangler version used,
* a dash
* an increment to differentiate build with the same version starting at 001

```text
<wrangler_version>-<increment>
```

<!-- vale off -->
Example: 3.51.2-001
<!-- vale on -->

## Signature and attestation

[Cosign](https://github.com/sigstore/cosign) public key:

```shell
-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEa3yV6+yd/l4zh/tfT6Tx+zn0dhy3
BhFqSad1norLeKSCN2MILv4fZ9GA6ODOlJOw+7vzUvzZVr9IXnxEdjoWJw==
-----END PUBLIC KEY-----
```

The public key is also available online: <https://gitlab.com/op_so/docker/cosign-public-key/-/raw/main/cosign.pub>.

To verify an image:

```shell
cosign verify --key cosign.pub $IMAGE_URI
```

To verify and get the software bill of materials (`SBOM`) attestation:

```shell
cosign verify-attestation --key cosign.pub --type spdxjson $IMAGE_URI | jq '.payload | @base64d | fromjson | .predicate'
```

## Authors

<!-- vale off -->
* **FX Soubirou** - *Initial work* - [GitLab repositories](https://gitlab.com/op_so)
<!-- vale on -->

## License

<!-- vale off -->
This program is free software: you can redistribute it and/or modify it under the terms of the MIT License (MIT). See the [LICENSE](https://opensource.org/licenses/MIT) for details.
<!-- vale on -->
