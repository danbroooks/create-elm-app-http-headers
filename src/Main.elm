module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode as Json


---- MODEL ----


type alias Model =
    { token : String }


init : ( Model, Cmd Msg )
init =
    ( { token = "token" }, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp
    | AuthRequest
    | AuthAttempt (Result Http.Error Json.Value)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AuthRequest ->
            model ! [ Http.send AuthAttempt <| basicAuthRequest "/api" Json.value model.token ]

        _ ->
            model ! []


basicAuthRequest : String -> Json.Decoder a -> String -> Http.Request a
basicAuthRequest url decoder token =
    let
        authorization =
            "Bearer " ++ token
    in
        Http.request
            { method = "GET"
            , headers = [ (Http.header "Authorization" authorization) ]
            , url = url
            , body = emptyBody
            , expect = expectJson decoder
            , timeout = Nothing
            , withCredentials = False
            }



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick AuthRequest ] [ text "click" ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
