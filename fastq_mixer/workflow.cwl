#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: Workflow

doc: runs fastq mixing and kallisto quantification for mutiple repetitions

requirements:
- class: ScatterFeatureRequirement
- class: SubworkflowFeatureRequirement

inputs:
  
  p1_fastq_files: File[]
  p2_fastq_files: File[]
  fractions: float[]
  kallisto_index: File
  output_name_array: string[]
  mixer_seed_array: 
    type:
      type: array
      items: ["null", int]
  total_reads: int?
  kallisto_threads: int?
  
outputs:

  out: 
    type: File[]
    outputSource: scatter_mix/out

steps:
  
  scatter_mix:
    run: paired_fastq_mixing_workflow.cwl
    in: 
      p1_fastq_files: p1_fastq_files
      p2_fastq_files: p2_fastq_files
      fractions: fractions
      kallisto_index: kallisto_index
      mixer_seed: mixer_seed_array
      output_name: output_name_array
      total_reads: total_reads
      kallisto_threads: kallisto_threads
    scatter: [output_name, mixer_seed]
    scatterMethod: dotproduct
    out: [out]  
