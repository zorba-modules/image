(:~
 : Simple test module for the paint functions of the image library.
 : 
 : @author Daniel Thomas
 :)
import module namespace basic = 'http://zorba.io/modules/image/basic';
import module namespace file = 'http://expath.org/ns/file';
import module namespace paint = 'http://zorba.io/modules/image/paint';
import schema namespace image = 'http://zorba.io/modules/image/image';

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
    let $draw := paint:paint($local:jpg, {
      "circle" : {
        "origin" : [ 20, 20 ],
        "radius" : 5
      }
    })
    let $draw-ref := file:read-binary(concat($local:image-dir, "paint/circle.jpg"))
    return basic:equals($draw, $draw-ref)
};


(:~
 : @return true if the man:draw-ellipse function works.
 :)
declare %an:nondeterministic function local:test-draw-ellipse() as xs:boolean {
    let $draw := paint:paint($local:jpg, {
      "ellipse" : {
        "origin" : [ 50, 50 ],
        "radiusX" : 30,
        "radiusY" : 20
      }
    })
    let $draw-ref := file:read-binary(concat($local:image-dir, "paint/ellipse.jpg"))
    return basic:equals($draw, $draw-ref)
};

(:~
 : @return true if the man:draw-arc function works.
 :)
declare %an:nondeterministic function local:test-draw-arc() as xs:boolean {
    let $draw := paint:paint($local:jpg, {
      "arc" : {
        "origin" : [ 50, 50 ],
        "radiusX" : 10,
        "radiusY" : 20,
        "startDegrees" : 180,
        "endDegrees" : 270
      }
    })
    let $draw-ref := file:read-binary(concat($local:image-dir, "paint/arc.jpg"))
    return basic:equals($draw, $draw-ref)
};

(:~
 : @return true if the man:draw-arc function works.
 :)
declare %an:nondeterministic function local:test-draw-red-arc() as xs:boolean {
    let $draw := paint:paint($local:jpg, {
      "arc" : {
        "strokeColor" : "#FF0000",
        "origin" : [ 50, 50 ],
        "radiusX" : 10,
        "radiusY" : 20,
        "startDegrees" : 180,
        "endDegrees" : 270
      }
    })
    let $draw-ref := file:read-binary(concat($local:image-dir, "paint/arcRed.jpg"))
    return basic:equals($draw, $draw-ref)
};

(:~
 : @return true if the man:draw-arc function works.
 :)
declare %an:nondeterministic function local:test-draw-red-green-arc() as xs:boolean {
    let $draw := paint:paint($local:jpg, {
      "arc" : {
        "strokeColor" : "#FF0000",
        "fillColor" : "#00AF00",
        "origin" : [ 50, 50 ],
        "radiusX" : 10,
        "radiusY" : 20,
        "startDegrees" : 180,
        "endDegrees" : 270
      }
    })
    let $draw-ref := file:read-binary(concat($local:image-dir, "paint/arcRedGreen.jpg"))
    return basic:equals($draw, $draw-ref)
};

(:~
 : @return true if the man:draw-arc function works.
 :)
declare %an:nondeterministic function local:test-draw-wide-arc() as xs:boolean {
    let $draw := paint:paint($local:jpg, {
      "arc" : {
        "strokeWidth" : 5,
        "strokeColor" : "#FF0000",
        "fillColor" : "#00AF00",
        "origin" : [ 50, 50 ],
        "radiusX" : 10,
        "radiusY" : 20,
        "startDegrees" : 180,
        "endDegrees" : 270
      }
    })
    let $draw-ref := file:read-binary(concat($local:image-dir, "paint/arcWide.jpg"))
    return basic:equals($draw, $draw-ref)
};



(:~
 : @return true if the man:draw-arc function works.
 :)
declare %an:nondeterministic function local:test-draw-anti-aliased-arc() as xs:boolean {
    let $draw := paint:paint($local:jpg, {
      "arc" : {
        "strokeWidth" : 5,
        "strokeColor" : "#FF0000",
        "fillColor" : "#00AF00",
        "antiAliasing" : fn:true(),
        "origin" : [ 50, 50 ],
        "radiusX" : 10,
        "radiusY" : 20,
        "startDegrees" : 180,
        "endDegrees" : 270
      }
    })
    let $draw-ref := file:read-binary(concat($local:image-dir, "paint/arcAntiAliased.jpg"))
    return basic:equals($draw, $draw-ref)
};





declare %an:nondeterministic function local:main() as xs:string* {

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

