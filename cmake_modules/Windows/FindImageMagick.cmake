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
# This is a proxy module that calls the FindGraphviz.cmake module. Before
# doing that, we try to guess where Graphviz might be on the user's machine.
# The user should provide ZORBA_THIRD_PARTY_REQUIREMENTS which is a path where
# the Graphviz directory can be found. The Graphviz directory must have "graphviz"
# (case insensitive) in its name.
#
# See the FindLibTidy.cmake module shipped with Zorba for more information.

FIND_PACKAGE_WIN32(NAME ImageMagick FOUND_VAR ImageMagick_FOUND SEARCH_NAMES ImageMagick COMPONENTS Magick++ MagickCore MagickWand)

IF (ImageMagick_FOUND)

  #find the needed DLL's
  FIND_PACKAGE_DLLS_WIN32 (${FOUND_LOCATION} "config/colors.xml;config/coder.xml;config/configure.xml;config/delegates.xml;config/english.xml;config/locale.xml;config/log.xml;config/magic.xml;config/mime.xml;config/thresholds.xml;config/type.xml;config/type-ghostscript.xml;CORE_RL_tiff_.dll;CORE_RL_png_.dll;CORE_RL_libxml_.dll;CORE_RL_jbig_.dll;CORE_RL_jp2_.dll;CORE_RL_jpeg_.dll;CORE_RL_Magick++_.dll;CORE_RL_bzlib_.dll;CORE_RL_lcms_.dll;CORE_RL_ttf_.dll;CORE_RL_xlib_.dll;CORE_RL_zlib_.dll;CORE_RL_magick_.dll;CORE_RL_wand_.dll")
  
ENDIF (ImageMagick_FOUND)  

 