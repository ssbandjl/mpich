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

# build with daos
mkdir build;cd build/
LD_LIBRARY_PATH=/root/project/stor/daos/install/prereq/debug/ofi/lib:/root/project/stor/daos/install/lib64 \
LDFLAGS="-Wl,-rpath -Wl,/root/project/stor/daos/install/prereq/debug/ofi/lib:/root/project/stor/daos/install/lib64" \
LIBRARY_PATH=/root/project/stor/daos/install/lib64:/root/project/stor/daos/install/prereq/debug/ofi/lib:$LIBRARY_PATH \
../configure --prefix=$PREFIX --enable-fortran=all --enable-romio \
 --enable-cxx --enable-g=all --enable-debuginfo --with-device=ch3:nemesis:ofi \
 --with-file-system=ufs+daos --with-daos=/root/project/stor/daos/install \
 --with-ofi=/root/project/stor/daos/install/prereq/debug/ofi

make -j64 V=1 2>&1 | tee make_log
 
make install 2>&1 | tee make_install_log


# config to .bashrc
PREFIX=/root/project/hpc/mpi/daos/mpich-3.4.3/install
export PATH="$PREFIX/bin:$PATH"
export LD_LIBRARY_PATH="$PREFIX/lib:$LD_LIBRARY_PATH"
export INCLUDE="$PREFIX/include:$INCLUDE"


export ROMIO_FSTYPE_FORCE="daos:"

