(:~
 : This example creates a new image using the image/basic function and paints a polyline to it. 
 : As it is, the example just asserts that the resulting xs:base64Binary is not empty, in a real application one could further process the image, or write it 
 : to disk using file:write(a_path, $image-with-polyline, <method>binary</method>), send it in an email etc.
 :)
import module namespace basic = 'http://www.zorba-xquery.com/modules/image/basic'; 
import module namespace paint = 'http://www.zorba-xquery.com/modules/image/paint';

import schema namespace image = 'http://www.zorba-xquery.com/modules/image/image';

let $new-image :=  basic:create(xs:unsignedInt(100), xs:unsignedInt(100), "GIF")

(: paint an anti-aliased polyline which goes through the points (0,0) (30, 70), (20, 18), (89, 33) :)
let $image-with-polyline := paint:paint($new-image, <image:polyLine><image:antiAliasing>true</image:antiAliasing><image:point><image:x>0</image:x><image:y>0</image:y></image:point><image:point><image:x>30</image:x><image:y>70</image:y></image:point><image:point><image:x>20</image:x><image:y>18</image:y></image:point><image:point><image:x>89</image:x><image:y>33</image:y></image:point></image:polyLine>)

return not(empty($image-with-polyline)) 

