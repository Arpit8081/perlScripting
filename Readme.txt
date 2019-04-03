WWW/ given a directory from a webserver that contains multiple HTML files as well as multiple files of other types (e.g. images). 
The directory may contain subdirectories. I do clean up this directory and its subdirectories by removing all unused files. 
A file is considered unused if it is not linked in any of the HTML files or if it is not specified explicitly that this file is in use. 
A file can be linked in a HTML file by either a href or img src. It does not matter whether the link is within a commented-out section of the HTML file.
also scrpit create statistics output for the files that have been removed.
The statistics output must be in text form and must contain, for each file ending, the number of files and the overall size of files with that ending. In addition, the number and size of all removed files needs to be reported. For this purpose, fileendings are not case-sensitive (i.e. .gif and .GIF are considered the same for statistics purposes). The statistics must also contain the name of the directory on which the cleanup script has been run.
