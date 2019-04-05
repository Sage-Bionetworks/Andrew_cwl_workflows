#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: insilicodb/kallisto

baseCommand: [ kallisto, quant, --output-dir, "./"]

inputs:

  fastq_files:
    type: File[]
    inputBinding: 
      position: 1

  index:
    type: File
    inputBinding:
      prefix: --index

  threads:
    type: int?
    inputBinding:
      prefix: --threads
      
  plaintext:
    type: boolean?
    inputBinding:
      prefix: --plaintext
     
outputs:

  output:
    type: File
    outputBinding:
      glob: "abundance.*"