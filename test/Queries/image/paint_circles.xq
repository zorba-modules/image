(:~
 : This example creates a new image using the image/basic function and paints different sorts of circles and arcs onto it. 
 : As it is, the example just asserts that the resulting xs:base64Binary is not empty, in a real application one could further process the image, or write it 
 : to disk using file:write(a_path, $image-with-circles, <method>binary</method>), send it in an email etc.
 : 
 : Actually, as the paint function accepts sequences of shapes, it would have been possible to paint all circles, ellipses and arcs with one single command              
 : However, here it is done with several function calls to make it more clear what exactly is painted.
 :
 :)
import module namespace basic = 'http://zorba.io/modules/image/basic';
import module namespace paint = 'http://zorba.io/modules/image/paint';
import module namespace file = 'http://expath.org/ns/file';

import schema namespace image = 'http://zorba.io/modules/image/image';

let $new-image :=  basic:create(xs:unsignedInt(100), xs:unsignedInt(100), "GIF")

(: paint a simple circle with origin in (20, 20) and a perimeter of 20px to the image :)
let $image-with-circle := paint:paint($new-image, 
{
  "circle" : {
    "origin" : [ 20, 20 ],
    "radius" : 20
  }
})

(: paint an ellipse to the image :)
let $image-with-circles := paint:paint($image-with-circle,
{
  "ellipse" : {
    "origin" : [ 40, 70 ],
    "radiusX" : 20,
    "radiusY" : 10
  }
})

(: paint an arc from 90 to 180 degrees to the image :)
let $image-with-circles := paint:paint($image-with-circles,
{
  "arc" : {
    "origin" : [ 70, 35 ],
    "radiusX" : 15,
    "radiusY" : 25,
    "startDegrees" : 90,
    "endDegrees" : 180
  }
})

(: paint a blue circle with black contour onto the image :)
let $image-with-circles := paint:paint($image-with-circles,
{
  "circle" : {
    "fillColor" : "#0000FF",
    "origin" : [ 80, 20 ],
    "radius" : 20
  }
})


return not(empty($image-with-circles)) 

