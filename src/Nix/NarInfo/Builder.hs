{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE OverloadedStrings #-}

module Nix.NarInfo.Builder
    ( -- * Builder
      buildNarInfo
    , buildNarInfo'
    ) where

import Data.Set (Set)
import Data.Text (Text)
import Data.Text.Lazy.Builder (Builder)
import Nix.NarInfo.Types

import qualified Control.Applicative
import qualified Data.Char
import qualified Data.Set
import qualified Data.List
import qualified Data.Text
import qualified Data.Text.Lazy.Builder

buildNarInfo = buildNarInfo'
  Data.Text.Lazy.Builder.fromString
  Data.Text.Lazy.Builder.fromText

buildNarInfo' :: (fp -> Builder)
             -> (txt -> Builder)
             -> NarInfo fp txt
             -> Builder
buildNarInfo' filepath string (NarInfo{..}) =
     keyPath "StorePath"   storePath
  <> key     "URL"         url
  <> key     "Compression" compression
  <> key     "FileHash"    fileHash
  <> keyNum  "FileSize"    fileSize
  <> key     "NarHash"     narHash
  <> keyNum  "NarSize"     narSize

  -- XXX: strip prefixes?
  <> key'    "References"  (mconcat
      $ Data.List.intersperse " "
        $ map filepath
          $ Data.List.sort $ Data.Set.toList references)

  <> optKey  "Deriver"     deriver
  <> optKey  "System"      system
  <> optKey  "Sig"         sig
  <> optKey  "Ca"          ca
  where
    key' k v    = k <> ": " <> v <> "\n"
    key k v     = key' k (string v)
    keyNum k v  = key' k (Data.Text.Lazy.Builder.fromString . show $ v)
    keyPath k v = key' k (filepath v)
    optKey k    = maybe mempty (key k)
