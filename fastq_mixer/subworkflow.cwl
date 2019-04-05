#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

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
  fractions: float[]
  kallisto_index: File
  output_name: string
  mixer_seed: int?
  total_reads: int?
  kallisto_threads: int?
  
outputs:

  out: 
    type: File
    outputSource: rename/output_file

steps:
  
  find_reads_to_sample:
    run: steps/utils/find_fastq_reads_to_sample.cwl
    in: 
      fastq_files: p1_fastq_files
      fractions: fractions
      total_reads: total_reads
    out: [reads_to_sample]  
  
  sample:
    run: steps/fastq-tools/fastq_sample_paired.cwl
    in: 
      in_p1_fastq_file: p1_fastq_files
      in_p2_fastq_file: p2_fastq_files
      total_reads: find_reads_to_sample/reads_to_sample
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

  kallisto:
    run: steps/kallisto/quant.cwl
    in:
      fastq_files: [concatenate_p1/output, concatenate_p2/output]
      index: kallisto_index
      threads: kallisto_threads
      plaintext: 
        valueFrom: $( true )
    out: [output]

  rename:
    run: steps/utils/move_file.cwl
    in: 
      input_file: kallisto/output
      output_string: output_name
    out: [output_file]


