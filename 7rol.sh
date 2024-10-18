#!/bin/bash

#Sciezka, w ktorej bedziemy szukac plikow
SEARCH_PATH="/nfs/prod/logi/"

# Uzyskaj date wczorajszego dnia w formacie DDMMYY
z_date=$(date "+%Y-%m-%d-%I")

#Find all files with .log in name, without bz2 and not old that mtime, next cut file path and name file, name file save as z_file
find "$SEARCH_PATH" -type f -name "*.log" -mtime +31 -print0 ! -size -10k  ! -size +10G ! -name "*.bz2" ! -name "*.gz" ! -name "*.xz" | while IFS= read -r -d $'\0' z_file; do

	z_last_modified_date=$(stat -c %y "$z_file" | cut -d' ' -f1 | sed 's/-/./g')
	echo "$z_file.$z_last_modified_date"   
	mv "$z_file" "$z_file.$z_last_modified_date"
	nice xz "$z_file.$z_last_modified_date"



done