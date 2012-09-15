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

#include "image_module.h"
#include <zorba/function.h>


namespace zorba { namespace imagemodule { 

  ItemFactory* ImageModule::theFactory = 0;

ImageModule::~ImageModule()
{
  for (FuncMap_t::const_iterator lIter = theFunctions.begin();
       lIter != theFunctions.end(); ++lIter) {
    delete lIter->second;
  }
  theFunctions.clear();
}

ExternalFunction*
ImageModule::getExternalFunction(const String& aLocalname)
{
  ExternalFunction*& lFunc = theFunctions[aLocalname];
  return lFunc;
}

void
ImageModule::destroy()
{
  if (!dynamic_cast<ImageModule*>(this)) {
    return;
  }
  delete this;
}

bool
ImageModule::isImageMagickAvailable() {
  bool result = false;
  #ifdef WIN32

  HKEY hKey;
  LONG lRes = RegOpenKeyExW(HKEY_LOCAL_MACHINE, L"SOFTWARE\\ImageMagick\\Current\\", 0, KEY_READ, &hKey);
  if (lRes != ERROR_SUCCESS) {
    lRes = RegOpenKeyExW(HKEY_LOCAL_MACHINE, L"SOFTWARE\\Wow6432Node\\ImageMagick\\Current\\", 0, KEY_READ, &hKey);
  }
  if (lRes == ERROR_SUCCESS) {
    std::wstring strKeyDefaultValue;

    WCHAR szBuffer[512];
    DWORD dwBufferSize = sizeof(szBuffer);
    ULONG nError = RegQueryValueExW(hKey, L"Version", NULL, NULL, (LPBYTE)szBuffer, &dwBufferSize);
    if (ERROR_SUCCESS == nError)
    {
        strKeyDefaultValue = szBuffer;  // ImageMagick Version
        result = true;
    }
    RegCloseKey(hKey);
  }
  #endif  //WIN32
  return result;
}


}  /* namespace imagemodule */ } /* namespace zorba */
