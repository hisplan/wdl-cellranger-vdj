version 1.0

import "modules/Vdj.wdl" as Vdj

workflow Vdj {

    input {
        String sampleName
        String fastqNames
        Array[File] fastqFiles
        String referenceGenome
    }

    call Vdj.Vdj {
        input:
            sampleName = sampleName,
            fastqNames = fastqNames,
            fastqFiles = fastqFiles,
            referenceGenome = referenceGenome
    }

    output {
        Array[File] outs = Vdj.outs
    }
}