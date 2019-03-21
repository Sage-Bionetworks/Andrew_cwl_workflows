#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: quay.io/andrewelamb/python_synapse_client
    
baseCommand:
- python3
- /usr/local/bin/get_file.py

inputs:
 
  synapse_id:
    type: string
    inputBinding:
      prefix: "--synapse_id"
      
  synapse_config_file:
    type: File
    inputBinding:
      prefix: "--synapse_config_file"

outputs:

  file:
    type: File
    outputBinding:
      glob: ./*
