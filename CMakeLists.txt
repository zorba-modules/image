# Copyright 2006-2010 The FLWOR Foundation.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

CMAKE_MINIMUM_REQUIRED(VERSION 2.6)

PROJECT (zorba_image_module)
ENABLE_TESTING ()
INCLUDE (CTest)

# We ship our own version of FindImageMagick.cmake, since CMake didn't
# include one before 2.8
LIST (APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake_modules")

FIND_PACKAGE (Zorba REQUIRED HINTS "${ZORBA_BUILD_DIR}")
INCLUDE ("${Zorba_USE_FILE}")

########################################################################
# ImageMagick
########################################################################
FIND_PACKAGE(ImageMagick COMPONENTS Magick++ MagickCore MagickWand)

IF (ImageMagick_FOUND)
  MESSAGE(STATUS "Found ImageMagick include dirs ${ImageMagick_INCLUDE_DIRS}")
  MESSAGE(STATUS "Found ImageMagick libraries ${ImageMagick_LIBRARIES}")

  INCLUDE_DIRECTORIES("${ImageMagick_INCLUDE_DIRS}")

ELSE (ImageMagick_FOUND)
  MESSAGE(STATUS "Magick++   component found: ${ImageMagick_Magick++_FOUND}")
  MESSAGE(STATUS "MagickCore component found: ${ImageMagick_MagickCore_FOUND}")
  MESSAGE(STATUS "MagickWand component found: ${ImageMagick_MagickWand_FOUND}")

  MESSAGE(STATUS "If you want to use image handling functionality please install the ImageMagick library containing these 3 components: Magick++, MagickCore, MagickWand.\n Please note that on some OS\n- ImageMagick and\n- libMagick++ (on OpenSuse) or ImageMagick-c++(on Fedora)\n are 2 different packages and you need to install both of them and additionally their development packages.")
ENDIF (ImageMagick_FOUND)

########################################################################
# Graphviz
########################################################################
FIND_PACKAGE(Graphviz)
IF (GRAPHVIZ_FOUND)
  INCLUDE_DIRECTORIES(${GRAPHVIZ_INCLUDE_DIRS})
ELSE (GRAPHVIZ_FOUND)
  MESSAGE(STATUS "Could not find Graphviz library or development headers.")
ENDIF (GRAPHVIZ_FOUND)

ADD_SUBDIRECTORY("src")

# QQQ We should either: (a) Have separate test directories for
#  ImageMagick and graphviz, and add them as appropriate, or (b)
#  separate the graphviz module out entirely. This only works at the
#  moment because there are no graphviz tests (!).
ADD_TEST_DIRECTORY("${PROJECT_SOURCE_DIR}/test")

# include FindImageMagick.cmake if cmake version is smaller than 2.8
#IF (${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} LESS 2.8)
#  MESSAGE(STATUS "Including FindImageMagick.cmake for cmake version < 2.8")
#  INCLUDE(${PROJECT_SOURCE_DIR}/cmake_modules/FindImageMagick.cmake)     
#ENDIF (${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} LESS 2.8)
