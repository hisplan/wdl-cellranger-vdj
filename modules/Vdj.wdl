version 1.0

task Vdj {

    input {
        String sampleName
        String fastqNames
        Array[File] fastqFiles
        String referenceGenome
    }

    String cellRangerVersion = "3.1.0"
    String dockerImage = "hisplan/cellranger:" + cellRangerVersion
    Float inputSize = size(fastqFiles, "GiB")

    # ~{sampleName} : the top-level output directory containing pipeline metadata
    # ~{sampleName}/outs/ : contains the final pipeline output files.
    String outBase = sampleName + "/outs"

    command <<<
        set -euo pipefail

        export MRO_DISK_SPACE_CHECK=disable

        find .

        path_input=`dirname ~{fastqFiles[0]}`

        # run pipeline
        cellranger vdj \
            --uiport=3600 \
            --id=~{sampleName} \
            --sample ~{fastqNames} \
            --reference /opt/refdata-cellranger-vdj-~{referenceGenome}-alts-ensembl-~{cellRangerVersion} \
            --fastq=${path_input}

        find .
    >>>

    output {
        Array[File] outs = glob(outBase + "/*")
        # - Filtered contigs (CSV):                           /runs/Lmgp66_tet_replicate/outs/filtered_contig_annotations.csv
        # - All-contig FASTA:                                 /runs/Lmgp66_tet_replicate/outs/all_contig.fasta
        # - All-contig FASTA index:                           /runs/Lmgp66_tet_replicate/outs/all_contig.fasta.fai
        # - All-contig FASTQ:                                 /runs/Lmgp66_tet_replicate/outs/all_contig.fastq
        # - Read-contig alignments:                           /runs/Lmgp66_tet_replicate/outs/all_contig.bam
        # - Read-contig alignment index:                      /runs/Lmgp66_tet_replicate/outs/all_contig.bam.bai
        # - All contig annotations (JSON):                    /runs/Lmgp66_tet_replicate/outs/all_contig_annotations.json
        # - All contig annotations (BED):                     /runs/Lmgp66_tet_replicate/outs/all_contig_annotations.bed
        # - All contig annotations (CSV):                     /runs/Lmgp66_tet_replicate/outs/all_contig_annotations.csv
        # - Barcodes that are declared to be targetted cells: /runs/Lmgp66_tet_replicate/outs/cell_barcodes.json
        # - Clonotype consensus FASTA:                        /runs/Lmgp66_tet_replicate/outs/consensus.fasta
        # - Clonotype consensus FASTA index:                  /runs/Lmgp66_tet_replicate/outs/consensus.fasta.fai
        # - Clonotype consensus FASTQ:                        /runs/Lmgp66_tet_replicate/outs/consensus.fastq
        # - Contig-consensus alignments:                      /runs/Lmgp66_tet_replicate/outs/consensus.bam
        # - Contig-consensus alignment index:                 /runs/Lmgp66_tet_replicate/outs/consensus.bam.bai
        # - Clonotype consensus annotations (JSON):           /runs/Lmgp66_tet_replicate/outs/consensus_annotations.json
        # - Clonotype consensus annotations (CSV):            /runs/Lmgp66_tet_replicate/outs/consensus_annotations.csv
        # - Concatenated reference sequences:                 /runs/Lmgp66_tet_replicate/outs/concat_ref.fasta
        # - Concatenated reference index:                     /runs/Lmgp66_tet_replicate/outs/concat_ref.fasta.fai
        # - Contig-reference alignments:                      /runs/Lmgp66_tet_replicate/outs/concat_ref.bam
        # - Contig-reference alignment index:                 /runs/Lmgp66_tet_replicate/outs/concat_ref.bam.bai
        # - Loupe V(D)J Browser file:                         /runs/Lmgp66_tet_replicate/outs/vloupe.vloupe
    }

    runtime {
        docker: dockerImage
        # disks: "local-disk 1500 SSD"
        cpu: 16
        memory: "128 GB"
    }
}
