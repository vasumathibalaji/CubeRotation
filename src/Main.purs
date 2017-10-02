module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log, logShow)
import DOM (DOM)
import Control.Monad.Eff.JQuery (appendText, addClass, body, create, css, on, select, setAttr)
import Control.Monad.Eff.JQuery (append) as A
import Partial.Unsafe (unsafePartial)

-- creating faces of the cube
render3DCube :: forall e. Eff (dom :: DOM |e) Unit
render3DCube = do
  front <- create "<div>"
  setAttr "id" "front" front
  addClass "face" front
  appendText "J " front

  back <- create "<div>"
  setAttr "id" "back" back
  addClass "face" back
  appendText "U " back

  right <- create "<div>"
  setAttr "id" "right" right
  addClass "face" right
  appendText "S " right

  left <- create "<div>"
  setAttr "id" "left" left
  addClass "face" left
  appendText "P " left

  top <- create "<div>"
  setAttr "id" "top" top
  addClass "face" top
  appendText "A " top

  bottom <- create "<div>"
  setAttr "id" "bottom" bottom
  addClass "face" bottom
  appendText "Y " bottom

  cube <- create "<div>"
  addClass "cube" cube
-- positioning the faces of the cube
  css {
    transform : "translateZ(100px)",
    backgroundColor: "red"

  } front

  css {
  	transform : "rotateY(180deg) translateZ(100px)",
    backgroundColor: "green"
  } back
  css {
  	transform: "rotateY(-270deg) translateX(100px)",
    transformOrigin: "top right",
    backgroundColor: "blue"
  } right
  css {
    transform: "rotateY(270deg) translateX(-100px)",
    transformOrigin: "center left",
    backgroundColor: "cyan"
  } left
  css {
    transform: "rotateX(-90deg) translateY(-100px)",
    transformOrigin: "top center",
    backgroundColor: "magenta"
  } top
  css {
    transform: "rotateX(90deg) translateY(100px)",
    transformOrigin: "bottom center",
    backgroundColor: "yellow"

  } bottom

  css {
    position: "relative",
  	transformStyle: "preserve-3d"
  } cube
-- appending the child elements to the parent element
  A.append front cube
  A.append back cube
  A.append right cube
  A.append left cube
  A.append top cube
  A.append bottom cube
-- creating a wrapper  for the entire cube
  main <- create "<div>"
  setAttr "id" "main" main
  addClass "main" main
  css {
    position : "absolute",
    left : "50%",
    top : "50%",
    perspective: "1500px"
  } main
  A.append cube main

  body <- body
  addClass "body" body
  css{
    overflow: "hidden"
  } body
  A.append main body

  css {
    width: "100%",
    height: "100%"
  } body
-- applying style to the faces
  face <- select ".face"
  css {
  	position : "absolute",
  	width : "200px",
  	height : "200px",
    border : "solid black 5px"
  } face

  css {
    transform: "rotateX(-45deg)rotateY(45deg)"
  } cube
  -- creating a mouseover event
  on "mouseover" (dragEvent main cube) main
dragEvent main cube _ _ = unsafePartial do
    cube <- select ".cube"
    css {
      animation: "rotate 10s linear",
      -- transform: "rotateX(90deg)",
      transitionDuration: "3s"
    } cube
-- calling the main function
main :: forall h e. Eff (dom :: DOM, console :: CONSOLE | e) Unit
main = do
  render3DCube
  log("done")
