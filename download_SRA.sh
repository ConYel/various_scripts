#!/bin/bash 
# File: download_SRA.sh 
## Konstantinos Con_Yel 
## Download SRA data with the help of docker 

shopt -s xpg_echo

INPUT_txt="$1" 
Processors="${2:-4}"

DOCKER="docker" 
PIGZ="pigz" 

if [ $# -lt 1 ]; then 
echo "USAGE: download_SRA.sh <INPUT_txt>  <Processors> file with all SRA ids one per line, downloads everything in working dir" 
exit 1 
fi 

# check prerequisites
PREREQS="${DOCKER} ${PIGZ}" 

for prereq in $PREREQS; do 
if ! [ -x "$(command -v ${prereq})" ]; then 
echo "the ${prereq} not found"; 
exit 1 
fi
done 


while IFS= read -r line; do
 echo "Now downloading "${line}"\n"
 docker run --rm -v "$(pwd)":/data -w /data inutano/sra-toolkit fasterq-dump "${line}" -t /data/shm -e $Processors
 if [[ -s ${line}_1.fastq ]]; then
 echo "Using pigz on ${line}.fastq" 
     pigz --best ${line}*.fastq
 elif [[ -s ${line}.fastq ]]; then 
     pigz --best ${line}*.fastq
 else 
    echo "${line}.fastq not found"
 fi
 done < "$INPUT_txt"
