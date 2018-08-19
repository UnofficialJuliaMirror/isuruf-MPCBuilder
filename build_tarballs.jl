# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build MPCBuilder
name = "MPC"
version = v"1.1.0"
sources = [
    "https://ftp.gnu.org/gnu/mpc/mpc-$version.tar.gz" =>
    "6985c538143c1208dcb1ac42cedad6ff52e267b47e5f970183a3e75125b43c2e",
]

# Bash recipe for building across all platforms

script = """cd mpc-$version
"""*raw"""
./configure --prefix=$prefix --host=$target --enable-shared --disable-static --with-gmp=$prefix --with-mpfr=$prefix
make
make install
"""
# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libmpc", :libmpc)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/JuliaMath/GMPBuilder/releases/download/v6.1.2-2/build_GMP.v6.1.2.jl"
    "https://github.com/JuliaMath/MPFRBuilder/releases/download/v4.0.1-3/build_MPFR.v4.0.1.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
