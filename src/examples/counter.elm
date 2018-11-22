
module Counter exposing (..)

import Browser
import Html exposing (Html, button, div, text, node, p, span)
import Html.Events exposing (onClick)
import Html.Attributes exposing(class, rel, href)


-- MODEL

type alias Model = Int

initModel : Model
initModel =
  0


-- UPDATE

type Msg = Increment | Decrement

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1


-- VIEW

view : Model -> Html Msg
view model =
  div [ class "counter" ]
    [ css "https://necolas.github.io/normalize.css/8.0.0/normalize.css"
    , css "styles.css"
    ,  p [ class "display"] [ text (String.fromInt model) ]
    , button [ onClick Increment ] [ text "+" ]
    , button [ onClick Decrement ] [ text "-" ]
    ]

css : String -> Html Msg
css path =
    node "link" [ rel "stylesheet", href path ] []


-- MAIN

main =
  Browser.sandbox { init = initModel, update = update, view = view }
