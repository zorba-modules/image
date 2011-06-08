/*
 * Copyright 2006-2008 The FLWOR Foundation.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "basic.h"
#include "basic_module.h"

namespace zorba { namespace imagemodule { namespace basicmodule {

  
ExternalFunction*
BasicModule::getExternalFunction(const String& aLocalname)
{
  ExternalFunction*& lFunc = theFunctions[aLocalname];
  if (!lFunc) {
    if (1 == 0) {
    } else if (aLocalname == "width") {
      lFunc = new WidthFunction(this);
    } else if (aLocalname == "height") {
      lFunc = new HeightFunction(this);
    } else if (aLocalname == "type") {
      lFunc = new TypeFunction(this);
    } else if (aLocalname == "convert-impl") {
      lFunc = new ConvertFunction(this);
    } else if (aLocalname == "compress") {
      lFunc = new CompressFunction(this);
    } else if (aLocalname == "create-impl") {
      lFunc = new CreateFunction(this); 
    } else if (aLocalname == "equals") {
      lFunc = new EqualsFunction(this);
    } else if (aLocalname == "exif") {
      lFunc = new ExifFunction(this);
    } else if (aLocalname == "convert-svg-impl") {
      lFunc = new ConvertSVGFunction(this);
    } 
  }
  return lFunc;
}

} /* namespace basicmodule */ } /* namespace imagemodule */ } /* namespace zorba */
