# Chingu Git Tools

On my Chingu-Voyage6 bears project, I keep repeating the same git commands over and over every time I create new branches.  To make my Chingu workflow easier, I created these commands.

I made the commands based from this article: <https://github.com/Chingu-cohorts/voyage-wiki/wiki/ProjSetup-Git-Workflow>  

Why? because I can and I like to share what I have learned with git.

## Install Git

-   Following the instructions from <https://git-scm.com/downloads>, they have for Windows, Mac and Linux.

## Install Tools

    git clone https://github.com/nandub/gu-tools.git
    cd gu-tools

    if you have make and m4 do:

    make PREFIX=$HOME install
    make install #defaults to /usr/local/bin

    Or

    ./install.sh --prefix=$HOME
    ./install.sh #defaults to /usr/local/bin

    Or

    curl -sL https://install-gu-tools-nandub.nandub-gh.now.sh/v0.0.5 | sh #defaults to /usr/local/bin
    curl -sL https://install-gu-tools-nandub.nandub-gh.now.sh | sh -s --  --prefix=$HOME

## Usage

`gprune` command

```sh
gprune v0.1.0

gprune prune and delete remote branches and
prune and delete local branches no longer on remote.

Usage: gprune [-h] [[-b] branch] [-r remote]

    -h        Show this usage.
    branch: Name of branch to delete or prune.
    remote: Name of the remote to delete or prune from.
```

`gpush` command

```sh
gpush v0.1.0

gpush push branch to a remote branch.

Usage: gpush [-h] [-f] [[-b] branch] [-r remote]

    -h      Show this usage.
    -f      Force pushing to remote.
    branch: Name of the branch to push.
    remote: Name of the remote to push into.
```

`gucl` command WARNING: This command will destroy the selected branch a replace with a new copy based from development (default).

```sh
gucl v0.1.0

gucl deletes and recreate a branch based from
a specified branch or from default development branch.

Usage: gucl [-h] [[-R] recreate] [-r remote] [-b branch]

    -h        Show this usage.
    recreate: Name of the branch to delete and recreate.
    remote:   Name of the remote to base/create from.
    branch:   Name of the branch to base/create from.
```

`gucr` command

```sh
gucr v0.1.0

gucr creates new branches based from a specified branch or
from default development branch.

Usage: gucr [-h] [[-C] create] [-r remote] [-b branch]

    -h      Show this usage.
    create: Name of the branch to create.
    remote: Name of the remote to base/create from.
    branch: Name of the branch to base/create from.
```

`gume` command

```sh
gume v0.1.0

gume merge or rebase a branch based from
 a specified branch or from default development branch.

Usage: gume [-h] [[-M] merge,.] [-r remote] [-b branch]

    -h      Show this usage.
    merge:  Name of the branch to merge into.
    remote: Name of the remote to merge from.
    branch: Name of the branch to base/merge from.
```

## TODO

-   Convert these bash commands into something more portable, maybe using `nodejs` or `oclif (typescript)`.
