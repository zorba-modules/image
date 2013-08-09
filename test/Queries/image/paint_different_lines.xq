(:~
 : This example creates a new image using the image/basic function and paints a few different colored lines to it.
 : As it is, the example just asserts that the resulting xs:base64Binary is not empty, in a real application one could further process the image, or write it 
 : to disk using file:write(a_path, $image-with-4-line, <method>binary</method>), send it in an email etc.
 :
 : Actually, as the paint function takes a sequence of shapes all lines could have been painted with one single function call with
 : paint:paint($new-image, (<image:line><image:start><image:x>10</image:x><image:y>0</image:y></image:start><image:end><image:x>10</image:x><image:y>100</image:y></image:end></image:line>,
                            <image:line><image:strokeColor>#FF0000</image:strokeColor><image:start><image:x>30</image:x><image:y>0</image:y></image:start><image:end><image:x>30</image:x><image:y>100</image:y></image:end></image:line>,
                            <image:line><image:strokeColor>#FF0000</image:strokeColor><image:antiAliasing>true</image:antiAliasing><image:start><image:x>50</image:x><image:y>0</image:y></image:start><image:end><image:x>50</image:x><image:y>100</image:y></image:end></image:line>,                        <image:line><image:strokeWidth>10</image:strokeWidth><image:strokeColor>#FF0000</image:strokeColor><image:antiAliasing>true</image:antiAliasing><image:start><image:x>70</image:x><image:y>0</image:y></image:start><image:end><image:x>70</image:x><image:y>100</image:y></image:end></image:line>)
 :
 : However, to show exactly what is painted it was done with several function calls in this example (which is much less performant).
 :)
import module namespace basic = 'http://zorba.io/modules/image/basic'; 
import module namespace paint = 'http://zorba.io/modules/image/paint';

import schema namespace image = 'http://zorba.io/modules/image/image';

let $new-image :=  basic:create(xs:unsignedInt(100), xs:unsignedInt(100), "GIF")
(: paint a simple line from (10, 0) to (10, 100) :)
let $image-with-1-line := paint:paint($new-image, 
{
  "line" : {
    "start" : [10,0],
    "end" : [10,100]
  }
})
(: paint a simple red line from (30, 0) to (30, 100) :)
let $image-with-2-line := paint:paint($image-with-1-line, 
{
  "line" : {
    "strokeColor" : "#FF0000",
    "start" : [30,0],
    "end" : [30,100]
  }
})
(: paint a simple red anti-aliased line from (50, 0) to (50, 100) :)
let $image-with-3-line := paint:paint($image-with-2-line, 
{
  "line" : {
    "strokeColor" : "#FF0000",
    "antiAliasing" : fn:true(),
    "start" : [50,0],
    "end" : [50,100]
  }
})
(: paint a simple red wide anti-aliased line  from (70, 0) to (70, 100) :)
let $image-with-4-line := paint:paint($image-with-3-line, 
{
  "line" : {
    "strokeWidth" : 10,
    "strokeColor" : "#FF0000",
    "antiAliasing" : fn:true(),
    "start" : [70,0],
    "end" : [70,100]
  }
})

return not(empty($image-with-4-line))

