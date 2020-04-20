module Main where

import Nix.NarInfo

import Data.Attoparsec.Text
import Data.Text.IO
import Data.Text.Lazy.Builder
import Data.Text.Lazy.IO

main = do
  txt <- Data.Text.IO.readFile "./test/samples/0"
  case Data.Attoparsec.Text.parseOnly parseNarInfo txt of
    Left e -> error e
    Right ni -> Data.Text.Lazy.IO.putStr $
      Data.Text.Lazy.Builder.toLazyText $ buildNarInfo ni
