(:~
 : Simple test module for the paint functions of the image library.
 : 
 : @author Daniel Thomas
 :)
import module namespace basic = 'http://zorba.io/modules/image/basic';
import module namespace file = 'http://expath.org/ns/file';
import module namespace paint = 'http://zorba.io/modules/image/paint';
import schema namespace img = 'http://zorba.io/modules/image/image';

declare namespace an = "http://www.zorba-xquery.com/annotations";

declare variable $local:image-dir := fn:concat(file:dir-name(fn:static-base-uri()), "/images/");


declare variable $local:gif as xs:base64Binary := basic:create(xs:unsignedInt(100), xs:unsignedInt(100), img:imageFormat("GIF"));


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
 : @return true if the man:draw-stroked-poly-line function works.
 :)
declare %an:nondeterministic function local:test-draw-stroked-poly-line() as xs:boolean {
    let $draw := paint:paint($local:gif, 
    {
      "strokedPolyLine" : {
        "points" : [ [10,10], [40,80], [50,30] ],
        "strokeLength" : 5,
        "gapLength" : 2
      }
    })
    let $draw-ref := file:read-binary(concat($local:image-dir, "paint/polyLineStroked.gif"))
    return basic:equals($draw, $draw-ref)
};


(:~
 : @return true if the man:draw-stroked-poly-line function works.
 :)
declare %an:nondeterministic function local:test-draw-stroked-poly-line-blue() as xs:boolean {
    let $draw := paint:paint($local:gif, 
    {
      "strokedPolyLine" : {
        "strokeColor" : "#0000FF",
        "points" : [ [10,10], [40,80], [50,30] ],
        "strokeLength" : 5,
        "gapLength" : 2
      }
    })
    let $draw-ref := file:read-binary(concat($local:image-dir, "paint/polyLineStrokedBlue.gif"))
    return basic:equals($draw, $draw-ref)
};

(:~
 : @return true if the man:draw-stroked-poly-line function works.
 :)
declare %an:nondeterministic function local:test-draw-stroked-poly-line-wide() as xs:boolean {
    let $draw := paint:paint($local:gif, 
    {
      "strokedPolyLine" : {
        "strokeWidth" : 4,
        "points" : [ [10,10], [40,80], [50,30] ],
        "strokeLength" : 5,
        "gapLength" : 2
      }
    })
    let $draw-ref := file:read-binary(concat($local:image-dir, "paint/polyLineStrokedWide.gif"))
    return basic:equals($draw, $draw-ref)
};

(:~
 : @return true if the man:draw-stroked-poly-line function works.
 :)
declare %an:nondeterministic function local:test-draw-stroked-poly-line-anti-aliased() as xs:boolean {
    let $draw := paint:paint($local:gif, 
    {
      "strokedPolyLine" : {
        "antiAliasing" : fn:true(),
        "points" : [ [10,10], [40,80], [50,30] ],
        "strokeLength" : 5,
        "gapLength" : 2
      }
    })
    let $draw-ref := file:read-binary(concat($local:image-dir, "paint/polyLineStrokedAntiAliased.gif"))
    return basic:equals($draw, $draw-ref)
};

declare %an:nondeterministic function local:main() as xs:string* {

  let $a := local:test-draw-stroked-poly-line()
  return
    if (fn:not($a)) then
      exit returning local:error(("Drawing a stroked poly-line on an image failed."));
    else ();
  
  let $b := local:test-draw-stroked-poly-line-blue()
  return
    if (fn:not($b)) then
      exit returning local:error(("Drawing a blue stroked poly-line on an image failed."));
    else ();

  let $c := local:test-draw-stroked-poly-line-wide()
  return
    if (fn:not($c)) then
      exit returning local:error(("Drawing a wide stroked poly-line on an image failed."));
    else ();
    
  let $d := local:test-draw-stroked-poly-line-anti-aliased()
  return
    if (fn:not($d)) then
      exit returning local:error(("Drawing a anti-aliased stroked poly-line on an image failed."));
    else ();
      
    
  (: If all went well ... make sure the world knows! :)  
  "SUCCESS"
};

local:main()
