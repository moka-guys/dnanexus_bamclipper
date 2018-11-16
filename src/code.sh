#!/bin/bash
#

# The following line causes bash to exit at any point if there is any error
# and to output each line as it is executed -- useful for debugging
set -e -x -o pipefail


# Download inputs
dx-download-all-inputs --parallel

#make output folders
mkdir -p out/clipped_bam/output/ out/clipped_bai/output/

# create variable $opts to hold extra arguments.
# use nproc to determine the number of processors available
opts="-n `nproc`"
# check if upstream and downstream variables are given add to $opts
if [[ $upstream != "" ]]; then
  opts="$opts -u $upstream"
fi
if [[ $downstream != "" ]]; then
  opts="$opts -d $downstream"
fi

#index bamfile using samtools
samtools/bin/samtools index $BAM_in_path

# run bamclipper providing path to BAM (-b), path to BEDPE file (-p) path to samtools (-s) and $opts
bamclipper/bamclipper.sh -b $BAM_in_path -p $primers_path $opts -s /home/dnanexus/samtools/bin/samtools

# move outputs to the output folders
mv $BAM_in_prefix.primerclipped.bam out/clipped_bam/output/
mv $BAM_in_prefix.primerclipped.bam.bai out/clipped_bai/output/

# upload outputs
dx-upload-all-outputs --parallel
