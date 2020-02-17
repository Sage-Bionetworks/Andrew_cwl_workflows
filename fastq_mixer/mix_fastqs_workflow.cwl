#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

doc: runs fastq mixing and kallisto quantification for one repetition

requirements:
- class: ScatterFeatureRequirement
- class: StepInputExpressionRequirement
- class: InlineJavascriptRequirement
- class: MultipleInputFeatureRequirement

inputs:
  
  p1_fastq_files: File[]
  p2_fastq_files: File[]
  total_reads: int[]
  kallisto_index: File
  synapse_config: File
  p1_fastq_output_name: string
  p2_fastq_output_name: string
  fastq_destination_id: string
  kallisto_output_name: string
  kallisto_destination_id: string
  mixer_seed: int?
  kallisto_threads: int?
  
outputs: []

steps:
    
  sample:
    run: steps/fastq-tools/fastq_sample_paired.cwl
    in: 
      in_p1_fastq_file: p1_fastq_files
      in_p2_fastq_file: p2_fastq_files
      total_reads: total_reads
      seed: mixer_seed
      with_replacement: 
        valueFrom: $( true )
    out: [out_p1_fastq_file, out_p2_fastq_file]
    scatter: [in_p1_fastq_file, in_p2_fastq_file, total_reads]
    scatterMethod: dotproduct

  concatenate_p1:
    run: steps/utils/cat.cwl
    in: 
      files: sample/out_p1_fastq_file
    out: [output]  

  concatenate_p2:
    run: steps/utils/cat.cwl
    in: 
      files: sample/out_p2_fastq_file
    out: [output]  

  p1_fastq_rename:
    run: https://raw.githubusercontent.com/CRI-iAtlas/iatlas-workflows/v1.0/utils/expression_tools/CWL/rename_file.cwl
    in: 
    - id: input_file
      source: concatenate_p1/output
    - id: new_file_name
      source: p1_fastq_output_name
    out: [output_file]

  p1_fastq_syn_store:
    run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-store-tool.cwl
    in: 
    - id: synapse_config
      source: synapse_config
    - id: file_to_store
      source: p1_fastq_rename/output_file
    - id: parentid
      source: fastq_destination_id
    out: []

  p2_fastq_rename:
    run: https://raw.githubusercontent.com/CRI-iAtlas/iatlas-workflows/v1.0/utils/expression_tools/CWL/rename_file.cwl
    in: 
    - id: input_file
      source: concatenate_p2/output
    - id: new_file_name
      source: p2_fastq_output_name
    out: [output_file]

  p2_fastq_syn_store:
    run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-store-tool.cwl
    in: 
    - id: synapse_config
      source: synapse_config
    - id: file_to_store
      source: p2_fastq_rename/output_file
    - id: parentid
      source: fastq_destination_id
    out: []

  kallisto:
    run: steps/kallisto/quant_paired.cwl
    in:
      - id: fastq1
        source: concatenate_p1/output
      - id: fastq2
        source: concatenate_p2/output
      - id: index
        source: kallisto_index
      - id: threads
        source: kallisto_threads
    out: [abundance_tsv]

  kallisto_rename:
    run: https://raw.githubusercontent.com/CRI-iAtlas/iatlas-workflows/v1.0/utils/expression_tools/CWL/rename_file.cwl
    in: 
    - id: input_file
      source:: kallisto/abundance_tsv
    - id: new_file_name
      source: kallisto_output_name
    out: [output_file]

  kallisto_syn_store:
    run: https://raw.githubusercontent.com/Sage-Bionetworks/synapse-client-cwl-tools/v0.1/synapse-store-tool.cwl
    in: 
    - id: synapse_config
      source: synapse_config
    - id: file_to_store
      source: kallisto_rename/output_file
    - id: parentid
      source: kallisto_destination_id
    out: []

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb


