#!/bin/bash

# export PS1="\e[m\e[0;37m[\W]\e[m";
function _my_rvm_ruby_version {
  local gemset=$(echo $GEM_HOME | awk -F'@' '{print $2}')
  [ "$gemset" != "" ] && echo "[@$gemset]"
}

# http://nuts-and-bolts-of-cakephp.com/2010/11/27/show-git-branch-in-your-bash-prompt/
function _parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'
}

bash_prompt() {
  local W="\[\033[0;37m\]"
  local R="\[\033[0;31m\]"
  PS1="$R\$(_my_rvm_ruby_version)$W[\W]$R\$(_parse_git_branch)\e[m"
}

bash_prompt
unset bash_prompt


# History Tweaks
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000

# source ~/.bash_git_ps1.sh
source ~/.bash_rc

# Bash completion
source /Users/omar/.rvm/scripts/completion

# Pulling remote updates from a specific branch to current branch
# git pull origin <specific branch>
# i.e. $ gp master 
gp () {
  echo "==> git pull origin" $1
  git pull origin $1
}

# Pushing local updates from a specific branch to remote
# git push origin <specific branch>
# i.e. $ gpu master 
gpu () {
  echo "==> git push origin" $1
  git push origin $1
}

# For updating the current branch
# git pull origin <specific branch 1> & git push origin <specific branch 1>
# i.e. $ gu master
gu () {
  echo "==> git pull origin" $1
  git pull origin $1
  if [ $? -ne 0 ] ; then
    echo "==> Can't intiate PUSH, revise local repo"
  else 
    echo "==> git push origin" $1
    git push origin $1
  fi
}

# Merge branch 'a' to branch 'b'
# i.e. gmb master deploy
gmb () {
  if [[ $1 && $2 ]] ; then

    # Remember the branch the user was on
    local current_branch=`git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`;
    # Make it pretty with some colors
    local R="\033[0;31m"
    local W="\033[0;37m"

    # Checkout the $1 and update it
    echo -e "\n$R==> git checkout" $1 $W
    git checkout $1
    # Check if the 'git checkout' was succesfull 
    if [ $? -ne 0 ] ; then
      echo -e "\n$R==> Cannot proceed, double check your repo and make sure you have committed all your changes. \n Also check if the branch you speicified exists." $W
      else 
      echo -e "\n$R==> git pull origin" $1 $W
      git pull origin $1
      echo -e "\n$R==> git push origin" $1 $W
      git push origin $1

      # Checkout $2 and update then merge $1 into it
      echo -e "\n$R==> git checkout" $2 $W
      git checkout $2
      if [ $? -ne 0 ] ; then
        echo -e "\n$R==> Cannot proceed, double check your repo and make sure you have committed all your changes. \n Also check if the branch you speicified exists." $W
      else 
        echo -e "\n$R==> git pull origin" $2 $W
        git pull origin $2
        echo -e "\n$R==> git merge" $1 $W
        git merge $1
        echo -e "\n$R==> git push origin" $2 $W
        git push origin $2
        
        echo -e "\n$R==> git checkout" $current_branch $W
        git checkout $current_branch;
      fi
    fi
    
    else
    echo "Please specifiy two branchs. i.e. \$ gmhellb master deploy"
  fi
}

# Lists file in more clear format
# Stands for: Super ls
sls () {
  ls -A1p
}
#- end