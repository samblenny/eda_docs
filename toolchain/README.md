# Building the YosysHQ iCE40 Toolchain

This is tested for Ubuntu 20.04 (focal). Might work elsewhere. Might not.


## Commit Hashes

These were taken with `git rev-parse HEAD` on 2021-06-13.

| repo             | commit                                   |
|------------------|------------------------------------------|
| yosysHQ/icestorm | c495861c19bd0976c88d4964f912abe76f3901c3 |
| yosysHQ/nextpnr  | ee65e6f32d669cabd1d8a00534410da423348ac4 |
| yosysHQ/yosys    | 438bcc68c0859057e4d3f521d1c865d2a9d90e15 |
| yosysHQ/abc      | 4f5f73d18b137930fb3048c0b385c82fa078db38 |


## Install Required Build Dependency Packages

The `check_deps.py` script checks for the set union of required packages for
yosys, nextpnr, and icestorm, and recommends an apt command to install missing
packages. It's possible mercurial may be be a leftover from when yosys cloned
abc from a mercurial repo, but now abc comes from git.

1. Pick some place to keep the build tree, such as `~/fpga`
2. Copy the `check_deps.py` script there
3. `sudo apt install python3` if you don't already have it
4. Run `check_deps.py` and install missing packages, if needed.

For example:
```
cd ~/fpga
./check_deps.py
# ...
sudo apt update && sudo apt install bison clang cmake flex gawk \
  libboost-all-dev libeigen3-dev libffi-dev libftdi-dev libreadline-dev \
  mercurial python3-dev qt5-default tcl-dev xdot
```


## Build Project IceStorm tools

See http://www.clifford.at/icestorm/

```
# start from root of build tree, maybe ~/fpga, or whatever
git clone https://github.com/YosysHQ/icestorm.git
git rev-parse HEAD
# c495861c19bd0976c88d4964f912abe76f3901c3
cd icestorm
make -j$(nproc)
sudo make install
# creates:
# /usr/local/share/icebox/*.txt
# /usr/local/bin/icebox*
# /usr/local/bin/ice{pack,multi,pll,bram,box}
cd ..
```


## Build Nextpnr

See https://github.com/YosysHQ/nextpnr#nextpnr-ice40 and
https://github.com/YosysHQ/nextpnr#gui

```
git clone https://github.com/YosysHQ/nextpnr
git rev-parse HEAD
# ee65e6f32d669cabd1d8a00534410da423348ac4
cd nextpnr
cmake . -DARCH=ice40 -DBUILD_GUI=ON
make -j$(nproc)
sudo make install
# creates: /usr/local/bin/nextpnr-ice40
cd ..
```


## Build Yosys

See https://github.com/YosysHQ/yosys#setup

```
git clone https://github.com/YosysHQ/yosys.git
git rev-parse HEAD
# 438bcc68c0859057e4d3f521d1c865d2a9d90e15
cd yosys
make
sudo make install
# creates: /usr/local/bin/yosys{,-config,-abc,-filterlib,-smt-bmc}
cd abc
git rev-parse HEAD
# 4f5f73d18b137930fb3048c0b385c82fa078db38
cd ../..
```

Excerpt of `make` output showing the commit used for `abc`:
```
Pulling ABC from https://github.com/YosysHQ/abc
+ git clone https://github.com/YosysHQ/abc abc
...
+ git checkout 4f5f73d
...
HEAD is now at 4f5f73d1 Merge pull request #8 from cr1901/dep-ccache
```


## Version Checks

```
$ yosys --version
Yosys 0.9+4081 (git sha1 438bcc68, clang 10.0.0-4ubuntu1 -fPIC -Os)
$ nextpnr-ice40 --version
nextpnr-ice40 -- Next Generation Place and Route (Version ee65e6f3)
```
