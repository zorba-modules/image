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
      VERSION 2.0 FILE "basic.xq"
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

    # this could crash because of the ImageMagick version
    # must be compiled in debug mode
    SET (KNOWN_CRASHES)
    IF (WIN32)
      IF (CMAKE_BUILD_TYPE STREQUAL "Debug")
        LIST (APPEND KNOWN_CRASHES
          zorba_image_module/image/basic.xq 867693
          zorba_image_module/image/basic_convert.xq 867693
          zorba_image_module/image/basic_create.xq 867693
          zorba_image_module/image/paint_1.xq 867693
          zorba_image_module/image/paint_2.xq 867693
          zorba_image_module/image/paint_3.xq 867693
          zorba_image_module/image/paint_4.xq 867693
          zorba_image_module/image/paint_5.xq 867693
          zorba_image_module/image/paint_6.xq 867693
          zorba_image_module/image/paint_circles.xq 867693
          zorba_image_module/image/paint_different_lines.xq 867693
          zorba_image_module/image/paint_polygon.xq 867693
          zorba_image_module/image/paint_polyline.xq 867693
          zorba_image_module/image/paint_rectangles.xq 867693
          zorba_image_module/image/paint_stroked_polyline.xq 867693
          zorba_image_module/image/paint_text.xq 867693
        )
      ENDIF (CMAKE_BUILD_TYPE STREQUAL "Debug")
    ENDIF (WIN32)

    ADD_TEST_DIRECTORY ("${PROJECT_SOURCE_DIR}/test" "${KNOWN_CRASHES}")
    
  ELSE (ImageMagick_FOUND)
    MESSAGE(STATUS "Magick++   component found: ${ImageMagick_Magick++_FOUND}")
    MESSAGE(STATUS "MagickCore component found: ${ImageMagick_MagickCore_FOUND}")
    MESSAGE(STATUS "MagickWand component found: ${ImageMagick_MagickWand_FOUND}") 
    MESSAGE(STATUS "If you want to use image handling functionality please install the ImageMagick library containing these 3 components: Magick++, MagickCore, MagickWand.\n Please note that on some OS\n- ImageMagick and\n- libMagick++ (on OpenSuse) or ImageMagick-c++(on Fedora)\n are 2 different packages and you need to install both of them and additionally their development packages.")
  ENDIF (ImageMagick_FOUND)
ENDIF(ZORBA_SUPPRESS_ImageMagick)
MESSAGE(STATUS "") 
