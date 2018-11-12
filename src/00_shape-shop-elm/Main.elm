
import Browser
import Html exposing (Html, button, div, text, ul, li)
import Html.Events exposing (onClick)
import Json.Decode exposing (Decoder, map2, field, int, string)
import Http
import List exposing (map)


main : Program () Model Msg
main =
  Browser.element {
    init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
  }


-- MODEL


type alias Model = {
    counter : Int
    , products : List Product
  }


init : () -> (Model, Cmd Msg)
init _ =
  (Model 0 [], getProducts)


-- UPDATE


type Msg = Increment | Decrement | Reset | ProductsResult (Result Http.Error (List Product))


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Increment ->
      (Model (model.counter + 1) [], Cmd.none)

    Decrement ->
      (Model (model.counter - 1) [], Cmd.none)

    Reset ->
      ({ counter = 0, products = []}, Cmd.none)

    ProductsResult (Ok products) ->
      ({ counter = model.counter, products = products}, Cmd.none)

    ProductsResult (Err err) ->
      (model, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model.counter) ]
    , button [ onClick Increment ] [ text "+" ]
    , button [ onClick Reset ] [ text "reset" ]
    , div [] [(productsView model)]
    ]


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

