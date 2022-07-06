# Bait files
Backing up does not avoid the impact of ransomware attacks, but it does make you resilient to the damage because systems can be restored from stored data.
Unfortunately, backup can also be corrupted and thwart all efforts.
There are many measures that protect against this scenario but not all of them can be implemented or are implemented correctly. Often, especially for small entities, there are not the resources for more sophisticated measures (e.g., creating incremental backups, offsite, etc...).

Proposed here is a method that relies more on people than on software to secure the backup.
The way it works is simple: files, with any content, are created on each resource, and its hash is saved. This file is the bait and must must be accessible to all users of the resource like a normal file. People who have access to that resource are informed that they should not modify it. A different variant is to use files in paths that are not normally used or that are not modified.
In the case of a ransomware attack, user-accessible files are encrypted and the hash changes (or the file changes name and is not found).
These bait files are analyzed before backups: if they have not been modified, the backup is made, otherwise the operation is suspended.

This is a beta software: the first improvement to be made is to implement it for analyzing files on a remote machine and not on the local machine.

## Config
A hashes file is required. It will be created at first use if not present.
The structure is like to:

    /myfolder/myexamplefile1.doc
    /myfolder/myexamplefile2.jpg
    /myfolder/myexamplefile3.avi


## Execution
The execution of this file can be planned with crontab, normally as root user:


    if ./BaitFiles.sh; then
        echo "Ok"
        # execute my backup job
    else
        echo "NO"
        # mail, check, ecc...
        # exit 1
    fi

This command will create a backup file and a new file.