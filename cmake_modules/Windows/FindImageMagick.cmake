# Copyright 2010 The FLWOR Foundation.
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

# - Try to find the ImageMagick lib on Windows
#
# This is a proxy module that calls the FindImageMagick.cmake module.
#
# See the FindImageMagick.cmake module shipped with Zorba for more information.

FIND_PACKAGE_WIN32 (
  NAME "ImageMagick"
  FOUND_VAR "ImageMagick_FOUND"
  SEARCH_NAMES "ImageMagick"
  COMPONENTS Magick++ MagickCore MagickWand
)

IF (ImageMagick_FOUND)

  # find the needed DLL's
  FIND_PACKAGE_DLL_WIN32 (${FOUND_LOCATION} "CORE_RL_bzlib_")
  FIND_PACKAGE_DLL_WIN32 (${FOUND_LOCATION} "CORE_RL_jbig_")
  FIND_PACKAGE_DLL_WIN32 (${FOUND_LOCATION} "CORE_RL_jp2_")
  FIND_PACKAGE_DLL_WIN32 (${FOUND_LOCATION} "CORE_RL_jpeg_")
  FIND_PACKAGE_DLL_WIN32 (${FOUND_LOCATION} "CORE_RL_lcms_")
  FIND_PACKAGE_DLL_WIN32 (${FOUND_LOCATION} "CORE_RL_libxml_")
  FIND_PACKAGE_DLL_WIN32 (${FOUND_LOCATION} "CORE_RL_Magick++_")
  FIND_PACKAGE_DLL_WIN32 (${FOUND_LOCATION} "CORE_RL_magick_")
  FIND_PACKAGE_DLL_WIN32 (${FOUND_LOCATION} "CORE_RL_png_")
  FIND_PACKAGE_DLL_WIN32 (${FOUND_LOCATION} "CORE_RL_tiff_")
  FIND_PACKAGE_DLL_WIN32 (${FOUND_LOCATION} "CORE_RL_ttf_")
  FIND_PACKAGE_DLL_WIN32 (${FOUND_LOCATION} "CORE_RL_wand_")
  FIND_PACKAGE_DLL_WIN32 (${FOUND_LOCATION} "CORE_RL_xlib_")
  FIND_PACKAGE_DLL_WIN32 (${FOUND_LOCATION} "CORE_RL_zlib_")

  FIND_PACKAGE_DLL_WIN32 (${FOUND_LOCATION} "X11")

ENDIF (ImageMagick_FOUND)
