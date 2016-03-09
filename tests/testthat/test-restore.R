
context("Restore")

test_that("CRAN packages are fine", {

  skip_on_cran()
  skip_if_offline()

  tmp <- tempfile()
  dir.create(tmp)
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  withr::with_libpaths(tmp, {
    ## Install
    install.packages("pkgconfig", lib = tmp, quiet = TRUE)
    source("https://bioconductor.org/biocLite.R")
    biocLite("BiocInstaller", lib = tmp, quiet = TRUE, ask = FALSE,
             suppressUpdates = TRUE)

    ## Snapshot
    pkgs <- tempfile()
    snap(to = pkgs, lib.loc = tmp)

    ## Remove
    unlink(tmp, recursive = TRUE)
    dir.create(tmp)

    ## Restore
    restore(from = pkgs, lib = tmp)

    ## Check
    inst <- installed.packages(lib = tmp)
    expect_equal(rownames(inst), c("BiocInstaller", "pkgconfig"))
  })
})