(:~
 : This example creates a new image using the image/basic function and paints a stroked polyline to it. 
 : As it is, the example just asserts that the resulting xs:base64Binary is not empty, in a real application one could further process the image, or write it 
 : to disk using file:write(a_path, $image-with-polyline, <method>binary</method>), send it in an email etc.
 :)
import module namespace basic = 'http://zorba.io/modules/image/basic';
import module namespace paint = 'http://zorba.io/modules/image/paint';

import schema namespace image = 'http://zorba.io/modules/image/image';

let $new-image :=  basic:create(xs:unsignedInt(100), xs:unsignedInt(100), "GIF")
(: paint an anti-aliased polyline with stoke length 2 and gap length 1 which goes through the points (0,0) (30, 70), (20, 18), (89, 33) :)
let $image-with-polyline := paint:paint($new-image, 
{
  "strokedPolyLine" : {
    "points" : [ [ 0, 0 ], [ 30, 70 ], [ 20, 18 ], [ 89, 33 ] ],
    "strokeLength" : 2,
    "gapLength" : 5
  }
})

return not(empty($image-with-polyline)) 

