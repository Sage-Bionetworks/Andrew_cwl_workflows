#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

doc: runs fastq mixing and kallisto quantification for one repetition

requirements:
- class: ScatterFeatureRequirement
- class: SubworkflowFeatureRequirement

inputs:
  
- id: p1_fastq_arrays
  type:
    type: array
    items:
      type: array
      items: File

- id: p2_fastq_arrays
  type:
    type: array
    items:
      type: array
      items: File

- id: total_read_arrays
  type:
    type: array
    items:
      type: array
      items: int

- id:  kallisto_index
  type: File


- id:  synapse_config
  type: File

- id:  p1_fastq_output_names
  type: string[]

- id:  p2_fastq_output_names
  type: string[]

- id:  fastq_destination_id
  type: string

- id:  kallisto_output_names
  type: string[]

- id:  kallisto_destination_id
  type: string

  
outputs: []

steps:

  scatter_mixer:
    run: mix_fastqs_workflow.cwl
    in:
    - id: p1_fastq_files
      source: p1_fastq_arrays
    - id: p2_fastq_files
      source: p2_fastq_arrays
    - id: total_reads
      source: total_read_arrays
    - id: kallisto_index
      source: kallisto_index
    - id: synapse_config
      source: synapse_config
    - id: p1_fastq_output_name
      source: p1_fastq_output_names
    - id: p2_fastq_output_name
      source: p2_fastq_output_names
    - id: fastq_destination_id
      source: fastq_destination_id
    - id: kallisto_output_name
      source: kallisto_output_names
    - id: kallisto_destination_id
      source: kallisto_destination_id
    scatter:
    - p1_fastq_files
    - p2_fastq_files
    - total_reads
    - p1_fastq_output_name
    - p2_fastq_output_name
    - kallisto_output_name
    scatterMethod: dotproduct
    out: []

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0326-7494
    s:email: andrew.lamb@sagebase.org
    s:name: Andrew Lamb


