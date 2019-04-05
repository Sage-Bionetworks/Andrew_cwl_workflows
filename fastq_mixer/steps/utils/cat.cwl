#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: cat

stdout: $(inputs.output_name)

requirements:
- class: InlineJavascriptRequirement

inputs:

  files:
    type: File[]
    inputBinding:
      position: 1
  
  output_name:
    type: string
    default: output.txt
  
outputs:

  output:
    type: stdout
  
