module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

greet : String -> String
greet name =
    "Hello " ++ name

getCatImage : String -> String
getCatImage image =
        "/cats/" ++ image ++ ".jpg"

cardImage : Card -> Html a
cardImage card =
        case card.state of
                Open ->
                        img [ class "open",
                        src (getCatImage card.id)] []
                Closed ->
                        img [ class "closed",
                        src (getCatImage "closed")] []
                Matched ->
                        img [ class "matched",
                        src (getCatImage card.id)] []


viewCard: Card -> Html a
viewCard card =
        div [] [
                cardImage card
                ]

viewCards: List Card -> Html a
viewCards cards =
        cards
        |> List.map viewCard
        |> div []

type CardState = Open | Closed | Matched
type alias Card =
        { id: String
        , state: CardState
        }

card: Card
card = { id = "1"
       , state = Open
       }

cards: List Card
cards = [{ id = "1"
        , state = Open
        },
        { id = "2"
        , state = Matched
        },
        { id = "3"
        , state = Closed
        }]

main =
        viewCards cards
