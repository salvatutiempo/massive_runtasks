
# Description

Have you ever needed to reboot a whole server nest after upgrading their OS? Or maybe extract information from all of them for our inventory? Those are typical tasks that are usually done in every company, and we have been forced to deal with them, with all the time we spend on that.

Doing multiple operations can become a tedious task, especially if we need to do it for a lot of servers.

This script will let you run multiple commands in hundreds of Linux servers

# stt_massive_runtasks.sh
Script to run Massive tasks in Linux Servers

# Prerrequisites
## 1. Create files

We need to create the following files for this script:

**hosts.txt:** We will store all the servers address that we want to connect to.

```bash
[salvatutiempo@localhost temp]$ nano hosts.txt
1.1.1.1
2.2.2.2
3.3.3.3
4.4.4.4
5.5.5.5
```

**pass.txt:**  We will store the password that will be neeed to connect to every server, and the one that our script will use to automate this task.

```bash
[salvatutiempo@localhost temp]$ nano pass.txt
PASS_SERVER
```

## 2. Variables

We will define the variables that will be needed later

```bash
HOSTS="hosts.txt"
USER="username"
SSHPASS=$(cat pass.txt)
```
**HOSTS:** This variable has the text file path with all the destination servers.
**USER:** This variable will have the username that we will need to connect to servers.
**SSHPASS:**  It will read the password that we stored and it will be used to connect to servers


# stt_massive_runtasks_safer.sh
Script to run massive tasks with Improved security password

# Prerrequisites
## 1. Create files

We need to create the following files for this script:

**hosts.txt:** We will store all the servers address that we want to connect to.

```bash
[salvatutiempo@localhost temp]$ nano hosts.txt
1.1.1.1
2.2.2.2
3.3.3.3
4.4.4.4
5.5.5.5
```

**pass.txt:**  We will store the password that will be neeed to connect to every server, and the one that our script will use to automate this task.

```bash
[salvatutiempo@localhost temp]$ nano pass.txt
PASS_SERVER
```

## 2. Encrypt password

In order to be safer we can encrypt that password, and only decrypt it in code, in order to be used only when needed. In that encryption, a "passphrase" will be asked. That passphrase will be the key to decrypt our file.

For that:

1. Let's suppose that our password stored in “pass.txt” file. We will use GPG to encrypt the file, using the following command:

```bash
$ gpg -c pass.txt
```

2. It will ask us to set a “passphrase”

```bash
lqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqk
x Enter passphrase                                    x
x                                                     x
x                                                     x
x Passphrase ________________________________________ x
x                                                     x
x       <OK>                             <Cancel>     x
mqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqj
```

That will generate a new file with the same name as the original file, but with a new extension "gpg" (in our case, "pass.txt.gpg").

3. We will remove our plain fie "pass.txt"

```bash
$ sudo rm -rf pass.txt
```

4. In order to be even safer, we will hide our file. For that, we will just add a dot "." at the beginning og the file name (in our example, ".pass.txt.gpg"). It will only be seend using “ls -a” command.

5. We will also store our "passphrase" in our system in order to automatically decrypt the password file. In this example, we will store it in ".passphrase.txt" file (with a "." at the beginning to hide it).

## 3. Variables

We will define the variables that will be needed later

```bash
HOSTS="hosts.txt"
USER="username"
SSHPASS=$(gpg --passphrase-file .passphrase.txt -d .pass.txt.gpg)
```
**HOSTS:** This variable has the text file path with all the destination servers.
**USER:** This variable will have the username that we will need to connect to servers.
**SSHPASS:**  It will decrypt password that we stored and it will be used to connect to servers
