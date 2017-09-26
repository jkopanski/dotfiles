module Dimensions where

import XMonad.Config (Default (..))

data Dimensions = Dimensions
  { desktopWidth :: !Int
  , desktopHeight :: !Int
  , bar :: !Int
  , gap :: !Int
  }

instance Default Dimensions where
  def = Dimensions
    { desktopWidth = 1920
    , desktopHeight = 1080
    , bar = 64
    , gap = 12
    }

data DzenDim = DzenDim
  { barWidth :: !Int
  , barHeight :: !Int
  , barX :: !Int
  , barY :: !Int
  }

instance Default DzenDim where
  def = dzenDim def

dzenDim :: Dimensions -> DzenDim
dzenDim (Dimensions w h bw g) =
  DzenDim { barWidth = bw
          , barHeight = h - (2 * g)
          , barX = w - g - bw
          , barY = h - g
          }
