(:~
 : Simple test module for the manipulation functions of the image library.
 : 
 : @author Daniel Thomas
 :)
import module namespace basic = 'http://zorba.io/modules/image/basic';
import module namespace file = 'http://expath.org/ns/file';
import module namespace man = 'http://zorba.io/modules/image/manipulation';
import schema namespace image = 'http://zorba.io/modules/image/image';

declare namespace an = "http://zorba.io/annotations";

declare variable $local:image-dir := fn:concat(file:dir-name(fn:static-base-uri()), "/images/");


declare variable $local:gif as xs:base64Binary := file:read-binary(concat($local:image-dir, "bird.gif"));
declare variable $local:jpg as xs:base64Binary := file:read-binary(concat($local:image-dir, "bird.jpg"));


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
 : @return true if the man:stereo function works.
 :)
declare %an:nondeterministic function local:test-stereo() as xs:boolean {
    let $right-image := man:zoom($local:jpg, 0.9)
    let $stereod := man:stereo($local:jpg, $right-image)
    let $stereod-ref := file:read-binary(concat($local:image-dir, "manipulation/stereodBird.jpg"))
    return basic:equals($stereod, $stereod-ref)
};

(:~
 : @return true if the man:transparent function works.
 :)
declare %an:nondeterministic function local:test-transparent() as xs:boolean {
    let $transparented := man:transparent($local:gif, "#000000")
    let $transparented-ref := file:read-binary(concat($local:image-dir, "manipulation/transparentedBird.gif"))
    return basic:equals($transparented, $transparented-ref)
};

(:~
 : @return true if the man:swirl function works.
 :)
declare %an:nondeterministic function local:test-swirl() as xs:boolean {
    let $swirled := man:swirl($local:gif, -500)
    let $swirled-ref := file:read-binary(concat($local:image-dir, "manipulation/swirledBird.gif"))
    return basic:equals($swirled, $swirled-ref)
};

(:~
 : @return true if the man:reduce-noise function works.
 :)
declare %an:nondeterministic function local:test-reduce-noise() as xs:boolean {
    let $reduced := man:reduce-noise($local:gif, -0.4)
    let $reduced-ref := file:read-binary(concat($local:image-dir, "manipulation/reducedBird.gif"))
    return basic:equals($reduced, $reduced-ref)
};


(:~
 : @return true if the man:contrast function works.
 :)
declare %an:nondeterministic function local:test-contrast() as xs:boolean {
    let $contrasted := man:contrast($local:gif, 0.8)
    let $contrasted-ref := file:read-binary(concat($local:image-dir, "manipulation/contrastedBird.gif"))
    return basic:equals($contrasted, $contrasted-ref)
};


declare %an:nondeterministic %an:sequential function local:main() as xs:string* {

  let $a := local:test-stereo()
  return
    if (fn:not($a)) then
      exit returning local:error(("Stereo of images failed."));
    else ();
    
    
  let $b := local:test-transparent()
  return
    if (fn:not($b)) then
      exit returning local:error(("Making a color of an image tranparent failed."));
    else ();  
    
     
  let $c := local:test-swirl()
  return
    if (fn:not($c)) then
      exit returning local:error(("Swirl of image failed."));
    else ();  
    
   
  let $e := local:test-contrast()
  return
    if (fn:not($e)) then
      exit returning local:error(("Contrasting image failed."));
    else ();  
    
  (: If all went well ... make sure the world knows! :)  
  "SUCCESS"
};

local:main()
