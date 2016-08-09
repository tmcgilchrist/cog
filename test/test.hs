import           System.IO
import           System.Exit
import           Control.Monad

main :: IO ()
main = do
  hSetBuffering stdout LineBuffering
  hSetBuffering stderr LineBuffering
  sequence tests >>= \rs -> unless (and rs) exitFailure
  where
    tests = []
