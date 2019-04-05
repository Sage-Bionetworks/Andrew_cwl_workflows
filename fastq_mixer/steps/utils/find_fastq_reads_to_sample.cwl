#!/usr/bin/env cwl-runner
#
# Authors: Andrew Lamb

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [python, find_fastq_reads_to_sample.py]

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
     - entryname: find_fastq_reads_to_sample.py
       entry: |
         #!/usr/bin/env python
         import argparse
         import statistics 
         import json

         parser = argparse.ArgumentParser()
         parser.add_argument("-f", "--fastq_files", type=str,   nargs = "+", required=True)
         parser.add_argument("-r", "--fractions",   type=float, nargs = "+", required=True)
         parser.add_argument("-t", "--total_reads", type=int,   default=False)
         args = parser.parse_args()

         def find_n_reads_in_fastq(fastq):
             num_lines = sum(1 for line in open(fastq))
             reads = int(num_lines/4)
             return(reads)

         if(args.total_reads):
             total_reads = args.total_reads
         else:
             reads = [find_n_reads_in_fastq(fastq) for fastq in args.fastq_files]
             total_reads = statistics.mean(reads)

         reads_to_sample = [int(total_reads * fraction) for fraction in args.fractions]
         with open("results.json", 'w') as o:
             o.write(json.dumps(reads_to_sample))

inputs:

  fastq_files:
    type: File[]
    inputBinding:
      prefix: -f

  fractions:
    type: float[]
    inputBinding:
      prefix: -r

  total_reads:
    type: int?
    inputBinding:
      prefix: -t
  
outputs:

  - id: reads_to_sample
    type: int[]
    outputBinding:
      glob: results.json
      loadContents: true
      outputEval: $(JSON.parse(self[0].contents))
  
