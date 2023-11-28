# Setup Platform Action

GitHub Action to install and configure our [PlatformCLI][platform] and
[Stackctl][] tools.

[platform]: https://github.com/freckle/platform
[stackctl]: https://github.com/freckle/stackctl

**NOTE**: This action is public so that we can use it outside of its own
repository, but the tooling it installs and uses is private. It is of no use
outside Freckle.

## Usage

```yaml
- id: setup
  uses: freckle/setup-platform-action@v7
  with:
    # Required
    token: ${{ secrets.X }}

    # Optional
    # version: 3.2.2.0
    # app-directory: my-app     # If in multi-app repository
    # environment: prod
    # resource: my-resource     # If in multi-resource app
    # stackctl-version: 1.6.0.0
```

The action installs a `platform` executable, configures `PLATFORM_*` environment
variables (so you can just invoke it without global options throughout the
remainder of your workflow), and sets the `tag` output.

This can be used to build and push images,

```yaml
- run: platform container:login
- run: platform container:push --tag '${{ steps.setup.outputs.tag }}'
```

Build and push assets,

```yaml
- run: platform assets:push --tag '${{ steps.setup.outputs.tag }}'
```

Or deploy

```yaml
- run: platform deploy --tag '${{ steps.setup.outputs.tag }}'
```

We also export various `SLACK_*` environment variables, so you don't have to set
as much when notifying via the `rtCamp` action:

```yaml
- if: ${{ always() }}
  uses: rtCamp/action-slack-notify@v2
  env:
    # Only this is now required
    SLACK_WEBHOOK: ${{ secrets.SLACK_WEBHOOK_URL }}

    # But you probably want this too
    SLACK_COLOR: ${{ job.status }}
    SLACK_MESSAGE: ${{ job.status }}
```

## Stackctl

The action also installs a `stackctl` executable and configures `STACKCTL_*`
variables to work with the specifications generated by PlatformCLI. This means
you can do things like post changeset details to your PR:

```yaml
- run: |
    # Generates content in .platform/specs
    platform deploy --tag '${{ steps.prep.outputs.tag }}' --inspect

    # Which you can work with naturally using Stackctl
    stackctl changes --format pr /tmp/changes.md

- uses: { your preferred add-pr-comment action }
  with:
    body-path: /tmp/changes.md
```

## Inputs

- **token**: a GitHub access token with rights to fetch the private PlatformCLI
  release artifacts. There is an Organization-level secret for `freckle`
  repositories.

- **version**: the version of PlatformCLI to install. Do not include the `v`
  prefix here. The default will change over time, and is meant to be the latest
  stable version. We recommend using this default, along with specifying a
  `required_version` constraint (such as `=~ 3`) in your `.platform.yaml`.

- **app-directory**: if present, this will be set as `PLATFORM_APP_DIRECTORY`
  for the remainder of the workflow. For details on what this affects, see
  `platform(1)`.

- **environment**: if present, this will be set as `PLATFORM_ENVIRONMENT` for
  the remainder of the workflow. For details on what this affects, see
  `platform(1)`.

- **resource**: if present, this will be set as `PLATFORM_RESOURCE` for the
  remainder of the workflow. For details on what this affects, see
  `platform(1)`.

- **no-validate**: if present, this will be set as `PLATFORM_NO_VALIDATE` for
  the remainder of the workflow. For details on what this affects, see
  `platform(1)`.

- **stackctl-version**: the version of Stackctl to install. Do not include the
  `v` prefix here. The default will change over time, and is meant to be kept up
  with latest as best we can.

**NOTE**: depending on the version of PlatformCLI you install, not all
environment-variable-based configurations may be supported. Please refer to the
documentation for the version you're using.

## Outputs

- **tag**: a consistent, source-specific value that should be used throughout
  build/push/deploy actions. It's currently the head sha for `pull_request`
  events, the "after" sha `push` events, and `github.sha` for all other events

- **cache**: path to the `.platform/cache` directory, for which we've setup an
  `actions/cache` step. This output is only useful if in a multi-app repository.

---

[LICENSE](./LICENSE)
