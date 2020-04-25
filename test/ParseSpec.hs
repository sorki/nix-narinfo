{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module ParseSpec where

import Data.Attoparsec.Text
import Data.Text.IO
import Data.Text.Lazy
import Data.Text.Lazy.Builder
import Data.Text.Lazy.IO

import SpecHelper

roundTrip fname = do
  txt <- Data.Text.IO.readFile $ "./test/samples/" ++ fname
  case Data.Attoparsec.Text.parseOnly parseNarInfo txt of
    Left e -> error e
    Right ni -> do
      let built = Data.Text.Lazy.Builder.toLazyText $ buildNarInfo ni
      (Data.Text.Lazy.toStrict built) `shouldBe` txt

spec :: Spec
spec = do
  it "roundtrips samples" $ do
    mapM_ (roundTrip . show) [0]

main :: IO ()
main = hspec spec
