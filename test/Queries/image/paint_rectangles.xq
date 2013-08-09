(:~
 : This example creates a new image using the image/basic function and paints different sorts of rectangles onto it. 
 : As it is, the example just asserts that the resulting xs:base64Binary is not empty, in a real application one could further process the image, or write it 
 : to disk using file:write(a_path, $image-with-rectangles, <method>binary</method>), send it in an email etc.
 :
 : Actually, all rectangles could have been painted with one single function call, as the paint function also takes sequences of shapes with
 : paint:paint($new-image, (<image:rectangle><image:upperLeft><image:x>10</image:x><image:y>10</image:y></image:upperLeft><image:lowerRight><image:x>20</image:x><image:y>20</image:y></image:lowerRight></image:rectangle>,
 :                         <image:roundedRectangle><image:upperLeft><image:x>30</image:x><image:y>30</image:y></image:upperLeft><image:lowerRight><image:x>50</image:x><image:y>60</image:y></image:lowerRight><corne
 rWidth>10</image:cornerWidth><image:cornerHeight>10</image:cornerHeight></image:roundedRectangle>,
 :                          <image:rectangle><image:strokeColor>#00FF00</image:strokeColor><image:fillColor>#FF0000</image:fillColor><image:upperLeft><image:x>75</image:x><image:y>10</image:y></u
 pperLeft><image:lowerRight><image:x>95</image:x><image:y>50</image:y></image:lowerRight></image:rectangle>))
 :
 : However, to make clear what exaclty is painted it was done with several function calls in this example (which is less performant).
 :)
import module namespace basic = 'http://zorba.io/modules/image/basic';
import module namespace paint = 'http://zorba.io/modules/image/paint';

import schema namespace image = 'http://zorba.io/modules/image/image';

let $new-image :=  basic:create(xs:unsignedInt(100), xs:unsignedInt(100), "GIF")

(: paint a simple rectangle to the image :) 
let $image-with-rectangle := paint:paint($new-image, 
{
  "rectangle" : {
    "upperLeft" : [10,10],
    "lowerRight" : [20,20]
  }
}) 

(: paint a rounded rectangle to the image with a corner width of 10px and a corner height of 10 px :) 
let $image-with-rectangles := paint:paint($image-with-rectangle, 
{
  "roundedRectangle" : {
    "upperLeft" : [30,30],
    "lowerRight" : [50,60],
    "cornerWidth" : 10,
    "cornerHeight" : 10 
  }             
})

(: paint a rectangle with green contour which is filled with red to the image :)  
let $image-with-rectangles := paint:paint($image-with-rectangles, 
{
  "rectangle" : {
    "strokeColor" : "#00FF00",
    "fillColor" : "#FF0000",
    "upperLeft" : [75,10],
    "lowerRight" : [95,50]
  }
})

return not(empty($image-with-rectangles)) 
