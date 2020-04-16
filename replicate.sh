orig_fn=4447
dir_fn=roll_nos

rename_files() {
    rename "s/$1/$2/" $2/*
}

# Currently hardcoded for c/cpp files
# you can change the extensions in 
# the regex as needed
replace_all() {
    find $2 -regex '.*[c|cpp]' -print0 | xargs -0 sed -i "s/\b$1\b/$2/g"
}


while IFS= read -r line
do
    cp -r $orig_fn $line
    rename_files $orig_fn $line
    replace_all $orig_fn $line
done < $dir_fn
