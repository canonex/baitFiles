# Bait files
Backing up does not avoid the impact of ransomware attacks, but it does make you partially resilient to the damage because systems can be restored from stored data (I write partially because it does not protect you from data leakage / data exfiltration).

Unfortunately, **backup can also be corrupted** and thwart all efforts.
There are many measures that protect against this scenario but not all of them can be implemented or are implemented correctly. Often, especially for small entities, there are not the resources for more sophisticated measures (e.g., creating incremental backups, offsite, etc...).

Proposed here is a basic method that **relies more on people than on software** to secure the backup.
The way it works is simple: files, with any content, are created on each resource, and its hash is saved. This file is the bait and **must must be accessible to all users of the resource like a normal file**. People who have access to that resource are informed that they should not modify it. A different variant is to use files in paths that are not normally used or that are not modified.

In the case of a ransomware attack, user-accessible files are encrypted and the hash changes (or the file changes name and is not found).
These bait files are analyzed before backups: if they have not been modified, the backup is made, otherwise the operation is cancelled ().

This is a beta software: the first improvement to be made is to implement it for analyzing files on a remote machine and not on the local machine. A second improvement is to create a dynamic hash list based on actual file usage: this would make the system fully automatic.

## Config
A hashes file is required. If it does not exist it can be created automatically from a **list** file: a demo list file is also created if it does not exist.
The structure of the list file is like to:

    /myfolder/myexamplefile1.doc
    /myfolder/myexamplefile2.jpg
    /myfolder/myexamplefile3.avi


To modify the hash list, simply delete it: it will be recreated from the list file.

## Execution
The execution of this file can be included in other scripts like:

    if ./baitFiles.sh; then
        echo "proceed"
        # execute my backup job, ex. rsync ...
    else
        echo "stop"
        # mail, check, ecc...
        # exit 1
    fi

or planned with crontab using a single line, ex.:

    3 19 * * 2 /bin/bash -c "if ./baitFiles.sh; then echo proceed; else echo stop; fi"

This command will create a backup file and a new file.