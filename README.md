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

    PREFIX=$HOME/bin ./install.sh
    ./install.sh #defaults to /usr/local/bin

    Or

    curl -s https://install-gu-tools.now.sh | sh -s -- --prefix=PREFIX=$HOME --version=v0.0.3

## Usage

`gprune` command

```sh
gprune v0.0.1

gprune prune / delete remote branches and
prune / delete local branches no longer on remote.

Usage: gprune [-h] [branch]

    -h         Show this usage
    branch     Name of branch to delete.
```

`gucr` command

```sh
gucr v0.0.1

gucr creates new branches based from a specified branch or
from default development branch.

Usage: gucr [new] [base:development]

    new:     Name of branch to create.
    base:    Name of branch to base/create from.
```

`gume` command

```sh
gume v0.0.1

gume merge or rebase a branch based from
 a specified branch or from default development branch.

Usage: gume [current:.] [base:development]

    current:   Name of branch to merge into.
    base:      Name of branch to base/merge from.
```

`gucl` command WARNING: This command will destroy the selected branch a replace with a new copy based from development (default).

```sh
gucl v0.0.1

gucl deletes and recreate a branch based from
a specified branch or from default development branch.

Usage: gucl [clean] [base:development]

    clean:   Name of branch to clean.
    base:    Name of branch to base/create from.
```

## TODO

-   Convert these bash commands into something more portable, maybe using `nodejs` or `oclif (typescript)`.
