# Elm Response

Response utilities in Elm Architecture. Like, build responses from tasks, pipe them, map over.


## Usage

What's in a response?

```elm
type alias Response model action = (model, Effects action)
```

This package offers alternate ways to construct and transform responses:

* `res` and `taskRes` for inline constructs
* `withEffects`, `withTask` and `withNone` for piped (`|>`) constructs
* `mapModel`, `mapEffects` and `mapBoth` for transformations

Typical usage examples in `update` function:

```elm
update : Action -> Model -> Response Model Action
update action model =
  case action of
  
    Foo bar baz ->
      -- ({ model | foo = foo }, Effects.task (someTask bar))
      taskRes { model | foo = foo } (someTask bar)
      
    Taz ->
      -- ({model | taz = True}, Effects.none)
      { model | taz = True }
        |> withNone
        
    SubAction subAction ->
      -- let (newSub, newSubEffects) = subActionUpdate subAction model.sub
      -- in (\sub -> { model | sub = newSub }) (Effects.map SubAction newSubEffects)
      subActionUpdate subAction model.sub
        |> mapBoth (\sub -> { model | sub = sub }) SubAction
```
