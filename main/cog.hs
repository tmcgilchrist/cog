import           Options.Applicative
import           Options.Applicative.Help.Types (ParserHelp(..))

import           System.IO
import           System.Exit
import           System.Environment (getArgs)

data Command = Command deriving (Eq, Show)

main :: IO ()
main = do
  hSetBuffering stdout LineBuffering
  hSetBuffering stderr LineBuffering
  dispatch parser >>= run

parser :: Parser Command
parser =
  pure Command

run :: Command -> IO ()
run c = case c of
  Command ->
    putStrLn "*implement me*" >> exitFailure

-- | Dispatch multi-mode programs with appropriate helper to make the
--   default behaviour a bit better.
dispatch :: Parser a -> IO a
dispatch p = getArgs >>= \x -> case x of
  [] -> let -- We don't need to see the Missing error if we're getting the whole usage string.
            removeError' (h, e, c) = (h { helpError = mempty }, e, c)
            removeError (Failure (ParserFailure failure)) = Failure (ParserFailure ( removeError' <$> failure ))
            removeError a = a
        in  execParserPure (prefs showHelpOnError) (info (p <**> helper) idm) <$> getArgs
            >>= handleParseResult . removeError
  _  -> execParser (info (p <**> helper) idm)
