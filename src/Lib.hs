{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}

module Lib where

import Control.Applicative
import Control.Monad
import Control.Monad.IO.Class
import Data.Aeson
import Data.Monoid
import Data.Proxy
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import GHC.Generics
import Servant.API
import Servant.Client

type OuraAPI =
    "userinfo" :> Get '[JSON] [UserInfo]

type Email = Text

data Gender = Male | Female
    deriving (Eq, Show, Generic)

instance FromJSON Gender

instance ToJSON Gender

data UserInfo = UserInfo
    { age :: Int,
      weight :: Int,
      gender :: Gender,
      email :: Email
    }
    deriving (Eq, Show)

instance FromJSON UserInfo where
    parseJSON (Object o) =
        UserInfo <$> o .: "age"
            <*> o .: "weight"
            <*> o .: "gender"
            <*> o .: "email"
    parseJSON _ = mzero