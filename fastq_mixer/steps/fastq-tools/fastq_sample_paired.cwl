#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: fastq-sample

hints:
  DockerRequirement:
    dockerPull: quay.io/andrewelamb/fastq_mixer

inputs:

  in_p1_fastq_file:
    type: File
    inputBinding:
      position: 1
    doc: "Unziped P1 file"

  in_p2_fastq_file:
    type: File
    inputBinding:
      position: 2
    doc: "Unziped P2 file"

  total_reads:
    type: int
    inputBinding:
      prefix: -n
  
  output_prefix:
    type: string
    default: "result"
    inputBinding:
      prefix: -o
  
  with_replacement:
    type: boolean?
    inputBinding:
      prefix: -r

  seed:
    type: int?
    inputBinding:
      prefix: --seed

outputs:

  out_p1_fastq_file:
    type: File
    outputBinding:
      glob: '*.1.fastq'

  out_p2_fastq_file:
    type: File
    outputBinding:
      glob: '*.2.fastq'
  
