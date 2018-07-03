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
  git fetch --prune
  git branch -D $(git branch -vv | grep ': gone] ' | awk '{print $1}' | xargs)
}

function origin_avail() {
  git remote show origin >/dev/null 2>&1
  CODE=$?
  # code 128 means origin does not exist in the repo.
  if [ "$CODE" = "128" ]; then
    return 1
  fi
  return 0
}

# Check to see if the branch is on remote origin
# if not then allow to rebase current branch otherwise merge.
function branch_avail_on_origin() {
  local branch=$1
  if ! origin_avail; then return 1; fi
  git remote show origin | grep -w $branch >/dev/null 2>&1
  CODE=$?
  # code 0 means found branch on origin.
  return $CODE
}
