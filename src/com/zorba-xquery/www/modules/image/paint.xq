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
 : This module provides a function to extend an image with additional shapes. 
 : 
 : Fully supported image formats are:
 : <ul>
 :   <li>GIF</li>
 :   <li>JPEG</li>
 :   <li>PNG</li>
 :   <li>TIFF</li>
 :   <li>BMP</li>
 : </ul>
 :
 : <p>The errors raised by functions of this module have the namespace
 : <tt>http://www.zorba-xquery.com/modules/image/error</tt> (associated with prefix ierr).</p>
 :
 : @author Daniel Thomas
 : @library <a href="http://www.imagemagick.org/Magick++/">Magick++ C++ Library</a>
 : @project image
 :
 :)
module namespace paint = 'http://www.zorba-xquery.com/modules/image/paint';

import schema namespace image = 'http://www.zorba-xquery.com/modules/image/image';

declare namespace err = "http://www.w3.org/2005/xqt-errors";
declare namespace ierr = "http://www.zorba-xquery.com/modules/image/error";
declare namespace ver = "http://www.zorba-xquery.com/options/versioning";
declare option ver:module-version "1.0";


(:~
 : Extends the passed image with a sequence of shapes. 
 : The shapes are passed as a sequence of elements.
 : The possibilities for shape elements are:
 :    <ul>
 :      <li> line: 
 :        <pre class="brush: xml">
 :          &lt;image:line&gt;
 :            &lt;start&gt;&lt;x&gt;-20&lt;/x&gt;&lt;y&gt;-20&lt;/y&gt;&lt;/start&gt;
 :            &lt;end&gt;&lt;x&gt;80&lt;/x&gt;&lt;y&gt;80&lt;/y&gt;&lt;/end&gt;
 :          &lt;/image:line&gt;</pre>
 :      </li> 
 :       <li> polyline: 
 :         <pre class="brush: xml">
 :           &lt;image:polyLine&gt;
 :             &lt;point&gt;&lt;x&gt;10&lt;/x&gt;&lt;y&gt;10&lt;/y&gt;&lt;/point&gt;
 :             &lt;point&gt;&lt;x&gt;40&lt;/x&gt;&lt;y&gt;80&lt;/y&gt;&lt;/point&gt;
 :             &lt;point&gt;&lt;x&gt;50&lt;/x&gt;&lt;y&gt;30&lt;/y&gt;&lt;/point&gt;
 :             &lt;point&gt;&lt;x&gt;200&lt;/x&gt;&lt;y&gt;200&lt;/y&gt;&lt;/point&gt;
 :           &lt;/image:polyLine&gt; 
 :         </pre>
 :       </li>
 :       <li> stroked polyline: 
 :         <pre class="brush: xml">
 :           &lt;image:strokedPolyLine&gt;
 :             &lt;point&gt;&lt;x&gt;10&lt;/x&gt;&lt;y&gt;10&lt;/y&gt;&lt;/point&gt;
 :             &lt;point&gt;&lt;x&gt;40&lt;/x&gt;&lt;y&gt;80&lt;/y&gt;&lt;/point&gt;
 :             &lt;point&gt;&lt;x&gt;50&lt;/x&gt;&lt;y&gt;30&lt;/y&gt;&lt;/point&gt;
 :             &lt;strokeLength&gt;5&lt;/strokeLength&gt;&lt;gapLength&gt;2&lt;/gapLength&gt;
 :           &lt;/image:strokedPolyLine&gt;
 :         </pre>
 :       </li>
 :       <li> rectangle:
 :         <pre class="brush: xml">
 :           &lt;image:rectangle&gt;
 :             &lt;upperLeft&gt;&lt;x&gt;20&lt;/x&gt;&lt;y&gt;20&lt;/y&gt;&lt;/upperLeft&gt;
 :             &lt;lowerRight&gt;&lt;x&gt;50&lt;/x&gt;&lt;y&gt;50&lt;/y&gt;&lt;/lowerRight&gt;
 :           &lt;/image:rectangle&gt;
 :         </pre>
 :       </li>
 :       <li> rounded rectangle: 
 :         <pre class="brush: xml">
 :           &lt;image:roundedRectangle&gt;
 :             &lt;upperLeft&gt;&lt;x&gt;20&lt;/x&gt;&lt;y&gt;20&lt;/y&gt;&lt;/upperLeft&gt;
 :             &lt;lowerRight&gt;&lt;x&gt;50&lt;/x&gt;&lt;y&gt;50&lt;/y&gt;&lt;/lowerRight&gt;
 :             &lt;cornerWidth&gt;10&lt;/cornerWidth&gt;&lt;cornerHeight&gt;10&lt;/cornerHeight&gt;
 :           &lt;/image:roundedRectangle&gt;
 :         </pre>
 :       </li>
 :       <li> circle: 
 :         <pre class="brush: xml">
 :           &lt;image:circle&gt;
 :             &lt;origin&gt;&lt;x&gt;20&lt;/x&gt;&lt;y&gt;20&lt;/y&gt;
 :             &lt;/origin&gt;&lt;perimeter&gt;5&lt;/perimeter&gt;
 :           &lt;/image:circle&gt;
 :         </pre>
 :       </li>
 :       <li> ellipse: 
 :         <pre class="brush: xml">
 :           &lt;image:ellipse&gt;
 :             &lt;origin&gt;&lt;x&gt;50&lt;/x&gt;&lt;y&gt;50&lt;/y&gt;&lt;/origin&gt;
 :             &lt;perimeterX&gt;30&lt;/perimeterX&gt;&lt;perimeterY&gt;20&lt;/perimeterY&gt;
 :           &lt;/image:ellipse&gt;
 :         </pre>
 :       </li>
 :       <li> arc: 
 :         <pre class="brush: xml">
 :           &lt;image:arc&gt;
 :             &lt;origin&gt;&lt;x&gt;50&lt;/x&gt;&lt;y&gt;50&lt;/y&gt;&lt;/origin&gt;
 :             &lt;perimeterX&gt;10&lt;/perimeterX&gt;&lt;perimeterY&gt;20&lt;/perimeterY&gt;
 :             &lt;startDegrees&gt;180&lt;/startDegrees&gt;&lt;endDegrees&gt;270&lt;/endDegrees&gt;
 :           &lt;/image:arc&gt;
 :         </pre>
 :       </li>
 :       <li> polygon: 
 :         <pre class="brush: xml">
 :           &lt;image:polygon&gt;
 :             &lt;point&gt;&lt;x&gt;10&lt;/x&gt;&lt;y&gt;10&lt;/y&gt;&lt;/point&gt;
 :             &lt;point&gt;&lt;x&gt;40&lt;/x&gt;&lt;y&gt;80&lt;/y&gt;&lt;/point&gt;
 :             &lt;point&gt;&lt;x&gt;50&lt;/x&gt;&lt;y&gt;30&lt;/y&gt;&lt;/point&gt;
 :           &lt;/image:polygon&gt;
 :         </pre>
 :       </li>
 :       <li> text: 
 :         <pre class="brush: xml">
 :           &lt;image:text&gt;
 :             &lt;origin&gt;&lt;x&gt;20&lt;/x&gt;&lt;y&gt;20&lt;/y&gt;&lt;/origin&gt;
 :             &lt;text&gt;Hello Zorba&lt;/text&gt;&lt;font&gt;&lt;/font&gt;&lt;font-size&gt;12&lt;/font-size&gt;
 :           &lt;/image:text&gt;
 :         </pre>
 :       </li>
 :     </ul>
 : 
 : Optionally, each of the shape elements can contain elements to define the stroke with, stroke color, fill color, and anti-aliasing.
 : E.g.:
 : <p>
 :   <pre class="brush: xml">
 :     &lt;image:rectangle&gt;
 :       &lt;strokeWidth&gt;5&lt;/strokeWidth&gt;
 :       &lt;strokeColor&gt;#00AF00&lt;/strokeColor&gt;
 :       &lt;fillColor&gt;#A10000&lt;/fillColor&gt;
 :       &lt;antiAliasing&gt;true&lt;/antiAliasing&gt;
 :       &lt;upperLeft&gt;&lt;x&gt;20&lt;/x&gt;&lt;y&gt;20&lt;/y&gt;&lt;/upperLeft&gt;
 :       &lt;lowerRight&gt;&lt;x&gt;50&lt;/x&gt;&lt;y&gt;50&lt;/y&gt;&lt;/lowerRight&gt;
 :     &lt;/image:rectangle&gt;
 :   </pre>
 :  </p>
 : 
 : @param $image the passed image
 : @param $shapes the shapes
 : @return image with additional shapes 
 : @error ierr:IM001 the passed image is invalid.
 : @error err:FORG0001 one of the passed shape elements is invalid. 
 : @example test/Queries/image/paint_different_lines.xq
 : @example test/Queries/image/paint_polyline.xq
 : @example test/Queries/image/paint_stroked_polyline.xq
 : @example test/Queries/image/paint_polygon.xq
 : @example test/Queries/image/paint_rectangles.xq
 : @example test/Queries/image/paint_circles.xq
 : @example test/Queries/image/paint_text.xq
 :)
declare function paint:paint($image as xs:base64Binary, $shapes as element()*) as xs:base64Binary  {
  
  paint:paint-impl($image, for $x in $shapes return validate{$x})
};

declare %private function paint:paint-impl($image as xs:base64Binary, $shapes as element(*, image:paintableType)*) as xs:base64Binary external; 

