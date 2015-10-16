{-# LANGUAGE RecordWildCards #-}

module Main where

import Network.HTTP
import System.Environment

appConfig :: Config
appConfig = Config {
  keyEnv = "API_SECRET_KEY",
  routeEnv = "API_ROUTE",
  key = "",
  route = ""
}

data Config = Config {
  keyEnv :: String,
  routeEnv :: String,
  key :: String,
  route :: String
} deriving Show

populateConfigFromEnv :: Config -> IO Config
populateConfigFromEnv c@Config{..} = do
  k <- getEnv keyEnv
  r <- getEnv routeEnv
  return $ c { key = k, route = r}

main :: IO ()
main = do
  config <- populateConfigFromEnv appConfig
  print config
  print "It compiles!"
