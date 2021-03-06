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
 : <p>This module provides function to do the following basic image operations:</p>
 : <ul>
 :   <li>create empty images</li>
 :   <li>compare images</li>
 :   <li>compress image</li>
 :   <li>convert an image one format to another</li>
 :   <li>retrieve with, height, format, and exif information from an image</li>
 : </ul>
 : <p/>
 : <p>The following image formats are supported:
 : <ul>
 :   <li>GIF</li>
 :   <li>JPEG</li>
 :   <li>PNG</li>
 :   <li>TIFF</li>
 :   <li>BMP</li>
 : </ul>
 : </p>
 : <p>The errors raised by functions of this module have the namespace
 : <tt>http://zorba.io/modules/image/error</tt> (associated with prefix ierr).</p>
 :
 : @author Daniel Thomas
 : @library <a href="http://www.imagemagick.org/Magick++/">Magick++ C++ Library</a>
 : @project Zorba/Image/Basic
 :
 :)
module namespace basic = 'http://zorba.io/modules/image/basic';

import schema namespace image = 'http://zorba.io/modules/image/image';

declare namespace err = "http://www.w3.org/2005/xqt-errors";
declare namespace ierr = "http://zorba.io/modules/image/error";
declare namespace ver = "http://zorba.io/options/versioning";
declare namespace svg = "http://www.w3.org/2000/svg";
declare option ver:module-version "2.0";

(:~
 : <p>Returns the width of the passed image.</p>
 : 
 : @param $image the image
 : @return the width in pixels
 : @error ierr:IM001 the passed image is invalid.
 : @example test/Queries/image/basic_width.xq
 :)
declare function basic:width($image as xs:base64Binary) as xs:unsignedInt external; 

(:~
 : <p>Returns the height of the passed image.</p>
 : 
 : @param $image the image
 : @return the height in pixels
 : @error ierr:INVALID_IMAGE the passed image is invalid.
 : @example test/Queries/image/basic_height.xq
 :)
declare function basic:height($image as xs:base64Binary) as xs:unsignedInt external; 


(:~
 : <p>Compresses the passed image.</p> 
 : <p>Compressing means lowering the quality and reducing the size.</p>
 :
 : @param $image the image
 : @param $quality compression level, 0 to 100
 : @return the compressed image 
 : @error ierr:INVALID_IMAGE the passed image is invalid.
 : @example test/Queries/image/basic_compress.xq
 :)
declare function basic:compress($image as xs:base64Binary, $quality as xs:unsignedInt) as xs:base64Binary external; 



(:~
 : <p>Converts an image to another format.</p>
 :
 : @param $image the source image
 : @param $format the format (see supported formats above) of the resulting image.
 : @return A new image with the same content as the passed image but with the specified file format.
 : @error ierr:INVALID_IMAGE the passed image is invalid.
 : @error err:FORG0001 unsupported image format 
 : @example test/Queries/image/basic_convert.xq
 :)
declare function basic:convert($image as xs:base64Binary, $format as xs:string) as xs:base64Binary {
  basic:convert-impl($image, image:imageFormat($format))
};

declare %private function basic:convert-impl($image as xs:base64Binary, $format as xs:string) as xs:base64Binary external; 



(:~
 : <p>Returns the format of the passed image.</p> 
 :
 : @param $image the image
 : @return the format 
 : @error ierr:INVALID_IMAGE the passed image is invalid.
 : @example test/Queries/image/basic_type.xq
 :)
declare function basic:format($image as xs:base64Binary) as xs:string external; 
 
(:~
 : <p>Creates an empty image with background color white.</p>
 :
 : @param $width the width of the new image
 : @param $height the height of the new image
 : @param $format the format of the new image
 : @return newly created image
 : @error err:FORG0001 unsupported image format 
 : @example test/Queries/image/basic_create.xq
 :)
declare function basic:create($width as xs:unsignedInt, $height as xs:unsignedInt, $format as xs:string) as xs:base64Binary {
    basic:create-impl($width, $height, image:imageFormat($format))
};

declare %private function basic:create-impl($width as xs:unsignedInt, $height as xs:unsignedInt, $format as xs:string) as xs:base64Binary external; 

(:~
 : <p>Reads exif information from an image.</p>
 : <p>This function works for JPEG and TIFF images only.</p> 
 : <p>It returns empty sequence if no exif information matching the passed tag is found.</p>
 :
 : @param $image the image
 : @param $tag the field name we want read (e.g. DateTime).
 : @return exif field content
 : @error ierr:INVALID_IMAGE the passed image is invalid.
 : @example test/Queries/image/basic_exif.xq
 :)
declare function basic:exif($image as xs:base64Binary, $tag as xs:string) as xs:string? external; 

(:~
 : <p>Compares two images.</p>
 :
 : @param $image1 first image
 : @param $image2 second image
 : @return True if the images are equal.
 : @error ierr:INVALID_IMAGE one of the passed images is invalid.
 : @example test/Queries/image/basic_equals.xq
 :)
declare function basic:equals($image1 as xs:base64Binary, $image2 as xs:base64Binary) as xs:boolean external; 


(:~
 : <p>Converts an SVG image to a supported image format.</p>
 :
 : @param $svg the image to convert
 : @param $format target format 
 : @return the resulting image
 : @error ierr:INVALID_IMAGE the passed SVG is invalid.
 : @example test/Queries/image/basic_svg.xq
 :)
declare function basic:convert-svg(
                   $svg as element(svg:svg),
                   $format as xs:string)
                 as xs:base64Binary {

   let $ser-params :=                                                                           
      <serialization-parameters
         xmlns="http://www.w3.org/2010/xslt-xquery-serialization">
        <omit-xml-declaration value="no"/>
      </serialization-parameters>
   let $string as xs:string := fn:serialize($svg, $ser-params)
   return
     basic:convert-svg-string($string, $format)
};

(:~
 : <p>Converts an SVG image to a supported image format.</p>
 :
 : @param $svg the image to convert as string
 : @param $format target format 
 : @return the resulting image
 : @error ierr:INVALID_IMAGE the passed SVG is invalid.
 : @example test/Queries/image/basic_svg.xq
 :)
declare function basic:convert-svg-string(
                   $svg as xs:string,
                   $format as xs:string)
                 as xs:base64Binary {

   basic:convert-svg-impl($svg, image:imageFormat($format))
};

declare %private function basic:convert-svg-impl(
                            $svg as xs:string,
                            $format as xs:string)
                          as xs:base64Binary external;

