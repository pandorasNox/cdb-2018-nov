
import Browser
import Browser.Navigation as Nav
import Html exposing (Html, button, div, text, ul, li, a, b)
import Html.Attributes exposing (href)
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
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
  }


-- urlChanges : Url.Url -> Msg
-- urlChanges _ =
--   NoOp

-- linkClicked : Browser.UrlRequest -> Msg
-- linkClicked _ =
--   NoOp


-- MODEL


type alias Model = {
    nav_key: Nav.Key,
    nav_url: Url.Url,
    counter : Int
    , products : List Product
  }


init : Flags -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init _ key url =
  (Model url key 0 [], getProducts)


-- UPDATE


type Msg = Increment
  | Decrement
  | Reset
  | ProductsResult (Result Http.Error (List Product))
  | LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url
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

    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          ( model, Nav.pushUrl model.nav_key (Url.toString url) )

        Browser.External href ->
          ( model, Nav.load href )

    UrlChanged url ->
      ( { model | nav_url = url }, Cmd.none)

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
    productsSection =
      if length(model.products) == 0 then
        div [] [ text "couldn't load products" ]
      else
        div [] [(productsView model)]

    linkArea =
      div []
      [text "The current URL is: "
      , b [] [ text (Url.toString model.nav_url) ]
      , ul []
          [ viewLink "/home"
          , viewLink "/profile"
          , viewLink "/reviews/the-century-of-the-self"
          , viewLink "/reviews/public-opinion"
          , viewLink "/reviews/shah-of-shahs"
          ]
      ]

    body =
        [
          div []
            [ button [ onClick Decrement ] [ text "-" ]
            , div [] [ text (String.fromInt model.counter) ]
            , button [ onClick Increment ] [ text "+" ]
            , button [ onClick Reset ] [ text "reset" ]
            , productsSection
            , linkArea
            ]
        ]
  in
  { title = "URL Interceptor"
  , body = body
  }

viewLink : String -> Html msg
viewLink path =
  li [] [ a [ href path ] [ text path ] ]

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

