# ac-library-mojo-test



# 開発者向け情報

本当は GitHub Actions を設定して自動テストが出来るようにしたかったのですが、うまくできていないので各自でテストしてください。

## ファイル構成

### mojoproject.toml

```
[project]
channels = ["conda-forge", "https://conda.modular.com/max", "https://repo.prefix.dev/modular-community"]
name = "mojo"
platforms = ["linux-64"]

[dependencies]
max = "=25.1.0"

```

### .verify-helper/config.toml

```
[languages.mojo]
compile = "magic run mojo build -o a.out {path} -I {basedir}"
execute = "./a.out"
bundle = "false"
list_dependencies = "python list_dependencies.py {path}"
verification_file_suffix = ".test.mojo"

```

## magicのインストール

https://docs.modular.com/magic/

に従ってください。

```
curl -ssL https://magic.modular.com/{なにか}
```

を実行するだけのはずです。

これを実行すると `$HOME/.bash_profile` か `$HOME/.bashrc` に PATH の設定が書き込まれるはずなので、シェルを起動し直すと `magic` が使えると思います。

## Mojoのインストール

`mojoproject.toml` のあるディレクトリで

```
magic install
```

を実行するだけです。

## テスト

https://github.com/online-judge-tools/verification-helper/blob/master/README.ja.md

これに従ってください。

```
oj-verify run
```

で実行出来ます。

## vscodeの拡張の設定

VSCode には Mojo の公式拡張があるのでそれを使うとよいです。

```
"mojo.lsp.includeDirs": [
    "なにか設定"
]
```

これを設定しておくと幸せになるかもしれません

## 整備状況

| file                 | 備考                                           | 
| -------------------- | ---------------------------------------------- | 
| dsu                  | 完了                                           | 
| fenwicktree          | 完了                                           | 
| internal_bit         | 完了（改良の余地はあるかも）                   | 
| internal_csr         | 未着手                                         | 
| internal_math        | 途中                                           | 
| internal_queue       | 必要かは不明（要検証）                         | 
| internal_scc         | 未着手                                         | 
| internal_type_traits | 目的を変えて整備（別のファイルに移行するかも） | 
| io                   | 独自作成（改良の余地あり）                     | 
| lazysegtree          | 完了（テンプレをある程度提供したい）           | 
| math                 | 途中                                           | 
| maxflow              | min_cutがまだ                                  | 
| mincostflow          | 未着手                                         | 
| modint               | 完成（改良の余地はあるかも）                   | 
| scc                  | 未着手                                         | 
| segtree              | 完了（テンプレをある程度提供したい）           | 
| string               | 途中                                           | 
| twosat               | 未着手                                         | 
