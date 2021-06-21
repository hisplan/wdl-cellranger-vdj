version 1.0

task Vdj {

    input {
        String sampleName
        String fastqNames
        Array[File] inputFastq
        String referenceGenome
    }

    String cellRangerVersion = "6.0.1"
    String referenceVersion = "5.0.0"

    String dockerImage = "hisplan/cromwell-cellranger:" + cellRangerVersion
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
            --id=~{sampleName} \
            --sample ~{fastqNames} \
            --reference /opt/refdata-cellranger-vdj-~{referenceGenome}-alts-ensembl-~{referenceVersion} \
            --fastq=${path_input}

        find ./~{sampleName}

        tar cvzf debug.tgz ./~{sampleName}/_*
    >>>

    output {
        Array[File] annotationFiles = glob(outBase + "/*_annotations.*")
        # - Filtered contigs (CSV):                           ./${sample-name}/outs/filtered_contig_annotations.csv
        # - All contig annotations (JSON):                    ./${sample-name}/outs/all_contig_annotations.json
        # - All contig annotations (BED):                     ./${sample-name}/outs/all_contig_annotations.bed
        # - All contig annotations (CSV):                     ./${sample-name}/outs/all_contig_annotations.csv
        # - Clonotype consensus annotations (CSV):            ./${sample-name}/outs/consensus_annotations.csv

        Array[File] fastaFiles = glob(outBase + "/*.fasta*")
        # - All-contig FASTA:                                 ./${sample-name}/outs/all_contig.fasta
        # - All-contig FASTA index:                           ./${sample-name}/outs/all_contig.fasta.fai
        # - Clonotype consensus FASTA:                        ./${sample-name}/outs/consensus.fasta
        # - Clonotype consensus FASTA index:                  ./${sample-name}/outs/consensus.fasta.fai
        # - Concatenated reference sequences:                 ./${sample-name}/outs/concat_ref.fasta
        # - Concatenated reference index:                     ./${sample-name}/outs/concat_ref.fasta.fai

        Array[File] fastqFiles = glob(outBase + "/*.fastq")
        # - All-contig FASTQ:                                 ./${sample-name}/outs/all_contig.fastq
        # - Clonotype consensus FASTQ:                        ./${sample-name}/outs/consensus.fastq

        Array[File] bamFiles = glob(outBase + "/*.bam*")
        # - Read-contig alignments:                           ./${sample-name}/outs/all_contig.bam
        # - Read-contig alignment index:                      ./${sample-name}/outs/all_contig.bam.bai
        # - Contig-consensus alignments:                      ./${sample-name}/outs/consensus.bam
        # - Contig-consensus alignment index:                 ./${sample-name}/outs/consensus.bam.bai
        # - Contig-reference alignments:                      ./${sample-name}/outs/concat_ref.bam
        # - Contig-reference alignment index:                 ./${sample-name}/outs/concat_ref.bam.bai

        File cellBarcodes = outBase + "/cell_barcodes.json"
        # - Barcodes that are declared to be targetted cells: ./${sample-name}/outs/cell_barcodes.json

        File vloupe = outBase + "/vloupe.vloupe"
        # - Loupe V(D)J Browser file:                         ./${sample-name}/outs/vloupe.vloupe

        File webSummary = outBase + "/web_summary.html"
        # ./${sample-name}/outs/web_summary.html

        File metricsSummary = outBase + "/metrics_summary.csv"
        # ./${sample-name}/outs/metrics_summary.csv

        File clonotypes = outBase + "/clonotypes.csv"
        # ./${sample-name}/outs/clonotypes.csv

        File airr = outBase + "/airr_rearrangement.tsv"
        # AIRR Rearrangement TSV

        File allContigProtoBuf = outBase + "/vdj_contig_info.pb"
        # All contig info (ProtoBuf format)

        File pipestance = sampleName + "/" + sampleName + ".mri.tgz"
        # ./${sample-name}/Lmgp66_tet_replicate.mri.tgz

        File debugFile = "debug.tgz"
        # ./${sample-name}/_invocation
        # ./${sample-name}/_jobmode
        # ./${sample-name}/_mrosource
        # ./${sample-name}/_versions
        # ./${sample-name}/_tags
        # ./${sample-name}/_uuid
        # ./${sample-name}/_timestamp
        # ./${sample-name}/_log
        # ./${sample-name}/_vdrkill
        # ./${sample-name}/_perf
        # ./${sample-name}/_finalstate
        # ./${sample-name}/_cmdline
        # ./${sample-name}/_sitecheck
        # ./${sample-name}/_filelist
    }

    runtime {
        docker: dockerImage
        # disks: "local-disk 1500 SSD"
        cpu: 16
        memory: "128 GB"
    }
}
