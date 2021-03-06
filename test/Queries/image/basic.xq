(:~
 : Simple test module for the basic functions of the image library.
 : 
 : @author Daniel Thomas
 :)
import module namespace basic = 'http://zorba.io/modules/image/basic';
import module namespace file = 'http://expath.org/ns/file';

declare namespace an = "http://zorba.io/annotations";

declare variable $local:image-dir := fn:concat(file:dir-name(fn:static-base-uri()), "/images/");


declare variable $local:png as xs:base64Binary := file:read-binary(concat($local:image-dir, "/bird.png"));
declare variable $local:gif as xs:base64Binary := file:read-binary(concat($local:image-dir, "/bird.gif"));
declare variable $local:tiff as xs:base64Binary := file:read-binary(concat($local:image-dir, "/bird.tiff"));
declare variable $local:jpg as xs:base64Binary := file:read-binary(concat($local:image-dir, "/bird.jpg"));



(:~
 : Outputs a nice error message to the screen ...
 :
 : @param $messsage is the message to be displayed
 : @return The passed message but really very, very nicely formatted.
 :)
declare function local:error($messages as xs:string*) as xs:string* {
  "
************************************************************************
ERROR:
  Location:", file:path-to-native("."), "
  Cause:",
  $messages,
  "
************************************************************************
"
};

(:~
 : @return true if the basic:width function works.
 :)
declare function local:test-width() as xs:boolean {
   ((basic:width($local:png) = 134) and (basic:width($local:gif) = 134) and (basic:width($local:jpg) = 134) and (basic:width($local:tiff) = 134))

};

(:~
 : @return true if the basic:height function works.
 :)
declare function local:test-height() as xs:boolean {
  ((basic:height($local:png) = 160) and (basic:height($local:gif) = 160) and (basic:height($local:jpg) = 160) and (basic:height($local:tiff) = 160))

};

(:~
 : @return true if the basic:create function works.
 :)
declare %an:nondeterministic function local:test-create() as xs:boolean {
  let $blank-gif := basic:create(xs:unsignedInt(10), xs:unsignedInt(20), "GIF")
  let $blank-png := basic:create(xs:unsignedInt(10), xs:unsignedInt(20), "PNG")
  let $blank-jpg := basic:create(xs:unsignedInt(10), xs:unsignedInt(20), "JPEG")
  let $blank-tiff := basic:create(xs:unsignedInt(10), xs:unsignedInt(20), "TIFF")
  let $ref-gif := file:read-binary(concat($local:image-dir, "blank.gif"))
  let $ref-jpg := file:read-binary(concat($local:image-dir, "blank.jpg"))
  let $ref-tiff := file:read-binary(concat($local:image-dir, "blank.tiff"))
  let $ref-png := file:read-binary(concat($local:image-dir, "blank.png"))
  return (basic:equals($blank-gif, $ref-gif) and basic:equals($blank-png, $ref-png) and basic:equals($blank-jpg, $ref-jpg) and basic:equals($blank-tiff, $ref-tiff))
};

(:~
 : @return true if the basic:format function works.
 :)
declare function local:test-format() as xs:boolean {
    ((basic:format($local:png) eq "PNG") and (basic:format($local:gif) eq "GIF") 
    and (basic:format($local:tiff) eq "TIFF") and (basic:format($local:jpg) eq "JPEG"))
};


(:~
 : @return true if the basic:convert function works.
 :) 
declare function local:test-convert() as xs:boolean {
    let $png-to-jpeg := basic:convert($local:png, "JPEG")
    let $png-to-tiff := basic:convert($local:png, "TIFF")
    let $png-to-gif := basic:convert($local:png, "GIF")
    return (basic:equals($png-to-jpeg, $local:jpg) and basic:equals($png-to-tiff, $local:tiff) and basic:equals($png-to-gif, $local:gif))
};

(:~
 : @return true if the basic:compress function works.
 :) 
declare %an:nondeterministic function local:test-compress() as xs:boolean {
    let $uncompressed := file:read-binary(concat($local:image-dir, "uncompressed.jpg"))
    let $compressed := basic:compress($uncompressed, xs:unsignedInt(20))
    let $compressed-ref := file:read-binary(concat($local:image-dir, "compressed.jpg")) 
    return basic:equals($compressed, $compressed-ref)
};

(:~
 : @return true if the basic:equals function works.
 :)
declare %an:nondeterministic function local:test-equals() as xs:boolean {
  (basic:equals($local:gif, $local:gif) and (not (basic:equals($local:gif, file:read-binary(concat($local:image-dir, "manipulation/gamma1Bird.gif"))))))
};


(:~
 : @return true if the basic:exif function works.
 :)
declare %an:nondeterministic function local:test-exif() as xs:boolean {
    let $exif := file:read-binary(concat($local:image-dir, "exif.jpg"))
   return ((basic:exif($exif, "ExifImageWidth") eq "20") and fn:empty(basic:exif($exif, "supercalifragilisticexpialidocious")))
};


declare %an:nondeterministic function local:test-convert-svg() as xs:boolean {
    let $svg-converted := basic:convert-svg(file:read-binary(concat($local:image-dir, "test.svg")), "JPEG")
    let $to-compare := file:read-binary(concat($local:image-dir, "test.jpeg"))
    return basic:equals($svg-converted, $to-compare)
};


declare %an:nondeterministic %an:sequential function local:main() as xs:string* {

  let $a := local:test-width()
  return
    if (fn:not($a)) then
      exit returning local:error(("Determining width of images failed"));
    else ();

  (: ==================================================================== :)

  let $b := local:test-height()
  return
    if (fn:not($b)) then
      exit returning local:error(("Determining height of images failed"));
    else ();

  (: ==================================================================== :)

  let $c := local:test-create()
  return
    if (fn:not($c)) then
      exit returning local:error(("Creation of images failed"));
    else ();

  (: ==================================================================== :) 

  let $d := local:test-format()
  return
    if (fn:not($d)) then
        exit returning local:error("Getting format of images failed");
    else ();
  (: ==================================================================== :)
  
  let $e := local:test-convert()
  return
    if (fn:not($e)) then
        exit returning local:error("Conversion of images failed");
    else ();    
  
  (: ==================================================================== :)
  
  let $f := local:test-compress()
  return
    if (fn:not($f)) then
        exit returning local:error("Compression of images failed");
    else ();   
  
  (: ==================================================================== :)

  let $g := local:test-equals()
  return 
    if (fn:not($g)) then
      exit returning local:error("Equals function not working properly");
    else ();  


  let $h := local:test-exif()
  return 
    if (fn:not($h)) then
      exit returning local:error("Reading out exif information not working properly");
    else ();
   

  (: If all went well ... make sure the world knows! :)  
  "SUCCESS"
};

local:main()

