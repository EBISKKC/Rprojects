# Rプロジェクト

このフォルダにはRのプロジェクトを配置できます。

## Rの起動方法
コンソールで
```bash
R
```
と打てば起動できる。

## RMarkdownのPDF出力

Rコンソール上で以下のコマンドを実行することで、`test.Rmd`ファイルをPDFとして出力できます。

```R
rmarkdown::render("test.Rmd")
```

また、ターミナルから以下のコマンドを実行することで、一発でPDFを出力することも可能です。

```bash
Rscript -e 'rmarkdown::render("test.Rmd")'
```

これでrのコードを動かすことができる。
```bash
Rscript test.r
```

作業するディレクトリをこのディレクトリの中で作ってファイルを管理していきましょう。