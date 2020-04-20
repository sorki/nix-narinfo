{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE OverloadedStrings #-}

module Nix.NarInfo.Parser
  ( -- * Parser
    parseNarInfo
  , parseNarInfo'
  ) where

import Data.Set (Set)
import Data.Text (Text)
import Data.Attoparsec.Text (Parser)
import Nix.NarInfo.Types

import qualified Control.Applicative
import qualified Data.Char
import qualified Data.Set
import qualified Data.Text
import qualified Data.Attoparsec.Text

parseNarInfo :: Parser (NarInfo FilePath Text)
parseNarInfo = parseNarInfo' pathParse textParse

textParse = Data.Attoparsec.Text.takeWhile (not . Data.Char.isSpace)
pathParse = Data.Text.unpack <$> textParse

parseNarInfo' :: (Ord fp) => Parser fp -> Parser txt -> Parser (NarInfo fp txt)
parseNarInfo' pathParser textParser = do
  storePath   <- keyPath "StorePath"
  url         <- key     "URL"
  compression <- key     "Compression"
  fileHash    <- key     "FileHash"
  fileSize    <- keyNum  "FileSize"
  narHash     <- key     "NarHash"
  narSize     <- keyNum  "NarSize"
  -- XXX add prefix for these (the same as storePath I hope)
  references  <- Data.Set.fromList <$> (parseKey "References" $
    pathParser `Data.Attoparsec.Text.sepBy` Data.Attoparsec.Text.char ' ')

  deriver     <- optKey "Deriver"
  system      <- optKey "System"
  sig         <- optKey "Sig"
  ca          <- optKey "Ca"

  return $ NarInfo {..}
  where
    parseKey key parser = do
      Data.Attoparsec.Text.string key
      Data.Attoparsec.Text.string ": "
      out <- parser
      Data.Attoparsec.Text.char '\n'
      return out

    key = flip parseKey textParser
    optKey = Control.Applicative.optional . key
    keyNum x = parseKey x Data.Attoparsec.Text.decimal
    keyPath x = parseKey x pathParser
