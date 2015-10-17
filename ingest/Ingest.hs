{-# LANGUAGE RecordWildCards #-}

module Main where

import Network.HTTP
import System.Environment

configWiring :: ConfigWiring
configWiring = ConfigWiring {
  keyEnv = "API_SECRET_KEY",
  routeEnv = "API_ROUTE"
}

data ConfigWiring = ConfigWiring {
  keyEnv :: String,
  routeEnv :: String
}

data Config = Config {
  key :: String,
  route :: String
}

populateConfigFromEnv :: ConfigWiring -> IO Config
populateConfigFromEnv ConfigWiring{..} = do
  k <- getEnv keyEnv
  r <- getEnv routeEnv
  return $ Config { key = k, route = r}

getAllArticles Config{..} = simpleHTTP request >>= getResponseBody
  where
  request = setDetails $ getRequest route
  setDetails r = r { rqHeaders =  mkHeader HdrAuthorization ("Digest " ++ key) : rqHeaders r }

main :: IO ()
main = do
  config <- populateConfigFromEnv configWiring
  articles <- getAllArticles config
  putStrLn articles
