# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The program to use to edit the cache.
CMAKE_EDIT_COMMAND = /usr/bin/ccmake

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /nfs/bigeye/hieule/GOP/outsource/gop_1.3

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /nfs/bigeye/hieule/GOP/outsource/gop_1.3/build

# Include any dependencies generated for this target.
include external/libsvm-3.17/CMakeFiles/libsvm.dir/depend.make

# Include the progress variables for this target.
include external/libsvm-3.17/CMakeFiles/libsvm.dir/progress.make

# Include the compile flags for this target's objects.
include external/libsvm-3.17/CMakeFiles/libsvm.dir/flags.make

external/libsvm-3.17/CMakeFiles/libsvm.dir/svm.cpp.o: external/libsvm-3.17/CMakeFiles/libsvm.dir/flags.make
external/libsvm-3.17/CMakeFiles/libsvm.dir/svm.cpp.o: ../external/libsvm-3.17/svm.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /nfs/bigeye/hieule/GOP/outsource/gop_1.3/build/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object external/libsvm-3.17/CMakeFiles/libsvm.dir/svm.cpp.o"
	cd /nfs/bigeye/hieule/GOP/outsource/gop_1.3/build/external/libsvm-3.17 && /usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/libsvm.dir/svm.cpp.o -c /nfs/bigeye/hieule/GOP/outsource/gop_1.3/external/libsvm-3.17/svm.cpp

external/libsvm-3.17/CMakeFiles/libsvm.dir/svm.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/libsvm.dir/svm.cpp.i"
	cd /nfs/bigeye/hieule/GOP/outsource/gop_1.3/build/external/libsvm-3.17 && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /nfs/bigeye/hieule/GOP/outsource/gop_1.3/external/libsvm-3.17/svm.cpp > CMakeFiles/libsvm.dir/svm.cpp.i

external/libsvm-3.17/CMakeFiles/libsvm.dir/svm.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/libsvm.dir/svm.cpp.s"
	cd /nfs/bigeye/hieule/GOP/outsource/gop_1.3/build/external/libsvm-3.17 && /usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /nfs/bigeye/hieule/GOP/outsource/gop_1.3/external/libsvm-3.17/svm.cpp -o CMakeFiles/libsvm.dir/svm.cpp.s

external/libsvm-3.17/CMakeFiles/libsvm.dir/svm.cpp.o.requires:
.PHONY : external/libsvm-3.17/CMakeFiles/libsvm.dir/svm.cpp.o.requires

external/libsvm-3.17/CMakeFiles/libsvm.dir/svm.cpp.o.provides: external/libsvm-3.17/CMakeFiles/libsvm.dir/svm.cpp.o.requires
	$(MAKE) -f external/libsvm-3.17/CMakeFiles/libsvm.dir/build.make external/libsvm-3.17/CMakeFiles/libsvm.dir/svm.cpp.o.provides.build
.PHONY : external/libsvm-3.17/CMakeFiles/libsvm.dir/svm.cpp.o.provides

external/libsvm-3.17/CMakeFiles/libsvm.dir/svm.cpp.o.provides.build: external/libsvm-3.17/CMakeFiles/libsvm.dir/svm.cpp.o

# Object files for target libsvm
libsvm_OBJECTS = \
"CMakeFiles/libsvm.dir/svm.cpp.o"

# External object files for target libsvm
libsvm_EXTERNAL_OBJECTS =

external/libsvm-3.17/liblibsvm.a: external/libsvm-3.17/CMakeFiles/libsvm.dir/svm.cpp.o
external/libsvm-3.17/liblibsvm.a: external/libsvm-3.17/CMakeFiles/libsvm.dir/build.make
external/libsvm-3.17/liblibsvm.a: external/libsvm-3.17/CMakeFiles/libsvm.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX static library liblibsvm.a"
	cd /nfs/bigeye/hieule/GOP/outsource/gop_1.3/build/external/libsvm-3.17 && $(CMAKE_COMMAND) -P CMakeFiles/libsvm.dir/cmake_clean_target.cmake
	cd /nfs/bigeye/hieule/GOP/outsource/gop_1.3/build/external/libsvm-3.17 && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/libsvm.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
external/libsvm-3.17/CMakeFiles/libsvm.dir/build: external/libsvm-3.17/liblibsvm.a
.PHONY : external/libsvm-3.17/CMakeFiles/libsvm.dir/build

external/libsvm-3.17/CMakeFiles/libsvm.dir/requires: external/libsvm-3.17/CMakeFiles/libsvm.dir/svm.cpp.o.requires
.PHONY : external/libsvm-3.17/CMakeFiles/libsvm.dir/requires

external/libsvm-3.17/CMakeFiles/libsvm.dir/clean:
	cd /nfs/bigeye/hieule/GOP/outsource/gop_1.3/build/external/libsvm-3.17 && $(CMAKE_COMMAND) -P CMakeFiles/libsvm.dir/cmake_clean.cmake
.PHONY : external/libsvm-3.17/CMakeFiles/libsvm.dir/clean

external/libsvm-3.17/CMakeFiles/libsvm.dir/depend:
	cd /nfs/bigeye/hieule/GOP/outsource/gop_1.3/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /nfs/bigeye/hieule/GOP/outsource/gop_1.3 /nfs/bigeye/hieule/GOP/outsource/gop_1.3/external/libsvm-3.17 /nfs/bigeye/hieule/GOP/outsource/gop_1.3/build /nfs/bigeye/hieule/GOP/outsource/gop_1.3/build/external/libsvm-3.17 /nfs/bigeye/hieule/GOP/outsource/gop_1.3/build/external/libsvm-3.17/CMakeFiles/libsvm.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : external/libsvm-3.17/CMakeFiles/libsvm.dir/depend

