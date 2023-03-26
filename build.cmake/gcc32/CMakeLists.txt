#------------------------------------------------------------------------------------------
#       CMAKELists.txt construct to generate an application on Linux with gcc 32 bits
#------------------------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.9.1)
# Toolchain File

# the name of the target operating system
set(CMAKE_SYSTEM_NAME Linux)

# which compilers to use for C and C++
set(CMAKE_C_COMPILER gcc)
# set(CMAKE_C_FLAGS -m32)
set(CMAKE_CXX_COMPILER g++)
# set(CMAKE_CXX_FLAGS -m32)

if(${CMAKE_BUILD_TYPE} MATCHES Debug)
    message("CMAKE Debug Build for GCC 11.3.0 32 bits included in Linux Mint 21.1 Vera")
	set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -g -DDEBUG -D_DEBUG -std=c11")
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bingcc32/Debug")
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bingcc32/Debug")
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bingcc32/Debug")
#	set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} -llibstdc++")	
elseif(${CMAKE_BUILD_TYPE} MATCHES Release)
    message("CMAKE Release Build for GCC 11.3.0 32 bits included in Linux Mint 21.1 Vera")
	set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -s -DNDEBUG -std=c11")
	set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bingcc32/Release")
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bingcc32/Release")
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bingcc32/Release")
#	set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} -llibstdc++")	
endif()


file(GLOB SRC_FILES src/*.c)
# set(APPLI ${NAME_APPLI})

project(${NAME_APPLI}
        LANGUAGES C)
add_executable(${PROJECT_NAME} ${SRC_FILES})

set_target_properties(${PROJECT_NAME} PROPERTIES COMPILE_OPTIONS "-m32" LINK_FLAGS "-m32" OUTPUT_NAME "${NAME_APPLI}" SUFFIX ".exe")

target_link_libraries(${PROJECT_NAME} PUBLIC "GL" "glut" "GLU" "m")
