./autogen.sh
mkdir build; cd build


old:
# ../configure --prefix=dir --enable-fortran=all --enable-romio --enable-cxx --enable-g=all --enable-debuginfo --with-file-system=ufs+daos --with-daos=dir --with-cart=dir
# add also --with-device=ch3:sock To be able to run with PSM2 provider we need to force mpich to use sockets instead of PSM2
# make -j8; make install
# Switch PATH and LD_LIBRARY_PATH where you want to build your client apps or libs that use MPI to the above installed MPICH

../configure --with-libfabric 

../configure --prefix=/root/project/hpc/mpi/mpich/mpich-install --with-ofi=/root/project/stor/daos/build/external/debug/ofi --enable-debuginfo --with-file-system=ufs+daos --with-daos=/root/project/stor/daos/install 2>&1 | tee c.txt

make -j64 V=1 2>&1 | tee m.txt

make install 2>&1 | tee mi.txt
