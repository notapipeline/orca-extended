install.packages("IRkernel", repos="https://cran.rediris.es/")
IRkernel::installspec(user = FALSE)

BiocManager::install(c(
    "TxDb.Mmusculus.UCSC.mm10.knownGene", "org.Mm.eg.db", "GenomicRanges",
    "dplyr", "ChIPseeker", "ChIPpeakAnno", "VennDiagram", "stringr",
    "viridis", "chromVAR", "DESeq2", "ggpubr", "corrplot", "CATALYST",
    "flowCore", "diffcyt", "SummarizedExperiment"
    ),
    update = TRUE, ask = FALSE
)

