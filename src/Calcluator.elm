port module Main exposing (main)

import Browser
import Html.Attributes
import Html.Events
import Html exposing (Html)


-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init          = init
        , update        = update
        , view          = view
        , subscriptions = subscriptions
        }

-- INIT


init : flags -> ( Model, Cmd Msg )
init flags =
    ( { operation = Noop
      , carry     = Carry "0"
      , total     = Total "0"
      }
    , Cmd.none
    )


type alias Model =
    { operation : Operation
    , carry     : Carry
    , total     : Total
    }


type Operation
    = Add
    | Subtract
    | Divide
    | Multiply
    | Modulo
    | Noop


type Carry =
    Carry String


type Total =
    Total String


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Append digit ->
            ( { model | total = appendDigit digit model.total }, onClick () )

        Equals ->
            ( { model
              | total     = totalFromOperation model.operation model.total model.carry
              , carry     = Carry "0"
              , operation = Noop
              }
            , onClick ()
            )

        SetOperation operation ->
            ( { model
              | operation = operation
              , carry     = carryFromOperation operation model.total model.carry
              , total     = Total "0"
              }
            , onClick ()
            )

        Clear ->
            ( { operation = Noop, carry = Carry "0", total = Total "0" }, onClick () )

        Dot ->
            ( { model | total = appendDot model.total }, onClick () )

        Del ->
            ( { model | total = deleteLastCharacter model.total }, onClick () )

        Inverse ->
            ( { model | total = inverse model.total }, onClick () )


type Msg
    = Append Char
    | SetOperation Operation
    | Equals
    | Clear
    | Dot
    | Del
    | Inverse


divideOrZero : Float -> Float -> Float
divideOrZero a b =
    if b == 0 then
        0

    else
        a / b


moduloOrZero : Int -> Int -> Int
moduloOrZero first second =
    case second of
        0 ->
            0

        nonZero ->
            modBy nonZero first


computeFromOperation : Operation -> Total -> Carry -> String
computeFromOperation operation (Total total) (Carry carry) =
    if carry == "0" then
        total

    else
        case operation of
            Add ->
                total
                    |> String.toFloat
                    |> Maybe.withDefault 0
                    |> (+) (carry |> String.toFloat |> Maybe.withDefault 0)
                    |> String.fromFloat

            Subtract ->
                total
                    |> String.toFloat
                    |> Maybe.withDefault 0
                    |> (-) (carry |> String.toFloat |> Maybe.withDefault 0)
                    |> String.fromFloat

            Divide ->
                total
                    |> String.toFloat
                    |> Maybe.withDefault 0
                    |> divideOrZero (carry |> String.toFloat |> Maybe.withDefault 0)
                    |> String.fromFloat

            Multiply ->
                total
                    |> String.toFloat
                    |> Maybe.withDefault 0
                    |> (*) (carry |> String.toFloat |> Maybe.withDefault 0)
                    |> String.fromFloat

            Modulo ->
                total
                    |> String.toInt
                    |> Maybe.withDefault 0
                    |> moduloOrZero (carry |> String.toInt |> Maybe.withDefault 0)
                    |> String.fromInt

            Noop ->
                total
                    |> String.toFloat
                    |> Maybe.withDefault 0
                    |> String.fromFloat


totalFromOperation : Operation -> Total -> Carry -> Total
totalFromOperation operation total carry =
    computeFromOperation operation total carry
        |> Total


carryFromOperation : Operation -> Total -> Carry -> Carry
carryFromOperation operation total carry =
    computeFromOperation operation total carry
        |> Carry


appendDigit : Char -> Total -> Total
appendDigit digit (Total total) =
    case total of
        "0" ->
            digit
                |> String.fromChar
                |> Total

        nonZeroTotal ->
            digit
                |> String.fromChar
                |> (++) total
                |> Total


appendDot : Total -> Total
appendDot (Total total) =
    if String.contains "." total then
        Total total

    else
        "."
            |> (++) total
            |> Total


totalToString : Total -> String
totalToString (Total total) =
    total


carryToString : Carry -> String
carryToString (Carry carry) =
    carry


deleteLastCharacter : Total -> Total
deleteLastCharacter (Total total) =
    if String.length total == 1 then
        Total "0"

    else
        total
            |> String.dropRight 1
            |> Total

inverse : Total -> Total
inverse (Total total) =
    total
        |> String.toFloat
        |> Maybe.withDefault 0
        |> negate
        |> String.fromFloat
        |> Total


-- VIEW


view : Model -> Html Msg
view model =
    Html.div
        [ Html.Attributes.id "body" ]
        [ Html.header
            []
            [ Html.p [] [ Html.text <| carryToString model.carry ]
            , Html.p [] [ Html.text <| totalToString model.total ]
            ]
        , Html.main_
            []
            [ Html.section
                []
                [ Html.button [ Html.Events.onClick Clear ] [ Html.text "A/C" ]
                , Html.button [ Html.Events.onClick Inverse ] [ Html.text "+/-" ]
                , Html.button [ Html.Events.onClick (SetOperation Modulo) ] [ Html.text "%" ]
                , Html.button [ Html.Events.onClick (SetOperation Divide) ] [ Html.text "/" ]
                ]
            , Html.section
                []
                [ Html.button [ Html.Events.onClick (Append '7') ] [ Html.text "7" ]
                , Html.button [ Html.Events.onClick (Append '8') ] [ Html.text "8" ]
                , Html.button [ Html.Events.onClick (Append '9') ] [ Html.text "9" ]
                , Html.button [ Html.Events.onClick (SetOperation Multiply) ] [ Html.text "x" ]
                ]
            , Html.section
                []
                [ Html.button [ Html.Events.onClick (Append '4') ] [ Html.text "4" ]
                , Html.button [ Html.Events.onClick (Append '5') ] [ Html.text "5" ]
                , Html.button [ Html.Events.onClick (Append '6') ] [ Html.text "6" ]
                , Html.button [ Html.Events.onClick (SetOperation Subtract) ] [ Html.text "-" ]
                ]
            , Html.section
                []
                [ Html.button [ Html.Events.onClick (Append '1') ] [ Html.text "1" ]
                , Html.button [ Html.Events.onClick (Append '2') ] [ Html.text "2" ]
                , Html.button [ Html.Events.onClick (Append '3') ] [ Html.text "3" ]
                , Html.button [ Html.Events.onClick (SetOperation Add) ] [ Html.text "+" ]
                ]
            , Html.section
                []
                [ Html.button [ Html.Events.onClick (Append '0') ] [ Html.text "0" ]
                , Html.button [ Html.Events.onClick Dot ] [ Html.text "." ]
                , Html.button [ Html.Events.onClick Del ] [ Html.text "del" ]
                , Html.button [ Html.Events.onClick Equals ] [ Html.text "=" ]
                ]
            ]
        ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


port onClick : () -> Cmd msg
