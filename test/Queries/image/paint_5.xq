(:~
 : Simple test module for the paint functions of the image library.
 : 
 : @author Daniel Thomas
 :)
import module namespace basic = 'http://www.zorba-xquery.com/modules/image/basic';
import module namespace file = 'http://expath.org/ns/file';
import module namespace paint = 'http://www.zorba-xquery.com/modules/image/paint';
import schema namespace image = 'http://www.zorba-xquery.com/modules/image/image';

declare namespace an = "http://zorba.io/annotations";

declare variable $local:image-dir := fn:concat(file:dir-name(fn:static-base-uri()), "/images/");


declare variable $local:jpg as xs:base64Binary := basic:create(xs:unsignedInt(100), xs:unsignedInt(100), image:imageFormat("JPEG"));


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
 : @return true if the man:draw-circle function works.
 :)
declare %an:nondeterministic function local:test-draw-circle() as xs:boolean {
    let $draw := paint:paint($local:jpg, <image:circle><image:origin><image:x>20</image:x><image:y>20</image:y></image:origin><image:perimeter>5</image:perimeter></image:circle>)
    let $draw-ref := file:read-binary(concat($local:image-dir, "paint/circle.jpg"))
    return basic:equals($draw, $draw-ref)
};


(:~
 : @return true if the man:draw-ellipse function works.
 :)
declare %an:nondeterministic function local:test-draw-ellipse() as xs:boolean {
    let $draw := paint:paint($local:jpg, <image:ellipse><image:origin><image:x>50</image:x><image:y>50</image:y></image:origin><image:perimeterX>30</image:perimeterX><image:perimeterY>20</image:perimeterY></image:ellipse>)
    let $draw-ref := file:read-binary(concat($local:image-dir, "paint/ellipse.jpg"))
    return basic:equals($draw, $draw-ref)
};

(:~
 : @return true if the man:draw-arc function works.
 :)
declare %an:nondeterministic function local:test-draw-arc() as xs:boolean {
    let $draw := paint:paint($local:jpg, <image:arc><image:origin><image:x>50</image:x><image:y>50</image:y></image:origin><image:perimeterX>10</image:perimeterX><image:perimeterY>20</image:perimeterY><image:startDegrees>180</image:startDegrees><image:endDegrees>270</image:endDegrees></image:arc>)
    let $draw-ref := file:read-binary(concat($local:image-dir, "paint/arc.jpg"))
    return basic:equals($draw, $draw-ref)
};

(:~
 : @return true if the man:draw-arc function works.
 :)
declare %an:nondeterministic function local:test-draw-red-arc() as xs:boolean {
    let $draw := paint:paint($local:jpg, <image:arc><image:strokeColor>#FF0000</image:strokeColor><image:origin><image:x>50</image:x><image:y>50</image:y></image:origin><image:perimeterX>10</image:perimeterX><image:perimeterY>20</image:perimeterY><image:startDegrees>180</image:startDegrees><image:endDegrees>270</image:endDegrees></image:arc>)
    let $draw-ref := file:read-binary(concat($local:image-dir, "paint/arcRed.jpg"))
    return basic:equals($draw, $draw-ref)
};

(:~
 : @return true if the man:draw-arc function works.
 :)
declare %an:nondeterministic function local:test-draw-red-green-arc() as xs:boolean {
    let $draw := paint:paint($local:jpg, <image:arc><image:strokeColor>#FF0000</image:strokeColor><image:fillColor>#00AF00</image:fillColor><image:origin><image:x>50</image:x><image:y>50</image:y></image:origin><image:perimeterX>10</image:perimeterX><image:perimeterY>20</image:perimeterY><image:startDegrees>180</image:startDegrees><image:endDegrees>270</image:endDegrees></image:arc>)
    let $draw-ref := file:read-binary(concat($local:image-dir, "paint/arcRedGreen.jpg"))
    return basic:equals($draw, $draw-ref)
};

(:~
 : @return true if the man:draw-arc function works.
 :)
declare %an:nondeterministic function local:test-draw-wide-arc() as xs:boolean {
    let $draw := paint:paint($local:jpg, <image:arc><image:strokeWidth>5</image:strokeWidth><image:strokeColor>#FF0000</image:strokeColor><image:fillColor>#00AF00</image:fillColor><image:origin><image:x>50</image:x><image:y>50</image:y></image:origin><image:perimeterX>10</image:perimeterX><image:perimeterY>20</image:perimeterY><image:startDegrees>180</image:startDegrees><image:endDegrees>270</image:endDegrees></image:arc>)
    let $draw-ref := file:read-binary(concat($local:image-dir, "paint/arcWide.jpg"))
    return basic:equals($draw, $draw-ref)
};



(:~
 : @return true if the man:draw-arc function works.
 :)
declare %an:nondeterministic function local:test-draw-anti-aliased-arc() as xs:boolean {
    let $draw := paint:paint($local:jpg, <image:arc><image:strokeWidth>5</image:strokeWidth><image:strokeColor>#FF0000</image:strokeColor><image:fillColor>#00AF00</image:fillColor><image:antiAliasing>true</image:antiAliasing><image:origin><image:x>50</image:x><image:y>50</image:y></image:origin><image:perimeterX>10</image:perimeterX><image:perimeterY>20</image:perimeterY><image:startDegrees>180</image:startDegrees><image:endDegrees>270</image:endDegrees></image:arc>)
    let $draw-ref := file:read-binary(concat($local:image-dir, "paint/arcAntiAliased.jpg"))
    return basic:equals($draw, $draw-ref)
};





declare %an:nondeterministic %an:sequential function local:main() as xs:string* {

  let $a := local:test-draw-circle()
  return
    if (fn:not($a)) then
      exit returning local:error(("Drawing a circle on an image failed."));
    else ();
    
  let $b := local:test-draw-ellipse()
  return
    if (fn:not($b)) then
      exit returning local:error(("Drawing an ellipse on an image failed."));
    else ();  
              
    
  let $c := local:test-draw-arc()
  return
    if (fn:not($c)) then
      exit returning local:error(("Drawing an arc on an image failed."));
    else ();  
                         
  let $d := local:test-draw-red-arc()
  return
    if (fn:not($d)) then
      exit returning local:error(("Drawing a red arc on an image failed."));
    else ();  
    
  let $e := local:test-draw-red-green-arc()
  return
    if (fn:not($e)) then
      exit returning local:error(("Drawing a red arc with green background on an image failed."));
    else ();  
  
  let $f := local:test-draw-wide-arc()
  return
    if (fn:not($f)) then
      exit returning local:error(("Drawing an arc with wide strokes on an image failed."));
    else ();    
      
  let $g := local:test-draw-anti-aliased-arc()
  return
    if (fn:not($g)) then
      exit returning local:error(("Drawing an anti-aliased arc with wide strokes on an image failed."));
    else ();    
      
  (: If all went well ... make sure the world knows! :)  
  "SUCCESS"

};

local:main()

