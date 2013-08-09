xquery version "3.0";

(:
 : Copyright 2006-2009 The FLWOR Foundation.
 :
 : Licensed under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 : http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
:)

(:~
 : <p>This module provides a function to extend an image with additional shapes.</p> 
 : <p/> 
 : <p>Fully supported image formats are:</p>
 : <ul>
 :   <li>GIF</li>
 :   <li>JPEG</li>
 :   <li>PNG</li>
 :   <li>TIFF</li>
 :   <li>BMP</li>
 : </ul>
 :
 : <p>The errors raised by functions of this module have the namespace
 : <tt>http://zorba.io/modules/image/error</tt> (associated with prefix ierr).</p>
 :
 : @author Daniel Thomas
 : @library <a href="http://www.imagemagick.org/Magick++/">Magick++ C++ Library</a>
 : @project Zorba/Image/Paint
 :
 :)
module namespace paint = 'http://zorba.io/modules/image/paint';

import schema namespace img = 'http://zorba.io/modules/image/image';

declare namespace err = "http://www.w3.org/2005/xqt-errors";
declare namespace ierr = "http://zorba.io/modules/image/error";
declare namespace ver = "http://www.zorba-xquery.com/options/versioning";
declare option ver:module-version "1.0";


(:~
 : <p>Extends the passed image with a sequence of shapes.</p> 
 : <p>The shapes are passed as a sequence of elements.</p>
 : <p>The possibilities for shape elements are:</p>
 :    <ul>
 :      <li> line: 
 :        <pre class="brush: json">
 :          { 
 :            "line" : 
 :            {      
 :              "start" : [0, 0],
 :              "end" : [80, 80] 
 :            } 
 :          }
 :          </pre>
 :      </li> 
 :       <li> polyline: 
 :         <pre class="">
 :           { 
 :             "polyLine" : 
 :             {
 :               "points" : [ [10, 10], [30, 10], [30, 30], [10, 30] ] 
 :             } 
 :           }
 :         </pre>
 :       </li>
 :       <li> stroked polyline: 
 :         <pre class="brush: xml">
 :           { 
 :             "strokedPolyLine" : 
 :             {
 :               "points" : [ [10, 10], [40, 80], [50, 30] ], 
 :               "strokeLength" : 10,
 :               "gapLength" : 2
 :             } 
 :           }
 :         </pre>
 :       </li>
 :       <li> rectangle:
 :         <pre class="brush: xml">
 :           { 
 :             "rectangle" :
 :             {
 :               "upperLeft" : [ 20, 20 ],
 :               "lowerRight" : [ 50, 50 ]
 :             }
 :           }
 :         </pre>
 :       </li>
 :       <li> rounded rectangle: 
 :         <pre class="brush: json">
 :           { "roundedRectangle" :
 :             {
 :               "upperLeft" : [ 20, 20 ],
 :               "lowerRight" : [ 50, 50 ],
 :               "cornerWidth" : 10,
 :               "cornerHeight" : 10
 :             }
 :           }
 :         </pre>
 :       </li>
 :       <li> circle: 
 :         <pre class="brush: json">
 :           { 
 :             "circle" :
 :             {
 :               "origin" : [ 50, 50 ],
 :               "radius" : 5 
 :             }
 :           }
 :         </pre>
 :       </li>
 :       <li> ellipse: 
 :         <pre class="brush: json">
 :           { 
 :             "ellipse" :
 :             {
 :               "origin" : [ 50, 50 ],
 :               "radiusX" : 30,
 :               "radiusY" : 20 
 :             }
 :           }
 :         </pre>
 :       </li>
 :       <li> arc: 
 :         <pre class="brush: json">
 :           { 
 :             "arc" :
 :             {
 :               "origin" : [ 50, 50 ],
 :               "radiusX" : 10,
 :               "radiusY" : 20,
 :               "startDegrees" : 180,
 :               "endDegrees" : 270 
 :             }
 :           }
 :         </pre>
 :       </li>
 :       <li> polygon: 
 :         <pre class="brush: json">
 :           { 
 :             "polygon" : 
 :             {
 :               "points" : [ [10, 10], [30, 10], [30, 30] ] 
 :             } 
 :           }
 :         </pre>
 :       </li>
 :       <li> text: 
 :         <pre class="brush: json">
 :           { 
 :             "text" :
 :             {
 :               "origin" : [ 50, 50 ],
 :               "text" : "Hello World!",
 :               "font" : "Arial",
 :               "font-size" : 12 
 :             }
 :           }
 :         </pre>
 :       </li>
 :     </ul>
 : <p/>
 : <p>Optionally, each of the shape elements can contain elements to define the stroke with, stroke color, fill color, and anti-aliasing.</p>
 : <p>E.g.:</p>
 : <p>
 :   <pre class="brush: json">
 :     { 
 :       "polygon" : 
 :       {
 :         "strokeWidth" : 3,
 :         "strokeColor" : "#FF0000",
 :         "fillColor" : "#00FF00",
 :         "antiAliasing" : fn:true(),
 :         "points" : [ [ 10, 10 ], [ 40, 80 ], [ 50, 30 ] ]
 :       }
 :     }
 :   </pre>
 :  </p>
 : 
 : @param $image the passed image
 : @param $shapes the shapes
 : @return image with additional shapes 
 : @error ierr:INVALID_IMAGE the passed image is invalid.
 : @error err::XPTY0004 empty sequence not allowed.
 : @error err:FORG0001 one of the passed shape objects is invalid. 
 : @example test/Queries/image/paint_different_lines.xq
 : @example test/Queries/image/paint_polyline.xq
 : @example test/Queries/image/paint_stroked_polyline.xq
 : @example test/Queries/image/paint_polygon.xq
 : @example test/Queries/image/paint_rectangles.xq
 : @example test/Queries/image/paint_circles.xq
 : @example test/Queries/image/paint_text.xq
 :)
declare function paint:paint($image as xs:base64Binary, $shapes as object()*) as xs:base64Binary  {
  (: missing json validation :)
  paint:paint-impl($image, for $x in $shapes return $x)
};

declare %private function paint:paint-impl($image as xs:base64Binary, $shapes as object()*) as xs:base64Binary external; 

