#!/bin/bash
# File: download_SRA.sh
## Konstantinos Con_Yel
## Download SRA data with the help of docker
pt -s xpg_echo #for echo /n

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
 echo "Now downloading $line\n"
 docker run --rm -v "$(pwd)":/data -w /data inutano/sra-toolkit fasterq-dump "$line" -t /data/shm -e 12
 echo "Using pigz on $line.fastq"
 if [ -s "$line.fastq" ]; then
 pigz --best "$line.fastq";
 else
 pigz --best "$line_1.fastq";
 pigz --best "$line_2.fastq";
 done < "$INPUT_txt"
