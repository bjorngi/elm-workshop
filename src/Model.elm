module Model exposing (Card, CardState(..), Deck, GameState(..), Group(..), Model, Msg(..))


type CardState
    = Open
    | Closed
    | Matched


type Group
    = A
    | B


type alias Deck =
    List Card


type alias Card =
    { id : String
    , state : CardState
    , group : Group
    }


type Msg
    = CardClick Card


type alias Model =
    { deck : Deck
    , gameState : GameState
    }


type GameState
    = Choosing
    | Matching
    | GameOver
