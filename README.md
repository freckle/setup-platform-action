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
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: freckle/setup-platform-action@v5
        with:
          token: ${{ secrets.X }}
      - run: platform container:login
      - run: platform container:push --tag ${{ github.sha }}
```

## Inputs

- `version`: the version of Platform CLI to install.

  See its [releases][] for available versions. Defaults to `latest`.

  [releases]: https://github.com/freckle/platform/releases

- `token`: a GitHub token with access to download artifacts from the private
  `freckle/platform` repository.

---

[LICENSE](./LICENSE)
