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
IF (ImageMagick_FOUND)
  ADD_LIBRARY(image_commons STATIC image.xq.src/image_function.cpp
    image.xq.src/image_module.cpp) 
  ADD_LIBRARY(image_c STATIC image_c.src/draw_in_c.cpp) 
  TARGET_LINK_LIBRARIES(image_commons ${ImageMagick_LIBRARIES})
  INCLUDE_DIRECTORIES("image.xq.src")
  INCLUDE_DIRECTORIES("image_c.src")
  GENERATE_MODULE_LIBRARY(basic
    "image_c;image_commons;${ImageMagick_LIBRARIES}")
  GENERATE_MODULE_LIBRARY(manipulation
    "image_commons;${ImageMagick_LIBRARIES}")
  GENERATE_MODULE_LIBRARY(paint
    "image_c;image_commons;${ImageMagick_LIBRARIES}")
  GENERATE_MODULE_LIBRARY(animation
    "image_commons;${ImageMagick_LIBRARIES}")
ENDIF (ImageMagick_FOUND)

########################################################################
# Graphviz
########################################################################
IF (Graphiz_FOUND)
  INCLUDE_DIRECTORIES("graphviz.xq.src")
  GENERATE_MODULE_LIBRARY(graphviz "${GRAPHVIZ_LIBRARIES}")
ENDIF (Graphiz_FOUND)