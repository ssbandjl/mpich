To build MPICH, including ROMIO with the DAOS ADIO driver:

export MPI_LIB=""

# to clone the latest development snapshot:
git clone https://github.com/pmodels/mpich
cd mpich

# to clone a specific tagged version:
git clone -b v3.4.3 https://github.com/pmodels/mpich mpich-3.4.3
cd mpich-3.4.3

git submodule update --init

./autogen.sh

PREFIX=$HOME/software/mpich
# or PREFIX=$HOME/software/mpich-3.4.3 for a specific tagged version
mkdir -p $PREFIX

./configure --prefix=$PREFIX --enable-fortran=all --enable-romio \
 --enable-cxx --enable-g=all --enable-debuginfo --with-device=ch3:nemesis \
 --with-file-system=ufs+daos --with-daos=/usr

# compiling 3.4.3 may need FFLAGS=-fallow-argument-mismatch on the configure command line

make -j8; make install




./autogen.sh
mkdir build; cd build


old:
# ../configure --prefix=dir --enable-fortran=all --enable-romio --enable-cxx --enable-g=all --enable-debuginfo --with-file-system=ufs+daos --with-daos=dir --with-cart=dir
# add also --with-device=ch3:sock To be able to run with PSM2 provider we need to force mpich to use sockets instead of PSM2
# make -j8; make install
# Switch PATH and LD_LIBRARY_PATH where you want to build your client apps or libs that use MPI to the above installed MPICH

../configure --with-libfabric 

../configure --prefix=/root/project/hpc/mpi/mpich/mpich-install --with-ofi=/root/project/stor/daos/build/external/debug/ofi --enable-debuginfo --with-file-system=ufs+daos --with-daos=/root/project/stor/daos/install 2>&1 | tee c.txt

PREFIX=/root/project/hpc/mpi/daos/mpich-3.4.3/install
mkdir -p $PREFIX

mkdir build
cd build

set run env:
LD_LIBRARY_PATH=/root/project/stor/daos/install/lib64:$LD_LIBRARY_PATH
LD_LIBRARY_PATH=/root/project/stor/daos/install/prereq/debug/ofi/lib:$LD_LIBRARY_PATH

set build env:
CPPFLAGS="-I/include/path"
LDFLAGS="-L/root/project/stor/daos/install/lib64"

LD_LIBRARY_PATH=/root/project/stor/daos/install/prereq/debug/ofi/lib:/root/project/stor/daos/install/lib64 \
LDFLAGS="-Wl,-rpath -Wl,/root/project/stor/daos/install/prereq/debug/ofi/lib:/root/project/stor/daos/install/lib64" \
LIBRARY_PATH=/root/project/stor/daos/install/lib64:/root/project/stor/daos/install/prereq/debug/ofi/lib:$LIBRARY_PATH \
../configure --prefix=$PREFIX --enable-fortran=all --enable-romio \
 --enable-cxx --enable-g=all --enable-debuginfo --with-device=ch3:nemesis:ofi \
 --with-file-system=ufs+daos --with-daos=/root/project/stor/daos/install \
 --with-ofi=/root/project/stor/daos/install/prereq/debug/ofi

make -j64 V=1 2>&1 | tee m.txt
 
make install 2>&1 | tee mi.txt


PREFIX=/root/project/hpc/mpi/daos/mpich-3.4.3/install
export PATH="$PREFIX/bin:$PATH"
export LD_LIBRARY_PATH="$PREFIX/lib:$LD_LIBRARY_PATH"
export INCLUDE="$PREFIX/include:$INCLUDE"


export ROMIO_FSTYPE_FORCE="daos:"

