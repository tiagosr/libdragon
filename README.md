# Libdragon

This is a simple library for N64 that allows one to code using the gcc compiler suite and nothing else. No proprietary library is needed.

To make managing the toolcain easier, a docker container is used. Node.js is used to interact with the docker container for multi-platform support. You can inspect index.js if you prefer not to use node, but it makes things easier in general when working with docker.

On a machine with node.js (>= 7.6) & docker you can simply do;

    npm run tc -- download

to download the toolchain image from docker repository. The `--` is necessary for npm parameters to work. If you instead prefer to build it on your computer do;

    npm run tc -- init

This will build and start the container and may take a while as it will initialize the docker container and build the toolchain from scratch.

Then you will be able to work on the files simultaneously with the container and any built binaries will be available in your workspace as it is mounted on the container.
You will need to share your working drive from docker UI for it to be able to access your workspace for Windows hosts.

You can also start / stop the docker container using;

    npm run tc -- start
    npm run tc -- stop

To build the examples do;

    npm run tc -- make examples

Toolchain wrapper can also run make inside the container for you with the make command;

e.g to run clean all on root;

    npm run tc -- make clean

The toolchain make command will be only run at the root-level. Use -C flag to make a directory instead;

    npm run tc -- make -C your/path

Please note that the path should be unix-compatible, so you should not use auto completion on non-unix systems.

If you export `N64_BYTE_SWAP` environment variable with a value of true (`export N64_BYTE_SWAP=true`), you can generate byte-swapped `.v64` rom files. If this is not present the Makefiles will default to not swapped `.z64` files.

To use the toolchain's host make command with byte swap enabled, pass a make variable like so;

    npm run tc -- make examples N64_BYTE_SWAP=true

You can also permanently set `BYTE_SWAP` for docker container in `index.js` and stop/start it for changes to take effect.

If you need more control over the toolchain container bash into it with;

    docker exec -i -t libdragon /bin/bash

You can copy `index.js` and `package.json` to your root path in order to use docker in your other N64 projects. Simply change `PROJECT_NAME` variable and toolchain will be available as a new container for your project when you run `npm run tc -- start` in your project root.

# RSP assembly

Libdragon uses assembly macros to program the RSP chip defined in `ucode.S`. These mainly wrap `cop2`, `lwc2` and `swc2` instructions.

The syntax is similar to that of Nintendo's but with a few changes. For example if we take `vabs` instruction;

    vabs vd, vs, vt[e]

it becomes;

    vabs vd, vs, vt, e

and element (`e`) is always required. It is also similar for load/store instructions. As an example, `sbv` instruction;

    sbv vt[element], offset(base)

becomes;

    sbv vt, element, offset, base

Basically all operands are required and separated by commas.

While using these custom instructions, you should use `v0`-`v31`for naming vector registers and `s0`-`s31` for naming scalar registers.

# Original documentation for reference

To get started from scratch, follow the following steps:

1. Create a directory and copy the build script there from the tools/ directory.
2. Read the comments in the build script to see what additional packages are needed.
3. Run ./build from the created directory, let it build and install the toolchain.
4. Make libdragon by typing 'make' at the top level.
5. Install libdragon by typing 'make install' at the top level.
6. Install libpng-dev if not already installed.
7. Make the tools by typing 'make tools' at the top level.
8. Install the tools by typing 'make tools-install' at the top level.
9. Compile the examples by typing 'make examples' at the top level.

You are now ready to run the examples on your N64.
For more information, visit http://www.dragonminded.com/n64dev/
