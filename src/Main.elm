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
    div [ class "card" ]
        [ cardImage card
        ]


viewCards : Deck -> Html Msg
viewCards cards =
    cards
        |> List.map viewCard
        |> div [ class "cards" ]


view : Model -> Html Msg
view model =
    viewCards model.deck


init : Model
init =
    { deck = DeckGenerator.static
    , gameState = Choosing
    }


setCard : CardState -> Card -> Deck -> Deck
setCard cardState card deck =
    let
        updateCard selectedCard currentCard =
            if selectedCard == currentCard then
                { currentCard | state = cardState }

            else
                currentCard
    in
    deck
        |> List.map (updateCard card)


checkForMatch : Card -> Deck -> Deck
checkForMatch card deck =
    let
        setMatched matchingCard currentCard =
            if matchingCard.id == currentCard.id then
                { currentCard | state = Matched }

            else
                currentCard

        matchedCards =
            deck
                |> List.filter (\currentCard -> currentCard.id == card.id)
                |> List.filter (\matchedCards -> matchedCards.state == Open)

        newDeck =
            if List.length matchedCards == 2 then
                deck
                    |> List.map (setMatched card)

            else
                deck
    in
    newDeck


closeUnmatched : Deck -> Deck
closeUnmatched deck =
    let
        updateCard currentCard =
            if currentCard.state == Open then
                { currentCard | state = Closed }

            else
                currentCard

        newDeck =
            deck
                |> List.map updateCard
    in
    newDeck


updateCardClick : GameState -> GameState
updateCardClick gameState =
    if gameState == Choosing then
        Matching

    else
        Choosing


update : Msg -> Model -> Model
update msg model =
    case msg of
        CardClick card ->
            let
                newDeck =
                    if model.gameState == Choosing then
                        model.deck
                            |> closeUnmatched
                            |> setCard Open card

                    else
                        model.deck
                            |> setCard Open card
                            |> checkForMatch card
            in
            { model
                | deck = newDeck
                , gameState = updateCardClick model.gameState
            }


main =
    Html.beginnerProgram
        { model = init
        , update = update
        , view = view
        }
