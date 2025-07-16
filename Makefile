# Makefile for R project

# Default target
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make fmt       - Format all R files using styler"
	@echo "  make lint      - Lint all R files using lintr"
	@echo "  make check     - Run both fmt and lint"
	@echo "  make install   - Install required packages"
	@echo "  make clean     - Clean generated files"
	@echo "  make test      - Run R scripts in test directory"
	@echo "  make render    - Render all Rmd files to PDF"
	@echo "  make serve     - Start R session"
	@echo "  make deps      - Install fmt and lint dependencies"
	@echo "  make render-file FILE=path/to/file.Rmd - Render specific Rmd file"

# Format all R files using styler
.PHONY: fmt
fmt:
	@echo "Formatting R files..."
	Rscript -e 'if (!requireNamespace("styler", quietly = TRUE)) install.packages("styler", repos = "https://cran.rstudio.com/"); styler::style_dir(".", recursive = TRUE, filetype = "R")'
	@echo "Formatting complete!"

# Lint all R files using lintr
.PHONY: lint
lint:
	@echo "Linting R files..."
	Rscript -e 'if (!requireNamespace("lintr", quietly = TRUE)) install.packages("lintr", repos = "https://cran.rstudio.com/"); lintr::lint_dir(".")'

# Run both format and lint
.PHONY: check
check: fmt lint
	@echo "Format and lint check complete!"

# Install required packages for the project
.PHONY: install
install:
	@echo "Installing required packages..."
	Rscript -e 'install.packages(c("ggplot2", "gganimate", "gifski", "rmarkdown", "dplyr", "knitr"), repos = "https://cran.rstudio.com/")'
	@echo "Package installation complete!"

# Install fmt and lint dependencies
.PHONY: deps
deps:
	@echo "Installing styler and lintr..."
	Rscript -e 'install.packages(c("styler", "lintr", "formatR"), repos = "https://cran.rstudio.com/")'
	@echo "Dependencies installed!"

# Clean generated files
.PHONY: clean
clean:
	@echo "Cleaning generated files..."
	find . -name "*.pdf" -not -path "./dojou-25-5/Rplots.pdf" -not -path "./jikken-matuoka/Rplots.pdf" -not -path "./test/Rplots.pdf" -delete
	find . -name "*.html" -delete
	find . -name "*.aux" -delete
	find . -name "*.log" -delete
	find . -name "*.tex" -not -name "test.tex" -delete
	find . -name "Rplots.pdf" -delete
	@echo "Cleanup complete!"

# Run R scripts in test directory
.PHONY: test
test:
	@echo "Running test scripts..."
	@for file in test/*.R; do \
		if [ -f "$$file" ]; then \
			echo "Running $$file..."; \
			Rscript "$$file"; \
		fi \
	done
	@echo "Test execution complete!"

# Render all Rmd files to PDF
.PHONY: render
render:
	@echo "Rendering Rmd files to PDF..."
	@for file in $$(find . -name "*.Rmd"); do \
		echo "Rendering $$file..."; \
		Rscript -e "rmarkdown::render('$$file')"; \
	done
	@echo "Rendering complete!"

# Render specific Rmd file
.PHONY: render-file
render-file:
	@if [ -z "$(FILE)" ]; then \
		echo "Usage: make render-file FILE=path/to/file.Rmd"; \
		exit 1; \
	fi
	@echo "Rendering $(FILE)..."
	Rscript -e "rmarkdown::render('$(FILE)')"
	@echo "Rendering complete!"

# Start R session
.PHONY: serve
serve:
	@echo "Starting R session..."
	R

# Format specific file
.PHONY: fmt-file
fmt-file:
	@if [ -z "$(FILE)" ]; then \
		echo "Usage: make fmt-file FILE=path/to/file.R"; \
		exit 1; \
	fi
	@echo "Formatting $(FILE)..."
	Rscript -e 'if (!requireNamespace("styler", quietly = TRUE)) install.packages("styler", repos = "https://cran.rstudio.com/"); styler::style_file("$(FILE)")'

# Lint specific file
.PHONY: lint-file
lint-file:
	@if [ -z "$(FILE)" ]; then \
		echo "Usage: make lint-file FILE=path/to/file.R"; \
		exit 1; \
	fi
	@echo "Linting $(FILE)..."
	Rscript -e 'if (!requireNamespace("lintr", quietly = TRUE)) install.packages("lintr", repos = "https://cran.rstudio.com/"); lintr::lint("$(FILE)")'

# Run specific R script
.PHONY: run
run:
	@if [ -z "$(FILE)" ]; then \
		echo "Usage: make run FILE=path/to/file.R"; \
		exit 1; \
	fi
	@echo "Running $(FILE)..."
	Rscript "$(FILE)"

# Check data file
.PHONY: check-data
check-data:
	@if [ -z "$(FILE)" ]; then \
		echo "Usage: make check-data FILE=path/to/data.csv"; \
		exit 1; \
	fi
	@echo "Checking data file: $(FILE)"
	@echo "First 10 lines:"
	@head -10 "$(FILE)"
	@echo ""
	@echo "Line count:"
	@wc -l "$(FILE)"
	@echo ""
	@echo "R data summary:"
	@Rscript -e 'data <- read.csv("$(FILE)"); cat("Structure:\n"); str(data); cat("\nSummary:\n"); summary(data)'
