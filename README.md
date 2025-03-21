# ac-library-mojo-test
```
a.out
.verify-helper
mojoproject.toml
```
# ファイル構成
## mojoproject.toml
```
[project]
channels = ["conda-forge", "https://conda.modular.com/max", "https://repo.prefix.dev/modular-community"]
name = "mojo"
platforms = ["linux-64"]

[dependencies]
max = "=25.1.0"
```
## .verify-helper
