version 1.0

import "modules/Vdj.wdl" as Vdj

workflow CellRangerVdj {

    input {
        String sampleName
        String fastqNames
        Array[File] inputFastq
        String referenceGenome
    }

    call Vdj.Vdj {
        input:
            sampleName = sampleName,
            fastqNames = fastqNames,
            inputFastq = inputFastq,
            referenceGenome = referenceGenome
    }

    output {
        Array[File] annotationFiles = Vdj.annotationFiles
        Array[File] fastaFiles = Vdj.fastaFiles
        Array[File] fastqFiles = Vdj.fastqFiles
        Array[File] bamFiles = Vdj.bamFiles
        File cellBarcodes = Vdj.cellBarcodes
        File vloupe = Vdj.vloupe
        File webSummary = Vdj.webSummary
        File metricsSummary = Vdj.metricsSummary
        File clonotypes = Vdj.clonotypes
        File pipestance = Vdj.pipestance

        # Array[File] debugFiles = Vdj.debugFiles
        File log = Vdj.log
        File perf = Vdj.perf
    }
}
