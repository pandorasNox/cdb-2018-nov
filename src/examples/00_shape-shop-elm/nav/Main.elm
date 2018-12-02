
import Browser
import Browser.Navigation
import Html exposing (Html, button, div, text, ul, li)
import Html.Events exposing (onClick)
import Json.Decode exposing (Decoder, map2, field, int, string)
import Http
import List exposing (map, length)
import Url

type alias Flags = ()

main : Program Flags Model Msg
main =
  Browser.application {
    init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    , onUrlChange = urlChanges
    , onUrlRequest = linkClicked
  }


-- init : #Browser.Navigation.Key# -> #Url.Url# -> flags -> ( model, Cmd msg )
--     , #onUrlChange# : Url.Url -> msg
--     , #onUrlRequest# : Browser.UrlRequest -> msg

urlChanges : Url.Url -> Msg
urlChanges _ =
  NoOp

linkClicked : Browser.UrlRequest -> Msg
linkClicked _ =
  NoOp


-- MODEL


type alias Model = {
    nav_key: Browser.Navigation.Key,
    nav_url: Url.Url,
    counter : Int
    , products : List Product
  }


init : Flags -> Url.Url -> Browser.Navigation.Key -> (Model, Cmd Msg)
init _ key url =
  (Model url key 0 [], getProducts)


-- UPDATE


type Msg = Increment
  | Decrement
  | Reset
  | ProductsResult (Result Http.Error (List Product))
  | NoOp


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Increment ->
      ({model | counter = model.counter + 1}, Cmd.none)

    Decrement ->
      ({model | counter = model.counter - 1}, Cmd.none)

    Reset ->
      ({model | counter = 0}, Cmd.none)

    ProductsResult (Ok products) ->
      ({ model | products = products}, Cmd.none)

    ProductsResult (Err err) ->
      (model, Cmd.none)

    NoOp ->
      (model, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW


view : Model -> Browser.Document Msg
view model =
  let
    body =
      if length(model.products) == 0 then
        [
          div []
            [ button [ onClick Decrement ] [ text "-" ]
            , div [] [ text (String.fromInt model.counter) ]
            , button [ onClick Increment ] [ text "+" ]
            , button [ onClick Reset ] [ text "reset" ]
            , div [] [ text "couldn't load products" ]
            ]
        ]
      else
        [
          div []
            [ button [ onClick Decrement ] [ text "-" ]
            , div [] [ text (String.fromInt model.counter) ]
            , button [ onClick Increment ] [ text "+" ]
            , button [ onClick Reset ] [ text "reset" ]
            , div [] [(productsView model)]
            ]
        ]
  in
  { title = "URL Interceptor"
  , body = body
  }


productsView : Model -> Html Msg
productsView model =
  ul [] (map productView model.products)


productView : Product -> Html Msg
productView product =
  li [] [text product.name]


-- HTTP


getProducts : Cmd Msg
getProducts =
  Http.send ProductsResult (Http.get "http://localhost:9988/products" productListDecoder)


type alias Product = {
    id: Int
    , name: String
  }


productDecoder : Decoder Product
productDecoder =
  map2 Product
    (field "id" int)
    (field "name" string)


productListDecoder : Decoder (List Product)
productListDecoder =
  Json.Decode.list productDecoder

