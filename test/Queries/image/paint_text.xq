(:~
 : This example creates a new image using the image/basic function and paints a text to it. 
 : As it is, the example just asserts that the resulting xs:base64Binary is not empty, in a real application one could further process the image, or write it 
 : to disk using file:write-binary(a_path, $image-with-text), send it in an email etc.
 :)
import module namespace basic = 'http://zorba.io/modules/image/basic';                                                                                                                                                     import module namespace paint = 'http://zorba.io/modules/image/paint';                                                                                                                                                     
import schema namespace image = 'http://zorba.io/modules/image/image';

let $new-image := basic:create(xs:unsignedInt(200), xs:unsignedInt(100), "GIF")

(: write a really important message to the image :)

let $image-with-text := paint:paint($new-image, 
{
  "text" : {
    "origin" : [ 10, 40 ],
    "text" : "Zorba really rocks!",
    "font" : "Arial",
    "fontSize" : 12   
  }
})

return not(empty($image-with-text)) 
