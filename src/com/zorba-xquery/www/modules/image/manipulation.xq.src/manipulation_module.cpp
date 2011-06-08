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

#include "manipulation.h"
#include "manipulation_module.h"

namespace zorba { namespace imagemodule {  namespace manipulationmodule {



ExternalFunction*
ManipulationModule::getExternalFunction(const String& aLocalname)
{
  ExternalFunction*& lFunc = theFunctions[aLocalname];
  if (!lFunc) {
    if (1 == 0) {
    } else if (aLocalname == "resize") {
      lFunc = new ResizeFunction(this);
    } else if (aLocalname == "zoom-by-width") {
      lFunc = new ZoomByWidthFunction(this);
    } else if (aLocalname == "zoom-by-height") {
      lFunc = new ZoomByHeightFunction(this);
    } else if (aLocalname == "zoom") {
      lFunc = new ZoomFunction(this);
    } else if (aLocalname == "sub-image") {
      lFunc = new SubImageFunction(this);
    } else if (aLocalname == "overlay-impl") {
      lFunc = new OverlayFunction(this);
    } else if (aLocalname == "chop") {
      lFunc = new ChopFunction(this);
    } else if (aLocalname == "crop") {
      lFunc = new CropFunction(this);
    } else if (aLocalname == "rotate") {
      lFunc = new RotateFunction(this);
    } else if (aLocalname == "erase") {
      lFunc = new EraseFunction(this);
    } else if (aLocalname == "flop") {
      lFunc = new FlopFunction(this);
    } else if (aLocalname == "flip") {
      lFunc = new FlipFunction(this); 
    } else if (aLocalname == "trim") {
      lFunc = new TrimFunction(this);
    } else if (aLocalname == "add-noise-impl") {
      lFunc = new AddNoiseFunction(this);
    } else if (aLocalname == "blur") {
      lFunc = new BlurFunction(this);
    } else if (aLocalname == "despeckle") {
      lFunc = new DespeckleFunction(this);
    } else if (aLocalname == "enhance") {
      lFunc = new EnhanceFunction(this);
    } else if (aLocalname == "equalize") {
      lFunc = new EqualizeFunction(this);
    } else if (aLocalname == "edge") {
      lFunc = new EdgeFunction(this);
    } else if (aLocalname == "charcoal") {
      lFunc = new CharcoalFunction(this);
    } else if (aLocalname == "emboss") {
      lFunc = new EmbossFunction(this);
    } else if (aLocalname == "solarize") {
      lFunc = new SolarizeFunction(this);
    } else if (aLocalname == "stereo") {
      lFunc = new StereoFunction(this);
    } else if (aLocalname == "transparent-impl") {
      lFunc = new TransparentFunction(this);
    } else if (aLocalname == "swirl") {
      lFunc = new SwirlFunction(this);
    } else if (aLocalname == "reduce-noise") {
      lFunc = new ReduceNoiseFunction(this);
    } else if (aLocalname == "contrast") {
      lFunc = new ContrastFunction(this); 
    } else if (aLocalname == "gamma") {
      lFunc = new GammaFunction(this);
    } else if (aLocalname == "implode") {
      lFunc = new ImplodeFunction(this);
    } else if (aLocalname == "oil-paint") {
      lFunc = new OilPaintFunction(this); 
    } else if (aLocalname == "watermark") {
      lFunc = new WaterMarkFunction(this);
    }  
  }   
  return lFunc;
}


} /* namespace manipulationmodule */ } /* namespace imagemodule */ } /* namespace zorba */
