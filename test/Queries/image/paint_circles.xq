(:~
 : This example creates a new image using the image/basic function and paints different sorts of circles and arcs onto it. 
 : As it is, the example just asserts that the resulting xs:base64Binary is not empty, in a real application one could further process the image, or write it 
 : to disk using file:write(a_path, $image-with-circles, <method>binary</method>), send it in an email etc.
 : 
 : Actually, as the paint function accepts sequences of shapes, it would have been possible to paint all circles, ellipses and arcs with one single command
 : paint:paint($new-image, (<image:circle><image:origin><image:x>20</image:x><image:y>20</image:y></image:origin><image:perimeter>20</image:perimeter></image:circle>,
 :                          <image:ellipse><image:origin><image:x>40</image:x><image:y>70</image:y></image:origin><image:perimeterX>20</image:perimeterX><image:perimeterY>10</image:perimeterY></image:ellipse>,
 :                          <image:arc><image:origin><image:x>70</image:x><image:y>35</image:y></image:origin><image:perimeterX>15</image:perimeterX><image:perimeterY>25</image:perimeterY><image:startDegrees>90</image:startDegrees><image:endDegrees>180</image:endDegrees></image:arc>,
 :                          <image:circle><image:fillColor>#0000FF</image:fillColor><image:origin><image:x>80</image:x><image:y>20</image:y></image:origin><image:perimeter>20</image:perimeter></image:circle>))
 :                           
 : However, here it is done with several function calls to make it more clear what exactly is painted.
 :
 :)
import module namespace basic = 'http://www.zorba-xquery.com/modules/image/basic';
import module namespace paint = 'http://www.zorba-xquery.com/modules/image/paint';
import module namespace file = 'http://expath.org/ns/file';

import schema namespace image = 'http://www.zorba-xquery.com/modules/image/image';

let $new-image :=  basic:create(xs:unsignedInt(100), xs:unsignedInt(100), "GIF")

(: paint a simple circle with origin in (20, 20) and a perimeter of 20px to the image :)
let $image-with-circle := paint:paint($new-image, <image:circle><image:origin><image:x>20</image:x><image:y>20</image:y></image:origin><image:perimeter>20</image:perimeter></image:circle>)

(: paint an ellipse to the image :)
let $image-with-circles := paint:paint($image-with-circle, <image:ellipse><image:origin><image:x>40</image:x><image:y>70</image:y></image:origin><image:perimeterX>20</image:perimeterX><image:perimeterY>10</image:perimeterY></image:ellipse>)

(: paint an arc from 90 to 180 degrees to the image :)
let $image-with-circles := paint:paint($image-with-circles, <image:arc><image:origin><image:x>70</image:x><image:y>35</image:y></image:origin><image:perimeterX>15</image:perimeterX><image:perimeterY>25</image:perimeterY><image:startDegrees>90</image:startDegrees><image:endDegrees>180</image:endDegrees></image:arc>)

(: paint a blue circle with black contour onto the image :)
let $image-with-circles := paint:paint($image-with-circles, <image:circle><image:fillColor>#0000FF</image:fillColor><image:origin><image:x>80</image:x><image:y>20</image:y></image:origin><image:perimeter>20</image:perimeter></image:circle>)


return not(empty($image-with-circles)) 

