# Elm Response

Response utilities in Elm Architecture. Like, build responses from tasks, pipe them, map over.


## Usage

What's in a response?

```elm
type alias Response model action = ( model, Cmd action )
```

This package offers alternate ways to construct and transform responses:

* `res` and `taskRes` for inline constructs
* `withCmd`, `withTask` and `withNone` for piped (`|>`) constructs
* `mapModel`, `mapCmd` and `mapBoth` for transformations

Typical usage examples in `update` function:

```elm
update : Action -> Model -> Response Model Action
update action model =
    case action of
    
        Foo bar baz ->
            -- ( { model | someLongFieldName = foo }, Task.perform handleResult (someTaskBuilder baz) )
            res 
                { model | someLongFieldName = foo }
                (Task.attempt handleResult (someTaskBuilder baz))
                

        Taz ->
            -- ( {model | taz = True}, Cmd.none )
            { model | taz = True }
                |> withNone

        SubAction subAction ->
            -- let 
            --     ( newSub, newSubCmd ) =
            --         subActionUpdate subAction model.sub
            -- in 
            --     ( { model | sub = newSub }, Cmd.map SubAction newSubCmd )
            subActionUpdate subAction model.sub
                |> mapBoth (\sub -> { model | sub = sub }) SubAction
```
