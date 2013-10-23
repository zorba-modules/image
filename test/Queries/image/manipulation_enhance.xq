(:~
 : This example uses the file module read an image from disk and enhances the image 
 : using the enhance function from the image/manipulation module.
 : As it is, the example just asserts that the resulting xs:base64Binary is not empty, 
 : in a real application one could further process the image, or write it 
 : to disk using file:write-binary(a_path, $enhanced-image), send it in an email etc.
 :)
import module namespace file = 'http://expath.org/ns/file';
import module namespace manipulation = 'http://zorba.io/modules/image/manipulation';

declare variable $local:image-dir := fn:concat(file:dir-name(fn:static-base-uri()), "/images/");


let $bird as xs:base64Binary := file:read-binary(concat($local:image-dir, "/bird.jpg"))
let $enhanced-image := manipulation:enhance($bird)
return not(empty($enhanced-image))

