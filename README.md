# asdf-helmfile

[![CI](https://github.com/feniix/asdf-helmfile/actions/workflows/ci.yml/badge.svg)](https://github.com/feniix/asdf-helmfile/actions/workflows/ci.yml)

[Helmfile](https://github.com/helmfile/helmfile) plugin for the
[asdf](https://asdf-vm.com/) version manager.

## Install

```bash
asdf plugin add helmfile https://github.com/feniix/asdf-helmfile.git
```

## Use

```bash
asdf list all helmfile
asdf install helmfile latest
asdf set -u helmfile latest
helmfile --version
```

See the [asdf documentation](https://asdf-vm.com/manage/versions.html) for
version-management commands.

## Supported platforms

CI exercises the plugin on current Ubuntu and macOS runners. Helmfile release
availability determines the supported operating-system and CPU combinations.

## License

MIT. See [LICENSE](LICENSE).
