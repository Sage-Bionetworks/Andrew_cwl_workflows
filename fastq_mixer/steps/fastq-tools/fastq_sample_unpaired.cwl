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

  fastq_file:
    type: File
    inputBinding:
      position: 1
    doc: "Unpaired fastq files. May be zipped"

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

  output:
    type: File
    outputBinding:
      glob: '*.fastq'
  
