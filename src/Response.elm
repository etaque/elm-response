module Response exposing (..)

{-|
Response utilities for Elm Architecture. Build responses from tasks, pipe them, map over.

# Construct
@docs Response, res, taskRes, withCmd, withTask, withNone

# Transform
@docs mapModel, mapCmd, mapBoth
-}

-- import Platform exposing (Cmd, Never)

import Task exposing (Task)


{-| A response is an updated model and some cmd.
-}
type alias Response model msg =
    ( model, Cmd msg )


{-| Canonical usage: construct a result from model and cmd.
-}
res : model -> Cmd msg -> Response model msg
res model cmd =
    ( model, cmd )


{-| Construct a response from a model and task.
-}
taskRes : model -> (Result x a -> msg) -> Task x a -> Response model msg
taskRes model handleResult task =
    res model (Task.attempt handleResult task)


{-| Construct a result from model and cmd, flipped for piping:

    { model | foo = bar }
      |> withCmd someCmd
-}
withCmd : Cmd a -> m -> Response m a
withCmd cmd model =
    res model cmd


{-| Construct a result from model and task, flipped for piping:

    { model | foo = bar }
      |> withTask someTask
-}
withTask : (Result x a -> msg) -> Task x a -> model -> Response model msg
withTask handleResult task model =
    taskRes model handleResult task


{-| Construct a result from model without cmd, flipped for piping:

    { model | foo = bar }
      |> withNone
-}
withNone : m -> Response m a
withNone model =
    res model Cmd.none


{-| Map over model.
-}
mapModel : (m -> n) -> Response m a -> Response n a
mapModel onModel =
    mapBoth onModel identity


{-| Map over cmd.
-}
mapCmd : (a -> b) -> Response m a -> Response m b
mapCmd onCmd =
    mapBoth identity onCmd


{-| Map over model and cmd.
-}
mapBoth : (m -> n) -> (a -> b) -> Response m a -> Response n b
mapBoth onModel onCmd ( m, fx ) =
    res (onModel m) (Cmd.map onCmd fx)
