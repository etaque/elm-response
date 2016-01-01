module Vespa.Response (..) where

{-|
Response utilities in Elm Architecture. Build responses from tasks, pipe them, map over.

# Construct
@docs Response, res, taskRes, withEffects, withTask, withNone

# Map over
@docs mapBoth, mapModel, mapEffects
-}

import Effects exposing (Effects, Never)
import Task exposing (Task)


{-| A response is an updated model and some effects. -}
type alias Response model action = (model, Effects action)


{-| Construct a result from model and effects. -}
res : m -> Effects a -> Response m a
res model effects =
  (model, effects)

{-| Construct a result from model and task. -}
taskRes : m -> Task Never a -> Response m a
taskRes model task =
  res model (Effects.task task)

{-| Construct a result from model and effects, flipped for piping:

    { model | foo = bar }
      |> withEffects someEffects
 -}
withEffects : Effects a -> m -> Response m a
withEffects effects model =
  res model effects

{-| Construct a result from model and task, flipped for piping:

    { model | foo = bar }
      |> withTask someTask
 -}
withTask : Task Never a -> m -> Response m a
withTask task model =
  taskRes model task

{-| Construct a result from model without effects, flipped for piping:

    { model | foo = bar }
      |> withNone
 -}
withNone : m -> Response m a
withNone model =
  res model Effects.none

{-| Map over model and effects. -}
mapBoth : (m -> m') -> (a -> a') -> Response m a -> Response m' a'
mapBoth onModel onEffects (m, fx) =
  res (onModel m) (Effects.map onEffects fx)

{-| Map over model. -}
mapModel : (m -> m') -> Response m a -> Response m' a
mapModel onModel =
  mapBoth onModel identity

{-| Map over effects. -}
mapEffects : (a -> a') -> Response m a -> Response m a'
mapEffects onEffects =
  mapBoth identity onEffects

