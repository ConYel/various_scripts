#!/bin/bash
# File: download_SRA.sh
## Konstantinos Con_Yel
## Download SRA data with the help of docker

INPUT_txt="$1"

if [ $# -lt 1 ]; then
echo "USAGE: <INPUT_txt> file with all SRA ids one per line, downloads everything in working dir"
exit 1
fi

while IFS= read -r line; do
docker run --rm  -v "$(pwd)":/data -w /data inutano/sra-toolkit  fasterq-dump "$line" -t /data/shm -e 12
done < "$INPUT_txt"