shopt -s extglob

function asksure() {
  echo -n "Are you sure (Y/N)? "
  while read -r -n 1 -s answer; do
    if [[ $answer = [YyNn] ]]; then
      [[ $answer = [Yy] ]] && retval=0
      [[ $answer = [Nn] ]] && retval=1
      break
    fi
  done
  echo # just a final linefeed, optics...
  return $retval
}

function git_cleaning() {
  git fetch --prune > /dev/null 2>&1
  git branch -D $(git branch -vv | grep ': gone] ' | awk '{print $1}' | xargs) > /dev/null 2>&1
}

function remote_avail() {
  local remote=$1
  git remote show $remote >/dev/null 2>&1
  CODE=$?
  # code 128 means origin does not exist in the repo.
  if [ "$CODE" = "128" ]; then
    return 1
  fi
  return 0
}

function origin_avail() {
  if remote_avail origin; then return 0; else return 1; fi
}

# Check to see if the branch is on remote origin
# if not then allow to rebase current branch otherwise merge.
function branch_avail_on_remote() {
  local remote=$1
  local branch=$2
  if ! origin_avail; then return 1; fi
  git branch -vv | grep -w "$remote/$branch" | grep -v gone >/dev/null 2>&1
  #git remote show $remote | grep -w $branch >/dev/null 2>&1
  CODE=$?
  # code 0 means found branch on remote.
  return $CODE
}

if [ -z "${BASED_BRANCH-}" ]; then
  export BASED_BRANCH=development
fi
