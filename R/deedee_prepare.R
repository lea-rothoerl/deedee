#' DeeDee Prepare
#'
#' @description `deedee_prepare` creates a DeeDee table from a DEA result
#'
#' @param data result from DESeq2, limma or edgeR
#' @param input_type the program the data comes from (`DESeq2`, `limma` or
#'                  `edgeR`)
#'
#' @return DeeDee table, to be used as part of the input for the other DeeDee
#' functions
#'
#' @examples
#'
#' data(DE_results_IFNg_naive, package = "DeeDee")
#'
#' deedee_table <- deedee_prepare(IFNg_naive, "DESeq2")
#' @export
#'

deedee_prepare <- function(data, input_type) {

  # ----------------------------- argument check ------------------------------
  choices <- c("DESeq2", "edgeR", "limma")
  checkmate::assertChoice(input_type, choices)

  if (input_type == "DESeq2") {
    checkmate::assertClass(data, "DESeqResults")
    logFC <- data$log2FoldChange
    pval <- data$padj
    input <- data.frame(logFC, pval)
    rownames(input) <- data@rownames
  } else if (input_type == "edgeR") {
    checkmate::assertClass(data, "DGEExact")
    logFC <- data[["table"]][["logFC"]]
    pval <- data[["table"]][["PValue"]]
    input <- data.frame(logFC, pval)
    rownames(input) <- data[["genes"]][["genes"]]
  } else if (input_type == "limma") {
    checkmate::assertDataFrame(data, types = "numeric")
    logFC <- data$logFC
    pval <- data$adj.P.Val
    input <- data.frame(logFC, pval)
    rownames(input) <- rownames(data)
  }
  return(input)
}
