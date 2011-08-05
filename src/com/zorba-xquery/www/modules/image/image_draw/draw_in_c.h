/*
 * Copyright 2006-2011 The FLWOR Foundation.
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

#include <string> 


void *  
DrawPolygon(const void* aBlob, 
            long* aLength, 
            double aXValues[], 
            double aYValues[], 
            int aNumberOfPoints, 
            std::string& aStrokeColor, 
            std::string& aFillColor, 
            double aStrokeWidth, 
            bool aAntiAliasing); 

void *
DrawPolyLine(const void* aBlob, 
             long* aLength, 
             double aXValues[], 
             double aYValues[], 
             int aNumberOfPoints, 
             std::string& aStrokeColor, 
             double aStrokeWidth, 
             bool aAntiAliasing, 
             double aStrokeArray[], 
             int aNumberOfStrokeValues);


void *
DrawRoundedRect(const void* aBlob, 
                long *aLength, 
                double aUpperLeftX, 
                double aUpperLeftY, 
                double aLowerRightX, 
                double aLowerRightY, 
                double aCornerWidth, 
                double aCornerHeight, 
                std::string& aStrokeColor, 
                std::string& aFillColor, 
                double aStrokeWidth, 
                bool aAntiAliasing);


void *
DrawText(const void* aBlob, 
         long* aLength, 
         const char* aText,
         double aX, 
         double aY, 
         const char* aFont, 
         double aFontSize, 
         const char* aColor); 

std::string
GetImageType(const void* aBlob, long* aLength);

std::string
GetExifValue(const void* aBlob, long* aLength, std::string& aExifTag);


template<class T>
  class ZorbaArrayAutoPointer
  {
    private:
      T* thePtr;
  
    public:
      ZorbaArrayAutoPointer(): thePtr(0){}
      explicit ZorbaArrayAutoPointer(T *aPtr): thePtr(aPtr){}
  
      ~ZorbaArrayAutoPointer()
      {
        delete[] thePtr;
      }
  
      void reset(T *aPtr)
      {
        T* lPtr = thePtr;
        thePtr = aPtr;
        if(thePtr != 0)
        {
          delete[] lPtr;
        }
      }
  
      T* get() const
      {
        return thePtr;
      }
      T* release()
      {
        T* lPtr = thePtr;
        thePtr = 0;
        return lPtr;
      }
      T operator[](unsigned int anIndex) const
      {
        return thePtr[anIndex];
      }
  };
