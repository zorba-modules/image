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

#include "paint.h"
#include <list> 
#include <sstream>
#include <iostream>
#include <zorba/empty_sequence.h>
#include <zorba/singleton_item_sequence.h>
#include <zorba/zorba.h>
#include <zorba/xquery_functions.h>
#include "paint_module.h"
#include "draw_in_c.h"
#include <cstring>

namespace zorba {  namespace imagemodule { namespace paintmodule {

using namespace zorba::imagemodule;  


//*****************************************************************************

PaintImplFunction::PaintImplFunction(const ImageModule* aModule) : ImageFunction(aModule)
{
}

ItemSequence_t
PaintImplFunction::evaluate(
  const ExternalFunction::Arguments_t& aArgs,
  const StaticContext*                          aSctxCtx,
  const DynamicContext*                         aDynCtx) const 
{

  Magick::Blob lBlob;
  Magick::Image lImage;
  // this may be a little slower then getting the blob directly, but it ensures the correct use of the error handling facility.
  ImageFunction::getOneImageArg(aDynCtx, aArgs, 0, lImage);
  lImage.write(&lBlob);

  Item lNextPaint;
  Iterator_t arg1_iter = aArgs[1]->getIterator();
  arg1_iter->open();
  while (arg1_iter->next(lNextPaint)) {
    applyShape(lBlob, lNextPaint);
  }
  arg1_iter->close();

  // pass the blob back as base64Binary ...
  String lEncodedContent = ImageFunction::getEncodedStringFromBlob(lBlob);
  Item lItem( theModule->getItemFactory()->createBase64Binary(lEncodedContent.c_str(), lEncodedContent.size(), true));
  ImageFunction::checkIfItemIsNull(lItem);
  return ItemSequence_t(new SingletonItemSequence(lItem));

}

bool
PaintImplFunction::getCommonValues(Item& aObject, 
                                   double* aStrokeWidth, 
                                   std::string& aStrokeColor, 
                                   std::string& aFillColor) const {
  bool lFoundStrokeWidth = false;
  bool lFoundStrokeColor = false;
  bool lFoundFillColor = false;
  bool lFoundAntialising = false;
  // fill in default values
  *aStrokeWidth = 1;
  aStrokeColor = "#000000";
  aFillColor = "#FFFFFF";
  bool lAntiAliasing = false;

  //we check for the 4 common objects inside the shapes object value
  Iterator_t lKeys = aObject.getObjectKeys();
  Item lKey;
  lKeys->open();
  while (lKeys->next(lKey))
  {
    String lStrKey = lKey.getStringValue();
    if (!lFoundStrokeWidth && fn::ends_with(lStrKey, "eWidth"))
    {
      Item lValue = aObject.getObjectValue(lStrKey);
      *aStrokeWidth = getDoubleValue(lValue);
      lFoundStrokeWidth = true;
    }
    else if (!lFoundStrokeColor && fn::ends_with(lStrKey, "eColor"))
    {
      Item lValue = aObject.getObjectValue(lStrKey);
      aStrokeColor = lValue.getStringValue().c_str();
      lFoundStrokeColor = true;
    }
    else if (!lFoundFillColor && fn::ends_with(lStrKey, "Color"))
    {
      Item lValue = aObject.getObjectValue(lStrKey);
      aFillColor = lValue.getStringValue().c_str();
      lFoundFillColor = true;
    }
    else if (!lFoundAntialising && fn::ends_with(lStrKey, "ing"))
    {
      Item lValue = aObject.getObjectValue(lStrKey);
      String lAntialisingString = lValue.getStringValue();
      if (fn::ends_with(lAntialisingString, "ue"))
      {
        lAntiAliasing = true;
      } 
      else
      {
        lAntiAliasing = false;
      }
    }
  }
  lKeys->close();
    
  return lAntiAliasing;
}

void
PaintImplFunction::applyShape(Magick::Blob& aBlob, Item& aShape) const {
 Iterator_t lObjIter = aShape.getObjectKeys();
  Item lKey;
  lObjIter->open();
  while ( lObjIter->next(lKey) )
  {
    String lStrKey = lKey.getStringValue();
    Item lValue = aShape.getObjectValue(lStrKey);
    if (fn::ends_with(lStrKey, "line")) {
      applyLine(aBlob, lValue);
    } else if (fn::ends_with(lStrKey, "dPolyLine")) {
      applyStrokedPolyLine(aBlob, lValue);
    }  else if (fn::ends_with(lStrKey, "Line")) {
      applyPolyLine(aBlob, lValue);
    } else if (fn::ends_with(lStrKey,"rectangle")) {
      applyRectangle(aBlob, lValue);
    } else if (fn::ends_with(lStrKey, "gle")) {
      applyRoundedRectangle(aBlob, lValue);
    } else if (fn::ends_with(lStrKey, "cle")) {
      applyCircle(aBlob, lValue);
    } else if (fn::ends_with(lStrKey, "se")) {
      applyEllipse(aBlob, lValue);
    } else if (fn::ends_with(lStrKey, "c")) {
      applyArc(aBlob, lValue);
    } else if (fn::ends_with(lStrKey, "n")) {
      applyPolygon(aBlob, lValue);
    } else if (fn::ends_with(lStrKey, "t")) {
      applyText(aBlob, lValue);
    }  
  }
  lObjIter->close();
}


double
PaintImplFunction::getDoubleValue(Item& aDoubleItem) const{
  std::stringstream lConverter;
  lConverter << aDoubleItem.getStringValue().c_str();
  double lResult;
  lConverter >> lResult;
  return lResult; 

}

void
PaintImplFunction::getDoublesFromPoint(Item& aPoint, double aPointValues[2]) const {
  Item lX, lY;
  lX = aPoint.getArrayValue(1);
  lY = aPoint.getArrayValue(2);
  aPointValues[0] = getDoubleValue(lX);
  aPointValues[1] = getDoubleValue(lY);
}

void 
PaintImplFunction::applyLine(Magick::Blob& aBlob, Item& aLine) const {
 Item lStartPoint, lEndPoint;
  double lStrokeWidth = 0;
  std::string lStrokeColor = "";
  std::string lFillColor = "";
  bool lAntiAliasing;   
  double lFirst[2];
  double lSecond[2];

  // set common values from JSON
  lAntiAliasing = getCommonValues(aLine, &lStrokeWidth, lStrokeColor, lFillColor);
  lStartPoint = aLine.getObjectValue("start");
  lEndPoint = aLine.getObjectValue("end");
  getDoublesFromPoint(lStartPoint, lFirst);
  getDoublesFromPoint(lEndPoint, lSecond);
  double lXValues[2] = {lFirst[0], lSecond[0]};
  double lYValues[2] = {lFirst[1], lSecond[1]};

  long lBlobLength = (long) aBlob.length();
  void * lBlobPointer = DrawPolyLine(aBlob.data(), &lBlobLength, &lXValues[0], &lYValues[0], 2, lStrokeColor, lStrokeWidth, lAntiAliasing, NULL, 0);
  Magick::Blob lBlobWithPolyLine(lBlobPointer, lBlobLength);
  // now read the blob back into an image to pass it back as encoded string 
  aBlob = lBlobWithPolyLine; 
}  

void
PaintImplFunction::applyPolyLine(Magick::Blob& aBlob, Item& aLine) const {
  double lStrokeWidth = 0; 
  std::string lStrokeColor = "";
  std::string lFillColor = "";
  bool lAntiAliasing;
  std::vector<double> lXValues;
  std::vector<double> lYValues;
  double lTempPoint[2];
  int lSize = 1;

  lAntiAliasing = getCommonValues(aLine, &lStrokeWidth, lStrokeColor, lFillColor);
   
  Item lPoints = aLine.getObjectValue("points");
  lSize = lPoints.getArraySize();
  for (int i = 1; i <= lSize; i++)
  {
    Item lPoint = lPoints.getArrayValue(i);  
    getDoublesFromPoint(lPoint, lTempPoint);
    lXValues.push_back(lTempPoint[0]);
    lYValues.push_back(lTempPoint[1]);
  }
  
  long lBlobLength = (long) aBlob.length();
  double* lXValuesArray = new double[lSize];
  double* lYValuesArray = new double[lSize];
  std::memcpy(lXValuesArray, &lXValues[0], lSize*sizeof(lXValues[0]));
  std::memcpy(lYValuesArray, &lYValues[0], lSize*sizeof(lYValues[0]));
    
  void * lBlobPointer = DrawPolyLine(aBlob.data(), &lBlobLength, &lXValuesArray[0], &lYValuesArray[0], lSize, lStrokeColor, lStrokeWidth, lAntiAliasing, NULL, 0);
  
  delete[] lXValuesArray;
  delete[] lYValuesArray;
  
  Magick::Blob lBlobWithPolyLine(lBlobPointer, lBlobLength);
  // now read the blob back into an image to pass it back as encoded string 
  aBlob = lBlobWithPolyLine;
 
}

void
PaintImplFunction::applyStrokedPolyLine(Magick::Blob& aBlob, Item& aLine) const {
 Item lFirstPoint;
  double lStrokeWidth = 0; 
  std::string lStrokeColor = "";
  std::string lFillColor = "";
  bool lAntiAliasing;
  std::vector<double> lXValues;
  std::vector<double> lYValues;
  double lTempPoint[2];
  double lStrokeArray[2];
  int lSize = 1;

  lAntiAliasing = getCommonValues(aLine, &lStrokeWidth, lStrokeColor, lFillColor);
  
  Item lPoints = aLine.getObjectValue("points");
  lSize = lPoints.getArraySize();
  for (int i = 1; i <= lSize; i++)
  {
    Item lPoint = lPoints.getArrayValue(i);  
    getDoublesFromPoint(lPoint, lTempPoint);
    lXValues.push_back(lTempPoint[0]);
    lYValues.push_back(lTempPoint[1]);
  }
  //get stroke length
  Item lStrokeLength = aLine.getObjectValue("strokeLength");
  lStrokeArray[0] = getDoubleValue(lStrokeLength);
  Item lGapLength = aLine.getObjectValue("gapLength");
  lStrokeArray[1] = getDoubleValue(lGapLength);
  
  
  long lBlobLength = (long) aBlob.length();
  
  double* lXValuesArray = new double[lSize];
  double* lYValuesArray = new double[lSize];
  memcpy(lXValuesArray, &lXValues[0], lSize*sizeof(lXValues[0]));
  memcpy(lYValuesArray, &lYValues[0], lSize*sizeof(lYValues[0]));
  
  void * lBlobPointer = DrawPolyLine(aBlob.data(), &lBlobLength, &lXValuesArray[0], &lYValuesArray[0], lSize, lStrokeColor, lStrokeWidth, lAntiAliasing, lStrokeArray, 2);
  
  delete[] lXValuesArray;
  delete[] lYValuesArray;
  
  Magick::Blob lBlobWithPolyLine(lBlobPointer, lBlobLength);
  // now read the blob back into an image to pass it back as encoded string 
  aBlob = lBlobWithPolyLine;

}

void              
PaintImplFunction::applyRectangle(Magick::Blob& aBlob, Item& aRectangle) const {
  double lStrokeWidth = 0; 
  std::string lStrokeColor = "";
  std::string lFillColor = "";
  bool lAntiAliasing;
  double lUpperLeft[2];
  double lLowerRight[2];

  lAntiAliasing = getCommonValues(aRectangle, &lStrokeWidth, lStrokeColor, lFillColor);
  Item lUpperLeftItem = aRectangle.getObjectValue("upperLeft");
  getDoublesFromPoint(lUpperLeftItem, lUpperLeft);
  Item lLowerRightItem = aRectangle.getObjectValue("lowerRight");
  getDoublesFromPoint(lLowerRightItem, lLowerRight);
  

  long lBlobLength = (long) aBlob.length();
  void * lBlobPointer = DrawRoundedRect(aBlob.data(), &lBlobLength, lUpperLeft[0], lUpperLeft[1], lLowerRight[0], lLowerRight[1], 0, 0, lStrokeColor, lFillColor, lStrokeWidth, lAntiAliasing);
  Magick::Blob lBlobWithPolyLine(lBlobPointer, lBlobLength);
  // now read the blob back into an image to pass it back as encoded string 
  aBlob = lBlobWithPolyLine;
}

void              
PaintImplFunction::applyRoundedRectangle(Magick::Blob& aBlob, Item& aRectangle) const {
   Item lItem;
  double lStrokeWidth = 0; 
  std::string lStrokeColor = "";
  std::string lFillColor = "";
  bool lAntiAliasing;
  double lUpperLeft[2];
  double lLowerRight[2];
  double lCornerWidth;
  double lCornerHeight;

  lAntiAliasing = getCommonValues(aRectangle, &lStrokeWidth, lStrokeColor, lFillColor);
  lItem = aRectangle.getObjectValue("upperLeft");
  getDoublesFromPoint(lItem, lUpperLeft);
  lItem = aRectangle.getObjectValue("lowerRight");
  getDoublesFromPoint(lItem, lLowerRight);
  lItem = aRectangle.getObjectValue("cornerWidth");
  lCornerWidth = getDoubleValue(lItem);
  lItem = aRectangle.getObjectValue("cornerHeight");
  lCornerHeight = getDoubleValue(lItem);  

  long lBlobLength = (long) aBlob.length();
  void * lBlobPointer = DrawRoundedRect(aBlob.data(), &lBlobLength, lUpperLeft[0], lUpperLeft[1], lLowerRight[0], lLowerRight[1], lCornerWidth, lCornerHeight, lStrokeColor, lFillColor, lStrokeWidth, lAntiAliasing);
  Magick::Blob lBlobWithPolyLine(lBlobPointer, lBlobLength);
  // now read the blob back into an image to pass it back as encoded string 
  aBlob = lBlobWithPolyLine;

}

void              
PaintImplFunction::applyCircle(Magick::Blob& aBlob, Item& aCircle) const {
 double lStrokeWidth = 0; 
  std::string lStrokeColor = "";
  std::string lFillColor = "";
  bool lAntiAliasing;
  double lOriginCoordinates[2];
  Item lItem;
  double lRadius;

  lAntiAliasing = getCommonValues(aCircle, &lStrokeWidth, lStrokeColor, lFillColor);
  lItem = aCircle.getObjectValue("origin");
  getDoublesFromPoint(lItem, lOriginCoordinates);
  lItem = aCircle.getObjectValue("radius");
  lRadius = getDoubleValue(lItem);
  
  Magick::Image lImage(aBlob);
  lImage.strokeAntiAlias(lAntiAliasing);
  lImage.strokeWidth(lStrokeWidth);
  Magick::ColorRGB lStrokeColorForMagick;
  Magick::ColorRGB lFillColorForMagick;
  ImageFunction::getColorFromString(lStrokeColor.c_str(), lStrokeColorForMagick);
  ImageFunction::getColorFromString(lFillColor.c_str(), lFillColorForMagick);
  lImage.strokeColor(lStrokeColorForMagick);
  lImage.fillColor(lFillColorForMagick);
  lImage.draw(Magick::DrawableEllipse(lOriginCoordinates[0], lOriginCoordinates[1], lRadius, lRadius, 0, 360));
  Magick::Blob lBlob;
  lImage.write(&lBlob);
  aBlob = lBlob;
}

void              
PaintImplFunction::applyEllipse(Magick::Blob& aBlob, Item& aCircle) const {
 double lStrokeWidth = 0; 
  std::string lStrokeColor = "";
  std::string lFillColor = "";
  bool lAntiAliasing;
  Item lItem;
  double lOriginCoordinates[2];
  double lRadiusX;
  double lRadiusY;
  
  lAntiAliasing = getCommonValues(aCircle, &lStrokeWidth, lStrokeColor, lFillColor);
  lItem = aCircle.getObjectValue("origin");
  getDoublesFromPoint(lItem, lOriginCoordinates);
  lItem = aCircle.getObjectValue("radiusX");
  lRadiusX = getDoubleValue(lItem);
  lItem = aCircle.getObjectValue("radiusY");
  lRadiusY = getDoubleValue(lItem);
  
  Magick::Image lImage(aBlob);
  lImage.strokeAntiAlias(lAntiAliasing);
  lImage.strokeWidth(lStrokeWidth);
  Magick::ColorRGB lStrokeColorForMagick;
  Magick::ColorRGB lFillColorForMagick;
  ImageFunction::getColorFromString(lStrokeColor.c_str(), lStrokeColorForMagick);
  ImageFunction::getColorFromString(lFillColor.c_str(), lFillColorForMagick);
  lImage.strokeColor(lStrokeColorForMagick);
  lImage.fillColor(lFillColorForMagick);
  lImage.draw(Magick::DrawableEllipse(lOriginCoordinates[0], lOriginCoordinates[1], lRadiusX, lRadiusY, 0, 360));
  Magick::Blob lBlob;
  lImage.write(&lBlob);
  aBlob = lBlob;
}

void              
PaintImplFunction::applyArc(Magick::Blob& aBlob, Item& aCircle) const {
 double lStrokeWidth = 0; 
  std::string lStrokeColor = "";
  std::string lFillColor = "";
  bool lAntiAliasing;
  double lOriginCoordinates[2];
  double lRadiusX, lRadiusY, lStartDegrees, lEndDegrees;
  Item lItem;

  lAntiAliasing = getCommonValues(aCircle, &lStrokeWidth, lStrokeColor, lFillColor);
  lItem = aCircle.getObjectValue("origin");
  getDoublesFromPoint(lItem, lOriginCoordinates);    
  lItem = aCircle.getObjectValue("radiusX");
  lRadiusX = getDoubleValue(lItem);
  lItem = aCircle.getObjectValue("radiusY");
  lRadiusY = getDoubleValue(lItem);
  lItem = aCircle.getObjectValue("startDegrees");
  lStartDegrees = getDoubleValue(lItem);
  lItem = aCircle.getObjectValue("endDegrees");
  lEndDegrees = getDoubleValue(lItem);  
  
  Magick::Image lImage(aBlob);
  lImage.strokeAntiAlias(lAntiAliasing);
  lImage.strokeWidth(lStrokeWidth);
  Magick::ColorRGB lStrokeColorForMagick;
  Magick::ColorRGB lFillColorForMagick;
  ImageFunction::getColorFromString(lStrokeColor.c_str(), lStrokeColorForMagick);
  ImageFunction::getColorFromString(lFillColor.c_str(), lFillColorForMagick);
  lImage.strokeColor(lStrokeColorForMagick);
  lImage.fillColor(lFillColorForMagick);
  lImage.draw(Magick::DrawableEllipse(lOriginCoordinates[0], lOriginCoordinates[1], lRadiusX, lRadiusY, lStartDegrees, lEndDegrees));
  Magick::Blob lBlob;
  lImage.write(&lBlob);
  aBlob = lBlob;
}


void              
PaintImplFunction::applyPolygon(Magick::Blob& aBlob, Item& aLine) const {
 double lStrokeWidth = 0; 
  std::string lStrokeColor = "";
  std::string lFillColor = "";
  bool lAntiAliasing;
  std::vector<double> lXValues;
  std::vector<double> lYValues;
  double lTempPoint[2];
  int lSize = 1;

  lAntiAliasing = getCommonValues(aLine, &lStrokeWidth, lStrokeColor, lFillColor);

  Item lPoints = aLine.getObjectValue("points");
  lSize = lPoints.getArraySize();
  for (int i = 1; i <= lSize; i++)
  {
    Item lPoint = lPoints.getArrayValue(i);  
    getDoublesFromPoint(lPoint, lTempPoint);
    lXValues.push_back(lTempPoint[0]);
    lYValues.push_back(lTempPoint[1]);
  }
  
  long lBlobLength = (long) aBlob.length();
  
  double* lXValuesArray = new double[lSize];
  double* lYValuesArray = new double[lSize];
  memcpy(lXValuesArray, &lXValues[0], lSize*sizeof(lXValues[0]));
  memcpy(lYValuesArray, &lYValues[0], lSize*sizeof(lYValues[0]));
    
  void * lBlobPointer = DrawPolygon(aBlob.data(), &lBlobLength, &lXValuesArray[0], &lYValuesArray[0], lSize, lStrokeColor, lFillColor, lStrokeWidth, lAntiAliasing);
  
  delete[] lXValuesArray;
  delete[] lYValuesArray;
  
  Magick::Blob lBlobWithPolyLine(lBlobPointer, lBlobLength);
  // now read the blob back into an image to pass it back as encoded string 
  aBlob = lBlobWithPolyLine;
}

void              
PaintImplFunction::applyText(Magick::Blob& aBlob, Item& aText) const {
  double lStrokeWidth = 0; 
  std::string lStrokeColor = "";
  std::string lFillColor = "";
  double lOriginCoordinates[2];
  Item lItem;
  String lText, lFontFamily;
  double lFontSize;

  getCommonValues(aText, &lStrokeWidth, lStrokeColor, lFillColor);
  lItem = aText.getObjectValue("origin");
  getDoublesFromPoint(lItem, lOriginCoordinates);
  lItem = aText.getObjectValue("text");
  lText = lItem.getStringValue();
  lItem = aText.getObjectValue("font");
  lFontFamily = lItem.getStringValue();
  lItem = aText.getObjectValue("fontSize");
  lFontSize = getDoubleValue(lItem); 
  
  long lBlobLength = (long) aBlob.length();
  void * lBlobPointer = DrawText(aBlob.data(), &lBlobLength, lText.c_str() , lOriginCoordinates[0], lOriginCoordinates[1], lFontFamily.c_str(), lFontSize, lStrokeColor.c_str());
  Magick::Blob lBlobWithPolyLine(lBlobPointer, lBlobLength);
  // now read the blob back into an image to pass it back as encoded string 
  aBlob = lBlobWithPolyLine;
}


} /* namespace paintmodule */  } /* namespace imagemodule */ }  /* namespace zorba */


#ifdef WIN32
#  define DLL_EXPORT __declspec(dllexport)
#else
#  define DLL_EXPORT __attribute__ ((visibility("default")))
#endif

extern "C" DLL_EXPORT zorba::ExternalModule* createModule() {
  return new zorba::imagemodule::paintmodule::PaintModule();
}


