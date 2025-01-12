module Stateless exposing (Model, Msg, init, subscriptions, update, view)

import Data.Example as Example
import Data.Theme as Theme exposing (Theme)
import Element exposing (Element)


type alias Model =
    { carousel : Int
    , example : Example.Model
    }


type Msg
    = ExampleSpecific Example.Msg
    | Idle


init : ( Model, Cmd Msg )
init =
    let
        ( example, cmd ) =
            Example.init
    in
    ( { carousel = 0
      , example = example
      }
    , cmd |> Cmd.map ExampleSpecific
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ExampleSpecific exampleMsg ->
            let
                ( exampleModel, exampleCmd ) =
                    Example.update exampleMsg model.example
            in
            ( { model | example = exampleModel }
            , exampleCmd |> Cmd.map ExampleSpecific
            )

        Idle ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Example.subscriptions model.example |> Sub.map ExampleSpecific


view :
    { theme : Theme
    , msgMapper : Msg -> msg
    , model : Model
    }
    ->
        { title : String
        , description : String
        , items : List ( String, Element msg, List (Element msg) )
        }
view { theme, msgMapper, model } =
    let
        style =
            Theme.toStyle theme
    in
    { title = "Stateless Views"
    , description = "Stateless views are simple functions that view some content. No wiring required."
    , items =
        Example.toCardList
            { idle = Idle |> msgMapper
            , msgMapper = ExampleSpecific >> msgMapper
            , style = style
            , model = model.example
            }
    }
