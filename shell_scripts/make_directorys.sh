# make directorys for multiple .fasta files without file extention

for X in *.fasta
do 
  NAME=$(ls $X| cut -d "." -f 1)
  mkdir "$NAME"_repeatmasker
done
