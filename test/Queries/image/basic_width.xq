(:~
 : Simple example that uses the file module to read an image from disk and returns the width of the image using the width function of the image/basic module.
 : The basic:width function returns the width in pixels (as xs:unsignedInt).
 :)
import module namespace file = 'http://expath.org/ns/file';
import module namespace basic = 'http://zorba.io/modules/image/basic';

declare variable $local:image-dir := fn:concat(file:dir-name(fn:static-base-uri()), "/images/");


let $bird as xs:base64Binary := file:read-binary(concat($local:image-dir, "/bird.png"))
return basic:width($bird)

