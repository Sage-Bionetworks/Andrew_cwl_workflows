#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [python, conditional_gunzip.py]

requirements:
  - class: InitialWorkDirRequirement
    listing:
     - entryname: conditional_gunzip.py
       entry: |
         #!/usr/bin/env python
         import argparse
         from subprocess import call
         parser = argparse.ArgumentParser()
         parser.add_argument("-f", "--fastq_file", required=True)
         parser.add_argument("-n", "--no_unzip", action='store_true')
         args = parser.parse_args()

         if (not args.no_unzip) and args.fastq_file.endswith(".gz"):
           call(["gunzip", args.fastq_file])

inputs:

  fastq_file:
    type: File
    inputBinding:
      prefix: -f
  
outputs:

  output:
    type: File
    outputBinding:
      glob: '*'
  
