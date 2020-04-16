# Find Replace Utilities

> Renaming files, and replacing certain text from all the files in a directory  are some of the use-cases that we often encounter.

`rename` is quite handy command to batch-rename files based on regex patterns. If you don't have this installed on your system, you can easily install it using package manager of your distribution.

* Install `rename` on **Ubuntu/Debian**

  ```shell
  sudo apt install rename
  ```

* Install `rename` on **CentOS/Fedora**

  ```shell
  sudo yum install prename
  ```

* Install `rename` on **Arch Linux**

  ```shell
  yay perl-rename
  ```

You might say, why not use `mv`  :thinking: . Indeed it suffice for renaming just a single file or directory, but when it comes to rename multiple directories, that too, based on some pattern, `rename` has an upper hand. Coming back to use-case mentioned,

1. To rename part of filename or directory

   ```shell
   rename -n 's/4447/4449/'
   ```

   '-n' here is used to verbose the changes about to made, thus, above command will not directly perform renaming operation, but rather, inform you about the changes.

   Output:

   ```shell
   # Imaging you've c/cpp files containing 4447 in their names
   #output: rename(Test (4447-10).c, Test (4449-10).c)
   #        rename(Test (4447-11).c, Test (4449-11).c)
   #        rename(Test (4447-3).cpp, Test (4449-3).cpp)
   #        rename(Test (4447-4).c, Test (4449-4).c)
   ```

   On confirming the change is correct, you can simply remove  '-n' :wink: and it's done.

2. To reuse groups from regex

   ```shell
   rename -n 's/(\d{1,2})\w{2}\ copy/4447-$1/' *
   ```

   The pattern says, match 1 or 2 digit number which is followed by exactly two characters and ' copy'. But notice how I grouped  the number in a parenthesis :slightly_smiling_face: . The grouped pattern could be reused in the destination part of rename using `$n` where n stands for group no.

   Output:

   ```shell
   # The first part says existing file names while 2nd is after renaming
   #output: rename(Test (10th copy).txt, Test (4447-10).txt)
   #        rename(Test (11th copy).txt, Test (4447-11).txt)
   #        rename(Test (3rd copy).txt, Test (4447-3).txt)
   #        rename(Test (4th copy).txt, Test (4447-4).txt)
   ```

3. Find files with regex and manipulate contents of it again based on some regex :relieved:

   ```shell
   find . -regex '.*[c|cpp]' -print0 | xargs -0 sed -i "s/\b4449\b/4447/g"
   ```

   The above command searches c/c++ files in a current `.` directory, `-print0` prints them as a single string delimiting each filename with `\0`  null character.  `xargs` is used to pipe the output of previous command as the argument for following command (where `-0` option ensures splitting the string on null character).

   The `sed` command is used to find-replace contents of  file where `/s` indicates start, `\b4449\b` ensures matching the exact word and not the mixed ones (It'll match *4449* but not the *44491234* or *abc4449*)

4. Combing all of the above

   Suppose I want to create exact replica of given directory, but changing the filenames and contents based on some patterns. Let's say I've Following files in an directory named `4447`  

   ![](docs/files.png)

   The contents of file are as follows

   ```reStructuredText
   Roll No: 4447
   
   {4447}45
   
   {4447}45
   
   sh laskgh l halskghg
   safkhkgajs ajsfh kjagh aj
   
   {4447}45
   
   asjkf
   
   13454
   
   asfh
   
   {4447}45
   ```

   In the end, I want to have following directories, but modified contents

   <img src="docs/dirs.png" style="zoom: 67%;" />

   A simple script could do the same for you:

   ```shell
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
   ```

   I do have a `.txt` file with roll numbers in it, separated by newline. Steps involved in the above script are:

   1. Read the file called `roll_nos`
   2. Recursively copy all the files in a base directory (`orig_fn`) to new folder with name retrieved by the input `.txt` file
   3. Rename files with new roll no. 
   4. Replace all the instances of `roll_no` in the contents of files with new roll no.
   5. Done



**Disclaimer:** Above scripts are used only to demonstrate the use-case and not used in any malicious activities :stuck_out_tongue_winking_eye: