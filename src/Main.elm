module Main exposing (cardImage, getCatImage, greet, init, main, setCard, update, view, viewCard, viewCards)

import DeckGenerator exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (..)


greet : String -> String
greet name =
    "Hello " ++ name


getCatImage : String -> String
getCatImage image =
    "/cats/" ++ image ++ ".png"


cardImage : Card -> Html Msg
cardImage card =
    case card.state of
        Open ->
            img
                [ class "open"
                , src (getCatImage card.id)
                ]
                []

        Closed ->
            img
                [ class "closed"
                , src (getCatImage "closed")
                , onClick (CardClick card)
                ]
                []

        Matched ->
            img
                [ class "matched"
                , src (getCatImage card.id)
                ]
                []


viewCard : Card -> Html Msg
viewCard card =
    div []
        [ cardImage card
        ]


viewCards : Deck -> Html Msg
viewCards cards =
    cards
        |> List.map viewCard
        |> div []


view : Model -> Html Msg
view model =
    viewCards model.deck


init : Model
init =
    { deck = DeckGenerator.static
    , gameState = Choosing
    }


setCard : CardState -> Card -> Card
setCard cardState card =
    { card | state = cardState }



-- closeUnmatched : Deck -> Deck
-- closeUnmatched deck =
-- updateCardClick : Card -> GameState -> GameState
-- updateCardClick card gameState =


update : Msg -> Model -> Model
update msg model =
    case msg of
        CardClick card ->
            let
                updateCard currentCard =
                    if card.id == currentCard.id then
                        setCard Open currentCard

                    else
                        currentCard

                newDeck =
                    List.map updateCard model.deck
            in
            { model | deck = newDeck }


main =
    Html.beginnerProgram
        { model = init
        , update = update
        , view = view
        }
