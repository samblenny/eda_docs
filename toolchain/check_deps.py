#!/usr/bin/python3
# Check dependencies for building yosys/nextpnr/icestorm tools
# - Procedure tested on Ubuntu 20.04 LTS (focal), YMMV on other distros
# - You may need to do a `sudo apt install python3` to run this

import subprocess
import re

# See http://www.clifford.at/icestorm/
# These also work for nextpnr
required_icestorm = set([
  "build-essential", "clang", "bison", "flex", "libreadline-dev", "gawk",
  "tcl-dev", "libffi-dev", "git", "mercurial", "graphviz", "xdot", "pkg-config",
  "python", "python3", "libftdi-dev", "qt5-default", "python3-dev",
  "libboost-all-dev", "cmake", "libeigen3-dev"
  ])
# See https://github.com/YosysHQ/yosys#setup
required_yosys = set([
  "build-essential", "clang", "bison", "flex", "libreadline-dev", "gawk",
  "tcl-dev", "libffi-dev", "git", "graphviz", "xdot", "pkg-config", "python3",
  "libboost-system-dev", "libboost-python-dev", "libboost-filesystem-dev", "zlib1g-dev"
  ])
required_packages = sorted(list(required_icestorm | required_yosys))

# Call dpkg to get list of the currently installed packages
dpkg_result = subprocess.run(["dpkg", "--get-selections"], capture_output=True)
dpkg_out = dpkg_result.stdout.decode("utf-8")
installed_packages = [line for line in dpkg_out.split("\n")]

# Check for required packages:
# 1. Print status of each package
# 2. Build list of missing packages
print("Checking for required packages to build icestorm/nextpnr/yosys")
missing = []
unsure = []
for pkg in required_packages:
  pattern = "{}.*".format(pkg)
  result = re.search(pattern, dpkg_out)
  if result is None:
    print("[ ] {}".format(pkg))
    missing.append(pkg)
  else:
    match = result.group().strip().replace("\t", "\\t")
    if re.search("deinstall", match):
      print("[ ] {} (marked deinstall)".format(pkg))
      missing.append(pkg)
    elif re.search("install", match):
      print("[x] {}".format(pkg))
    else:
      print("??? {} (match=\"{}\")".format(pkg, match))
      unsure.append(pkg)

# Suggest `apt install ...` if needed
if len(unsure) > 0:
  print("Unexpected output from dpkg... unsure about packages")
elif len(missing) > 0:
  print("You are missing required packages")
  print("Recommended install procedure:")
  print("sudo apt update && sudo apt install {}".format(" ".join(missing)))
else:
  print("You have the required packages")

