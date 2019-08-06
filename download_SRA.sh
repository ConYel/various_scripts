#!/bin/bash 
# File: download_SRA.sh 
## Konstantinos Con_Yel 
## Download SRA data with the help of docker 

shopt -s xpg_echo

INPUT_txt="$1" 

DOCKER="/usr/bin/docker" 
PIGZ="/usr/bin/pigz" 

if [ $# -lt 1 ]; then 
echo "USAGE: <INPUT_txt> file with all SRA ids one per line, downloads everything in working dir" 
exit 1 
fi 

# check prerequisites
PREREQS="${DOCKER} ${PIGZ}" 

for prereq in $PREREQS; do 
if [ ! -x "${prereq}" ]; then 
echo "the ${prereq} not found"; 
exit 1 
fi
done 

if [ $# -lt 1 ]; then 
echo "USAGE: <INPUT_txt> file with all SRA ids one per line, downloads everything in working dir" 
exit 1
 fi 

while IFS= read -r line; do
 echo "Now downloading ${line}\n"
 docker run --rm -v "$(pwd)":/data -w /data inutano/sra-toolkit fasterq-dump "${line}" -t /data/shm -e 12
 if [ -s "${line}*.fastq" ]; then
 echo "Using pigz on ${line}.fastq" 
     pigz --best "${line}*.fastq";
 else 
    echo "${line}.fastq not found"
 fi
 done < "$INPUT_txt"
