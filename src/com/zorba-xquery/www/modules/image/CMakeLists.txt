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

  ADD_TEST_DIRECTORY("${PROJECT_SOURCE_DIR}/test")
  
ENDIF (ImageMagick_FOUND)

########################################################################
# Graphviz
########################################################################
IF (GRAPHVIZ_FOUND)
  INCLUDE_DIRECTORIES("graphviz.xq.src")
  DECLARE_ZORBA_SCHEMA (URI "http://www.gupro.de/GXL/gxl-1.0.dtd"
    FILE gxl-1.0.xsd)
  DECLARE_ZORBA_MODULE (VERSION 1.0 FILE "graphviz.xq"
    URI "http://www.zorba-xquery.com/modules/image/graphviz"
    LINK_LIBRARIES "${GRAPHVIZ_LIBRARIES}")
  ADD_TEST_DIRECTORY("${PROJECT_SOURCE_DIR}/test_graphviz")

  EXPECTED_FAILURE(zorba_image_module/dot.xq 3360108)
ENDIF (GRAPHVIZ_FOUND)
