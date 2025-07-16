# .rdsファイル内容確認ツール

library(utils)
library(tools)

# .rdsファイルの詳細情報を表示する関数
inspect_rds <- function(file_path) {
  if (!file.exists(file_path)) {
    cat("エラー: ファイルが見つかりません:", file_path, "\n")
    return(NULL)
  }

  cat("=== RDSファイル情報 ===\n")
  cat("ファイルパス:", file_path, "\n")
  cat("ファイルサイズ:", round(file.size(file_path) / 1024, 2), "KB\n")
  cat("最終更新日:", format(file.mtime(file_path), "%Y-%m-%d %H:%M:%S"), "\n\n")

  # オブジェクトを読み込み
  tryCatch(
    {
      obj <- readRDS(file_path)

      cat("=== オブジェクト情報 ===\n")
      cat("クラス:", class(obj), "\n")
      cat("オブジェクトサイズ:", round(object.size(obj) / 1024, 2), "KB\n")
      cat("データ型:", typeof(obj), "\n\n")

      # データフレームの場合
      if (is.data.frame(obj)) {
        cat("=== データフレーム情報 ===\n")
        cat("行数:", nrow(obj), "\n")
        cat("列数:", ncol(obj), "\n")
        cat("列名:", paste(names(obj), collapse = ", "), "\n\n")

        cat("=== 列の詳細 ===\n")
        for (i in seq_along(obj)) {
          col_name <- names(obj)[i]
          col_data <- obj[[i]]
          cat(sprintf(
            "%-15s: %s (%d values)\n",
            col_name,
            class(col_data)[1],
            length(col_data)
          ))
        }
        cat("\n")

        cat("=== 先頭5行 ===\n")
        print(head(obj, 5))
        cat("\n")

        cat("=== 要約統計 ===\n")
        print(summary(obj))
      } else if (is.list(obj) && !is.data.frame(obj)) {
        cat("=== リスト情報 ===\n")
        cat("要素数:", length(obj), "\n")
        cat("要素名:", paste(names(obj), collapse = ", "), "\n\n")

        cat("=== 各要素の詳細 ===\n")
        for (i in seq_along(obj)) {
          name <- names(obj)[i]
          element <- obj[[i]]
          cat(sprintf(
            "%-15s: %s\n",
            ifelse(is.null(name) || name == "", paste0("[[", i, "]]"), name),
            class(element)[1]
          ))
        }
        cat("\n")

        cat("=== リスト構造 ===\n")
        str(obj, max.level = 2)
      } else if (inherits(obj, "lm")) {
        cat("=== 線形モデル情報 ===\n")
        cat("フォーミュラ:", deparse(obj$call$formula), "\n")
        cat("観測数:", length(obj$residuals), "\n")
        cat("係数数:", length(obj$coefficients), "\n")
        cat("R-squared:", summary(obj)$r.squared, "\n\n")

        cat("=== 係数 ===\n")
        print(coef(obj))
      } else if (inherits(obj, "gg")) {
        cat("=== ggplotオブジェクト情報 ===\n")
        if (!is.null(obj$labels$title)) {
          cat("タイトル:", obj$labels$title, "\n")
        }
        if (!is.null(obj$labels$x)) {
          cat("X軸ラベル:", obj$labels$x, "\n")
        }
        if (!is.null(obj$labels$y)) {
          cat("Y軸ラベル:", obj$labels$y, "\n")
        }
        cat("レイヤー数:", length(obj$layers), "\n")
      } else {
        cat("=== 一般オブジェクト情報 ===\n")
        cat("長さ:", length(obj), "\n")
        str(obj, max.level = 1)
      }

      return(obj)
    },
    error = function(e) {
      cat("エラー: ファイルを読み込めませんでした:", e$message, "\n")
      return(NULL)
    }
  )
}

# 複数のrdsファイルを一覧表示する関数
list_rds_files <- function(directory = "output") {
  rds_files <- list.files(directory, pattern = "\\.rds$", recursive = TRUE, full.names = TRUE)

  if (length(rds_files) == 0) {
    cat("指定されたディレクトリに.rdsファイルが見つかりません\n")
    return(NULL)
  }

  cat("=== RDSファイル一覧 ===\n")
  for (file in rds_files) {
    size_kb <- round(file.size(file) / 1024, 2)
    mtime <- format(file.mtime(file), "%Y-%m-%d %H:%M")
    cat(sprintf("%-40s  %8s KB  %s\n", basename(file), size_kb, mtime))
  }
  cat("\n")

  return(rds_files)
}

# インタラクティブな確認関数
interactive_rds_explorer <- function(directory = "output") {
  files <- list_rds_files(directory)

  if (is.null(files)) {
    return(NULL)
  }

  cat("確認したいファイルの番号を入力してください:\n")
  for (i in seq_along(files)) {
    cat(i, ":", basename(files[i]), "\n")
  }

  # 非インタラクティブモードでは最初のファイルを表示
  choice <- 1
  cat("選択されたファイル:", basename(files[choice]), "\n\n")

  inspect_rds(files[choice])
}

# メイン実行部分
if (interactive()) {
  # インタラクティブモードの場合
  interactive_rds_explorer()
} else {
  # 非インタラクティブモードの場合、全ファイルの一覧を表示
  cat("=== RDSファイル確認ツール ===\n\n")
  list_rds_files()

  # 主要なファイルを自動で確認
  important_files <- c(
    "output/sample_data.rds",
    "output/models/linear_model.rds",
    "output/complete_analysis.rds",
    "output/plots/scatter_plot.rds"
  )

  for (file in important_files) {
    if (file.exists(file)) {
      cat("\n", rep("=", 60), "\n")
      inspect_rds(file)
      cat("\n")
    }
  }
}
