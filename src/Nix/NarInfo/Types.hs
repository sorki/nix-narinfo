{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE DeriveAnyClass    #-}

module Nix.NarInfo.Types
    ( -- * Types
      NarInfo(..)
    ) where

import Data.Set (Set)
import Data.Text (Text)
import Data.Aeson (FromJSON, ToJSON)
import Data.Swagger (ToSchema)
import GHC.Generics

-- NarInfo URL includes storePath hash and .narinfo suffix
-- XXX: storePath is with prefix but references are shortRefs (without prefix)
data NarInfo fp txt = NarInfo
  { -- | Absolute path of the derivation in nix store.
    storePath   :: fp
  , -- | Relative url (to current domain) to download nar file.
    url         :: txt
  , -- | Name of the compression algorithm, eg. xz.
    compression :: txt
  , -- | Hash of the compressed nar file.
    -- NOTE: to compute use "nix-hash --type sha256 --flat"
    -- (srk) this isn't fixed to sha256 e.g.: sha256:1a6lzf...
    fileHash    :: txt
  , -- | File size of compressed nar file.
    -- NOTE: du -b
    fileSize    :: Integer
  , -- | Hash of the decompressed nar file.
    -- NOTE: to compute use "nix-hash --type sha256 --flat --base32"
    -- (srk) this isn't fixed to sha256 e.g.: sha256:1a6lzf...
    narHash     :: txt
  , -- | File size of decompressed nar file.
    -- NOTE: du -b
    narSize     :: Integer
  , -- | Immediate dependencies of the storePath.
    -- NOTE: nix-store -q --references
    references  :: Set fp
  , -- | Relative store path (to nix store root) of the deriver.
    -- NOTE: nix-store -q --deriver
    deriver     :: Maybe txt
  , -- | System
    system      :: Maybe txt
  , -- | Signature of fields: storePath, narHash, narSize, refs.
    sig         :: Maybe txt
  , -- | Content-addressed
    -- Store path is computed from a cryptographic hash
    -- of the contents of the path, plus some other bits of data like
    -- the "name" part of the path.
    ca          :: Maybe txt
  }
  deriving (Generic, Show)

-- {-# LANGUAGE StandaloneDeriving #-}
-- {-# LANGUAGE FlexibleInstances #-}
--
-- deriving instance ToSchema (NarInfo FilePath Text)
-- deriving instance FromJSON (NarInfo FilePath Text)
-- deriving instance ToJSON   (NarInfo FilePath Text)
--
-- for Domen ^^
