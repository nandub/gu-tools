# Chingu Git Tools

I kept repeating the same commands over and over, every time I created new branches.  To make my Chingu workflow easier I created these commands.

I made the commands based from this article: https://github.com/Chingu-cohorts/voyage-wiki/wiki/ProjSetup-Git-Workflow  

Why? because I can and I like to share what I have learned with git.

## Install Git

-   Following the instructions from https://git-scm.com/downloads, they have for Windows, Mac and Linux.

## Install Tools

    git clone https://github.com/nandub/gu-tools.git
    cd gu-tools
    cp g* $HOME/bin

    Or

    cp g* /usr/local/bin

    Or copy them to a place reachable from $PATH.

## Usage

`gprune` command
```sh
gprune #calling it by itself, will fetch and prune deleted branches from origin.
gprune <branch-name> #calling it like this, will delete the specified branch from origin then will fetch and prune and deletes the local branch.
```

`gucr` command
```sh
gucr [new] [base:development]
     new:  Name of branch to create.
     base: Name of branch to base/create from.
```
`gume` command
```sh
gume [current:.] [base:development]
     current: Name of branch to merge into.
     base:    Name of branch to base/merge from.
```
`gucl` command
```sh
gucl [clean] [base:development]
     clean: Name of branch to clean.
     base: Name of branch to base from.
```
