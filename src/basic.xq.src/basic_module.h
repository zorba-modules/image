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

#ifndef ZORBA_IMAGEMODULE_BASICMODULE_BASICMODULE_H
#define ZORBA_IMAGEMODULE_BASICMODULE_BASICMODULE_H

#include <map>

#include <zorba/zorba.h>
#include <zorba/external_module.h>
#include "image_module.h"

namespace zorba {  namespace imagemodule { namespace basicmodule {

class BasicModule : public ImageModule 
{

  virtual ExternalFunction*
  getExternalFunction(const String& aLocalname);
 

  virtual String
  getURI() const { return "http://zorba.io/modules/image/basic"; }

};

} /* namespace basicmodule */
} /* namespace imagemodule */ 
} /* namespace zorba */

#endif /* ZORBA_IMAGEMODULE_BASICMODULE_BASICMODULE_H */
