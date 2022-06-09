# Bash codes

## Get a specific column from an .txt file
```bash=
awk '{print $5}' core.txt
```
## Remove suffix of a file

```bash=
for x in *masked; do mv "$x" "${x%.masked}"; done
```
