# Set editor
export EDITOR='emacs -nw'

# OpenMC setup
export CROSS_SECTIONS=/opt/data/ace/nndc/cross_sections.xml
export PATH=$HOME/openmc/src/build/bin:$PATH
if [ -z $PYTHONPATH ]; then
    export PYTHONPATH=~/openmc/src/utils
else
    export PYTHONPATH=$PYTHONPATH:~/openmc/src/utils
fi

# Intel compilers
if [ -n "$BASH_VERSION" ]; then
    source /opt/intel/composerxe/bin/compilervars.sh intel64
fi

# MCNP
export DATAPATH=/opt/mcnp/data

# Fudge
export PYTHONPATH=$HOME/fudge:$PYTHONPATH

# Debian packaging tools
export DEBFULLNAME="Paul Romano"
export DEBEMAIL="paul.k.romano@gmail.com"

# Add MPICH2 to path and library path
export PATH=/opt/mpich/3.1.4-gnu/bin:$PATH

# HDF5
hdf5dir=/opt/phdf5/1.8.13-gnu
export PATH=${hdf5dir}/bin:$PATH
export LD_LIBRARY_PATH=${hdf5dir}/lib:$LD_LIBRARY_PATH
