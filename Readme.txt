WWW/ given a directory from a webserver that contains multiple HTML files as well as multiple files of other types (e.g. images). 
The directory may contain subdirectories. I do clean up this directory and its subdirectories by removing all unused files. 
A file is considered unused if it is not linked in any of the HTML files or if it is not specified explicitly that this file is in use. 
A file can be linked in a HTML file by either a href or img src. It does not matter whether the link is within a commented-out section of the HTML file. Do not
remove subdirectories.
