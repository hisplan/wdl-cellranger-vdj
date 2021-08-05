version 1.0

import "modules/Vdj.wdl" as Vdj

workflow Vdj {

    input {
        String sampleName
        String fastqNames
        Array[File] inputFastq
        String referenceGenome

        # docker-related
        String dockerRegistry
    }

    call Vdj.Vdj {
        input:
            sampleName = sampleName,
            fastqNames = fastqNames,
            inputFastq = inputFastq,
            referenceGenome = referenceGenome,
            dockerRegistry = dockerRegistry
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
        File airr = Vdj.airr
        File allContigProtoBuf = Vdj.allContigProtoBuf
        File vdjReference = Vdj.vdjReference

        File pipestanceMeta = Vdj.pipestanceMeta
    }
}
