(:~
 : Simple test module for the paint functions of the image library.
 :
 : @author Daniel Thomas
 :)
import module namespace basic = 'http://zorba.io/modules/image/basic';
import module namespace file = 'http://expath.org/ns/file';               
import module namespace paint = 'http://zorba.io/modules/image/paint';
import schema namespace image = 'http://zorba.io/modules/image/image';

declare namespace an = "http://www.zorba-xquery.com/annotations";

declare variable $local:image-dir := fn:concat(file:dir-name(fn:static-base-uri()), "/images/");


declare variable $local:gif as xs:base64Binary := basic:create(xs:unsignedInt(100), xs:unsignedInt(100), image:imageFormat("GIF"));


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
 : @return true if the man:draw-line function works.
 :)
declare %an:nondeterministic function local:test-draw-line() as xs:boolean {            
    let $draw := paint:paint($local:gif, 
    {
      "line" : {
        "start" : [ -20, -20 ],
        "end" : [ 80, 80 ]
      }
    }) 
    let $draw-ref := file:read-binary(concat($local:image-dir,"paint/line.gif"))
    return basic:equals($draw, $draw-ref)
};

declare %an:nondeterministic function local:test-draw-line-color-red() {
    let $draw := paint:paint($local:gif, 
    {
      "line" : { 
        "strokeColor" : "#6F0000",      
        "start" : [ 0, 0 ],
        "end" : [ 80, 80 ]
      }
    }) 
    let $draw-ref := file:read-binary(concat($local:image-dir,"paint/redLine.gif"))
    return basic:equals($draw, $draw-ref)

};

declare %an:nondeterministic function local:test-draw-line-color-green() {
    let $draw := paint:paint($local:gif, 
    {
      "line" : { 
        "strokeColor" : "#006F00",      
        "start" : [ 0, 0 ],
        "end" : [ 80, 80 ]
      }
    })
    let $draw-ref := file:read-binary(concat($local:image-dir,"paint/greenLine.gif"))
    return basic:equals($draw, $draw-ref)

};

declare %an:nondeterministic function local:test-draw-line-color-blue() {
    let $draw := paint:paint($local:gif, 
    {
      "line" : { 
        "strokeColor" : "#00006F",      
        "start" : [ 0, 0 ],
        "end" : [ 80, 80 ]
      }
    }) 
    let $draw-ref := file:read-binary(concat($local:image-dir,"paint/blueLine.gif"))
    return basic:equals($draw, $draw-ref)

};

declare %an:nondeterministic function local:test-stroke-width() {
    let $draw := paint:paint($local:gif, 
    ({
      "line" : {
        "strokeWidth" : 10, 
        "strokeColor" : "#000000",      
        "start" : [ 0, 0 ],
        "end" : [ 80, 80 ]
      }
    },
    {
      "line" : { 
        "strokeColor" : "#FF00FF",      
        "start" : [ 30, 0 ],
        "end" : [ 70, 90 ]
      }
    }))
    let $draw-ref := file:read-binary(concat($local:image-dir,"paint/wideLine.gif"))
    return basic:equals($draw, $draw-ref)

};




declare %an:nondeterministic function local:main() as xs:string* {

  let $a := local:test-draw-line()
  return
    if (fn:not($a)) then
      exit returning local:error(("Drawing a line on an image failed."));
    else ();

  let $b := local:test-draw-line-color-red()
  return
    if (fn:not($b)) then
      exit returning local:error(("Drawing a red (#6F0000) line on an image failed."));
    else ();

  let $c := local:test-draw-line-color-green()
  return
    if (fn:not($c)) then
      exit returning local:error(("Drawing a green (#006F00) line on an image failed."));
    else ();

  let $d := local:test-draw-line-color-blue()
  return
    if (fn:not($d)) then
      exit returning local:error(("Drawing a blue (#00006F) line on an image failed."));
    else ();

  let $e := local:test-stroke-width()
  return
    if (fn:not($e)) then
      exit returning local:error(("Setting stroke width of an image failed."));
    else ();

  (: If all went well ... make sure the world knows! :)
  "SUCCESS"
};

local:main()
