version 1.0

task Vdj {

    input {
        String sampleName
        String fastqNames
        Array[File] inputFastq
        String referenceGenome
    }

    String cellRangerVersion = "3.1.0"
    String dockerImage = "hisplan/cellranger:" + cellRangerVersion
    Float inputSize = size(inputFastq, "GiB")

    # ~{sampleName} : the top-level output directory containing pipeline metadata
    # ~{sampleName}/outs/ : contains the final pipeline output files.
    String outBase = sampleName + "/outs"

    command <<<
        set -euo pipefail

        export MRO_DISK_SPACE_CHECK=disable

        find .

        path_input=`dirname ~{inputFastq[0]}`

        # run pipeline
        cellranger vdj \
            --uiport=3600 \
            --id=~{sampleName} \
            --sample ~{fastqNames} \
            --reference /opt/refdata-cellranger-vdj-~{referenceGenome}-alts-ensembl-~{cellRangerVersion} \
            --fastq=${path_input}

        find ./~{sampleName}
    >>>

    output {
        Array[File] annotationFiles = glob(outBase + "/*_annotations.*")
        # - Filtered contigs (CSV):                           /runs/Lmgp66_tet_replicate/outs/filtered_contig_annotations.csv
        # - All contig annotations (JSON):                    /runs/Lmgp66_tet_replicate/outs/all_contig_annotations.json
        # - All contig annotations (BED):                     /runs/Lmgp66_tet_replicate/outs/all_contig_annotations.bed
        # - All contig annotations (CSV):                     /runs/Lmgp66_tet_replicate/outs/all_contig_annotations.csv
        # - Clonotype consensus annotations (JSON):           /runs/Lmgp66_tet_replicate/outs/consensus_annotations.json
        # - Clonotype consensus annotations (CSV):            /runs/Lmgp66_tet_replicate/outs/consensus_annotations.csv

        Array[File] fastaFiles = glob(outBase + "/*.fasta*")
        # - All-contig FASTA:                                 /runs/Lmgp66_tet_replicate/outs/all_contig.fasta
        # - All-contig FASTA index:                           /runs/Lmgp66_tet_replicate/outs/all_contig.fasta.fai
        # - Clonotype consensus FASTA:                        /runs/Lmgp66_tet_replicate/outs/consensus.fasta
        # - Clonotype consensus FASTA index:                  /runs/Lmgp66_tet_replicate/outs/consensus.fasta.fai
        # - Concatenated reference sequences:                 /runs/Lmgp66_tet_replicate/outs/concat_ref.fasta
        # - Concatenated reference index:                     /runs/Lmgp66_tet_replicate/outs/concat_ref.fasta.fai

        Array[File] fastqFiles = glob(outBase + "/*.fastq")
        # - All-contig FASTQ:                                 /runs/Lmgp66_tet_replicate/outs/all_contig.fastq
        # - Clonotype consensus FASTQ:                        /runs/Lmgp66_tet_replicate/outs/consensus.fastq

        Array[File] bamFiles = glob(outBase + "/*.bam*")
        # - Read-contig alignments:                           /runs/Lmgp66_tet_replicate/outs/all_contig.bam
        # - Read-contig alignment index:                      /runs/Lmgp66_tet_replicate/outs/all_contig.bam.bai
        # - Contig-consensus alignments:                      /runs/Lmgp66_tet_replicate/outs/consensus.bam
        # - Contig-consensus alignment index:                 /runs/Lmgp66_tet_replicate/outs/consensus.bam.bai
        # - Contig-reference alignments:                      /runs/Lmgp66_tet_replicate/outs/concat_ref.bam
        # - Contig-reference alignment index:                 /runs/Lmgp66_tet_replicate/outs/concat_ref.bam.bai

        File cellBarcodes = outBase + "/cell_barcodes.json"
        # - Barcodes that are declared to be targetted cells: /runs/Lmgp66_tet_replicate/outs/cell_barcodes.json

        File vloupe = outBase + "/vloupe.vloupe"
        # - Loupe V(D)J Browser file:                         /runs/Lmgp66_tet_replicate/outs/vloupe.vloupe

        File webSummary = outBase + "/web_summary.html"
        # ./Lmgp66_tet_replicate/outs/web_summary.html

        File metricsSummary = outBase + "/metrics_summary.csv"
        # ./Lmgp66_tet_replicate/outs/metrics_summary.csv

        File clonotypes = outBase + "/clonotypes.csv"
        # ./Lmgp66_tet_replicate/outs/clonotypes.csv

        File pipestance = sampleName + "/" + sampleName + ".mri.tgz"
        # ./Lmgp66_tet_replicate/Lmgp66_tet_replicate.mri.tgz

        # Array[File] debugFiles = glob(sampleName + "/_*")
        File log = sampleName + "/_log"
        File perf = sampleName + "/_perf"
        # ./Lmgp66_tet_replicate/_invocation
        # ./Lmgp66_tet_replicate/_jobmode
        # ./Lmgp66_tet_replicate/_mrosource
        # ./Lmgp66_tet_replicate/_versions
        # ./Lmgp66_tet_replicate/_tags
        # ./Lmgp66_tet_replicate/_uuid
        # ./Lmgp66_tet_replicate/_timestamp
        # ./Lmgp66_tet_replicate/_log
        # ./Lmgp66_tet_replicate/_vdrkill
        # ./Lmgp66_tet_replicate/_perf
        # ./Lmgp66_tet_replicate/_finalstate
        # ./Lmgp66_tet_replicate/_cmdline
        # ./Lmgp66_tet_replicate/_sitecheck
        # ./Lmgp66_tet_replicate/_filelist
        # ./Lmgp66_tet_replicate/_vdrkill._truncated_
        # ./Lmgp66_tet_replicate/_perf._truncated_
    }

    runtime {
        docker: dockerImage
        # disks: "local-disk 1500 SSD"
        cpu: 16
        memory: "128 GB"
    }
}
