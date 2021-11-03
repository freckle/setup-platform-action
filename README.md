# Setup Platform Action

GitHub Action to install the [Freckle Platform CLI][platform].

[platform]: https://github.com/freckle/platform

**NOTE**: This action is public so that we can use it outside of its own
repository, but the tooling it installs and uses is private. It is of no use
outside Freckle.

## Usage

```yaml
jobs:
  image:
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      AWS_DEFAULT_REGION: us-east-1
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: freckle/setup-platform-action@main
      - run: platform container:login
      - run: platform container:push --tag ${{ github.sha }}
```

## Environment

- `AWS_*`: AWS configuration for the target account

## Inputs

- `version`: the version of Platform CLI to install.

  See its [releases][] for available versions. Defaults to `latest`.

  [releases]: https://github.com/freckle/platform/releases

- `suffix`: artifact suffix to use

  Must be `x86_64-linux` or `x86_64-osx`. Defaults to `x86_64-linux`.

---

[LICENSE](./LICENSE)
