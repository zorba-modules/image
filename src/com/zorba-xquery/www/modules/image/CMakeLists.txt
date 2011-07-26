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
#

########################################################################
# ImageMagick
########################################################################
IF(ZORBA_SUPPRESS_ImageMagick)
  MESSAGE(STATUS "ZORBA_SUPPRESS_ImageMagick is true - not searching for ImageMagick.")  
ELSE(ZORBA_SUPPRESS_ImageMagick)
  MESSAGE (STATUS "Looking for ImageMagick")
  FIND_PACKAGE(ImageMagick COMPONENTS Magick++ MagickCore MagickWand)
  
  IF(ImageMagick_FOUND)
    MESSAGE(STATUS "Found ImageMagick include dirs ${ImageMagick_INCLUDE_DIRS}")
    MESSAGE(STATUS "Found ImageMagick libraries ${ImageMagick_LIBRARIES}")  
    INCLUDE_DIRECTORIES("${ImageMagick_INCLUDE_DIRS}")
    
    INCLUDE_DIRECTORIES("image_commons")
    INCLUDE_DIRECTORIES("image_draw")
    DECLARE_ZORBA_SCHEMA(FILE image.xsd
      URI "http://www.zorba-xquery.com/modules/image/image")
    DECLARE_ZORBA_MODULE(URI "http://www.zorba-xquery.com/modules/image/basic"
      VERSION 1.0 FILE "basic.xq"
      EXTRA_SOURCES image_commons image_draw
      LINK_LIBRARIES ${ImageMagick_LIBRARIES})
    DECLARE_ZORBA_MODULE(VERSION 1.0 FILE "manipulation.xq"
      URI "http://www.zorba-xquery.com/modules/image/manipulation"
      EXTRA_SOURCES image_commons
      LINK_LIBRARIES ${ImageMagick_LIBRARIES})
    DECLARE_ZORBA_MODULE(VERSION 1.0 FILE "paint.xq"
      URI "http://www.zorba-xquery.com/modules/image/paint"
      EXTRA_SOURCES image_draw image_commons
      LINK_LIBRARIES ${ImageMagick_LIBRARIES})
    DECLARE_ZORBA_MODULE(VERSION 1.0 FILE "animation.xq"
      URI "http://www.zorba-xquery.com/modules/image/animation"
      EXTRA_SOURCES image_commons
      LINK_LIBRARIES ${ImageMagick_LIBRARIES})
    DECLARE_ZORBA_MODULE(VERSION 1.0 FILE "error.xq"
      URI "http://www.zorba-xquery.com/modules/image/error")
    ADD_TEST_DIRECTORY("${PROJECT_SOURCE_DIR}/test")  
  ELSE (ImageMagick_FOUND)
    MESSAGE(STATUS "Magick++   component found: ${ImageMagick_Magick++_FOUND}")
    MESSAGE(STATUS "MagickCore component found: ${ImageMagick_MagickCore_FOUND}")
    MESSAGE(STATUS "MagickWand component found: ${ImageMagick_MagickWand_FOUND}") 
    MESSAGE(STATUS "If you want to use image handling functionality please install the ImageMagick library containing these 3 components: Magick++, MagickCore, MagickWand.\n Please note that on some OS\n- ImageMagick and\n- libMagick++ (on OpenSuse) or ImageMagick-c++(on Fedora)\n are 2 different packages and you need to install both of them and additionally their development packages.")
  ENDIF (ImageMagick_FOUND)
ENDIF(ZORBA_SUPPRESS_ImageMagick)
MESSAGE("")



########################################################################
# Graphviz
########################################################################
IF(ZORBA_SUPPRESS_GRAPHVIZ)
  MESSAGE(STATUS "ZORBA_SUPPRESS_Graphviz is true - not searching for Graphviz.")
ELSE (ZORBA_SUPPRESS_GRAPHVIZ)

  MESSAGE (STATUS "Looking for Graphviz")
  FIND_PACKAGE(Graphviz)
  
  IF (GRAPHVIZ_FOUND)
    MESSAGE(STATUS "Found Graphviz library -- "${GRAPHVIZ_LIBRARIES})
     
    INCLUDE_DIRECTORIES(${GRAPHVIZ_INCLUDE_DIRS})
    INCLUDE_DIRECTORIES("graphviz.xq.src")
    DECLARE_ZORBA_MODULE (VERSION 1.0 FILE "graphviz.xq"
      URI "http://www.zorba-xquery.com/modules/image/graphviz"  
      LINK_LIBRARIES "${GRAPHVIZ_LIBRARIES}")    
    
    ADD_TEST_DIRECTORY("${PROJECT_SOURCE_DIR}/test_graphviz")
    
  ELSE (GRAPHVIZ_FOUND)
    MESSAGE(STATUS "Graphviz library not found.")
  ENDIF (GRAPHVIZ_FOUND)
ENDIF (ZORBA_SUPPRESS_GRAPHVIZ)
MESSAGE("") 