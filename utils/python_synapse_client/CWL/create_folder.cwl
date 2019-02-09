#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool

requirements:
- class: InlineJavascriptRequirement

hints:
  DockerRequirement:
    dockerPull: python_synapse_client
    
baseCommand:
- python3
- /usr/local/bin/create_folder.py

inputs:

  folder_name:
    type: string
    inputBinding:
      prefix: "--folder_name"
      
  synapse_config_file:
    type: File
    inputBinding:
      prefix: "--synapse_config_file"

  parent_synapse_id:
    type: string
    inputBinding:
      prefix: "--parent_synapse_id"

  annotations_json_file:
    type: File?
    inputBinding:
      prefix: "--annotations_json_file"

  results_json_file:
    type: string
    default: "properties.json"
    inputBinding:
      prefix: "--results_json_file"

outputs:

  - id: results
    type: File
    outputBinding:
      glob: $(inputs.results_json_file)

  - id: file_synapse_id
    type: string
    outputBinding:
      glob: $(inputs.results_json_file)
      loadContents: true
      outputEval: $(JSON.parse(self[0].contents)['id'])
