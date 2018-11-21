module Rndnumber exposing (..)


import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random


-- MODEL


type alias Model =
  { rndNumber : Int
  }


init : () -> (Model, Cmd Msg)
init _ =
  ( Model 0
  , Cmd.none
  )



-- UPDATE


type Msg
  = GenerateRandomNumber
  | NewRandomNumber Int


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GenerateRandomNumber ->
      ( model
      , Random.generate NewRandomNumber (Random.int 0 100)
      )

    NewRandomNumber newRndNumber ->
      ( Model newRndNumber
      , Cmd.none
      )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text (String.fromInt model.rndNumber) ]
    , button [ onClick GenerateRandomNumber ] [ text "generate number" ]
    ]


-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }
