#!/bin/bash
#

# The following line causes bash to exit at any point if there is any error
# and to output each line as it is executed -- useful for debugging
set -e -x -o pipefail


# Download inputs
dx-download-all-inputs --parallel

#make output folders
mkdir -p out/clipped_bam/output/ out/clipped_bai/output/

#install GNU parallel
sudo apt-get install parallel=20130922-1

# build the extra arguments if given
opts="-n `nproc`"
if [[ $upstream != "" ]]; then
  opts="$opts -u $upstream"
fi
if [[ $downstream != "" ]]; then
  opts="$opts -d $downstream"
fi

#index bamfile
samtools/bin/samtools index $BAM_in_path

# run bamclipper
bamclipper/bamclipper.sh -b $BAM_in_path -p $primers_path $opts -s /home/dnanexus/samtools/bin/samtools

ls

# move outputs 
mv $BAM_in_prefix.primerclipped.bam out/clipped_bam/output/
mv $BAM_in_prefix.primerclipped.bam.bai out/clipped_bai/output/

# upload outputs
dx-upload-all-outputs --parallel
