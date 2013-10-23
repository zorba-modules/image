(:~
 : This example uses the file module to read a SVG image from disk and converts it to a equivalent JPEG image. 
 : As it is, the example just asserts that the resulting xs:base64Binary is not empty, in a real application one could further process the image, or write it 
 : to disk using file:write-binary(a_path, basic:compress($jpeg-bird, xs:unsignedInt(2))), send it in an email etc.
 :)
import module namespace file = 'http://expath.org/ns/file';
import module namespace basic = 'http://zorba.io/modules/image/basic';

declare variable $local:image-dir := fn:concat(file:dir-name(fn:static-base-uri()), "/images/");


let $svg-bird as xs:string := file:read-text(concat($local:image-dir, "/test.svg"))
let $svg-bird-node := fn:parse-xml($svg-bird)/*:svg
let $jpeg-bird := basic:convert-svg-string($svg-bird, "JPEG")
let $jpeg-bird2 := basic:convert-svg($svg-bird-node, "JPEG")
return not(empty($jpeg-bird)) and not(empty($jpeg-bird2))
