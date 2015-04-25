# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Find libraries
function findlib () {
    for i in $(echo $LD_LIBRARY_PATH | sed -e 's/:/ /g'); do
        find $i -name lib$1\* 2>/dev/null
    done
    for i in $(cat /etc/ld.so.conf); do
        find $i -name lib$1\* 2>/dev/null
    done
}

# Set permissions world-readable
function worldread () {
    find . -print0 | xargs -0 chmod a+r
    find . -type d -print0 | xargs -0 chmod a+x
}

# Display git branch
function parse_git_branch {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "("${ref#refs/heads/}")"
}
RESET="\[\033[0;00m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
PURPLE="\[\033[0;35m\]"
PS1="$PURPLE\h:$GREEN\w$YELLOW \$(parse_git_branch)$RESET\$ "

# generate profile
function make_profile {
    if [[ $# -lt 3 ]]; then
        echo make_profile executable gmon.out output.png
        exit 1
    fi
    gprof $1 $2 | gprof2dot.py | dot -Tpng -o $3
}

# Find memory use of a process
function memory() {
    ps aux | grep $1 | grep -v grep | awk '{print $5}'
}

function memprofile {
    datfile=$(mktemp)
    echo "ElapsedTime MemUsed" > $datfile

    starttime=$(date +%s.%N)

    # Run the specified command in the background
    $@ &

    # While the last process is still going
    while [ -n "`ps --no-headers $!`" ]
    do
	    bytes=$(ps -o rss -p $! --no-headers | awk '{SUM += $1} END {print SUM}')
	    elapsed=$(echo $(date +%s.%N) - $starttime | bc)
	    if [ $bytes ]; then
		    echo $elapsed $bytes >> $datfile
	    fi
	    sleep 0.05
    done

    # Plot up the results with matplotlib
    cat <<EOF | python
import pylab, sys, numpy
infile = file("$datfile")
infile.readline() # skip first line
data = numpy.loadtxt(infile)
time,mem = data[:,0], data[:,1]/1024
pylab.plot(time,mem)
pylab.title("Profile of: """ "\"%s\" """ % "$@")
pylab.xlabel('Elapsed Time (s): Total %0.5f s' % time.max())
pylab.ylabel('Memory Used (MB): Peak %0.2f MB' % mem.max())
pylab.show()
EOF

    rm $datfile
}
