# If tools directory exists, we've already ran so just exit

# Check to see if u-boot submodules have been initialized, and if not, initialize them
if [ ! -f ".gitmodules" ]; then
    echo "git submodules not initialized, initializing"
    git submodule init
    git submodule update
fi

if [ -d "tools" ]; then
    echo "tools directory already exists, exiting"
    exit 0
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    ARM_COMPILER_PATH="https://developer.arm.com/-/media/Files/downloads/gnu/12.3.rel1/binrel/arm-gnu-toolchain-12.3.rel1-darwin-x86_64-aarch64-none-elf.tar.xz?rev=78193d7740294ebe8dbaa671bb5011b2&hash=E7F05DCCE90B0833CD1E1818AD6E3CF1D4FBFEDD"
    ARM_COMPILER_SHA256="a3b5795cbf6ad4c6beacbacd0d7b4b98c9ea8c6b91f40c9a40a20753e749712b"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "I forgor linux"
    exit 1
else
    echo "get lost"
    exit 1
fi

# ARM_COMPILER_PATH contains the filename of the archive, but then theres a ? and a bunch of other stuff
# Use sed to remove everything after the ? and use the last part of the path as the filename
ARM_COMPILER_FILENAME=$(echo $ARM_COMPILER_PATH | sed 's/\?.*//g' | sed 's/.*\///g')
echo $ARM_COMPILER_FILENAME

# Make tools/tmp directory and then use curl to download the compiler but also use -L to follow redirects
mkdir -p tools/tmp
curl -L $ARM_COMPILER_PATH -o tools/tmp/$ARM_COMPILER_FILENAME

# Check the sha256sum of the downloaded file against ARM_COMPILER_SHA256
if [ $(shasum -a 256 tools/tmp/$ARM_COMPILER_FILENAME | awk '{print $1}') != $ARM_COMPILER_SHA256 ]; then
    echo "sha256sum of downloaded file does not match expected value"
    exit 1
fi

# Extract the archive
tar -xf tools/tmp/$ARM_COMPILER_FILENAME -C tools

# Cleanup tmp
rm -rf tools/tmp
