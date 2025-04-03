# Bash codes

## Get a specific column from an .txt file
```bash=
awk '{print $5}' core.txt
```

## Remove suffix of a file
```bash=
for x in *masked; do mv "$x" "${x%.masked}"; done
```

## Remove suffix and add ne suffix 
```bash=
for X in *.fasta; do mv "$X" "${X%.fasta}_masked.fasta";done
```

## Combining columns from two tsv files
```bash=
paste -d, renaming1.tsv <(cut -d " " -f1 renaming2.tsv | awk '{print $0}') > renaming3.tsv
```
## Renaming multiple files with same pattern
```bash=
for f in *.fasta; do mv "$f" "$(echo "$f" | sed s/IMG/VACATION/)"; done
```
## Find and Replace Inside a Text File
```bash=
sed 's/.fasta/.fastq/g' filename
sed 's#9/9#9#g' filename
```
