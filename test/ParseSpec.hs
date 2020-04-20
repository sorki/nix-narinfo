{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module ParseSpec where

import SpecHelper

spec :: Spec
spec = do
  return ()
  {--
  it "parses samples" $ do
    mapM_ (\x -> (decode . encode) x `shouldBe` x) testCases
    (decode . fst $ B16L.decode "018806765ff2960a0003e8") `shouldBe` (1, GPS 42.3519 (-87.9094) 10.0)
    (decode . fst $ B16L.decode "067104D2FB2E0000")       `shouldBe` (6, Accelerometer 1.234 (-1.234) 0.0)
    (decode . fst $ B16L.decode "0167FFD7")               `shouldBe` (1, Temperature (-4.1))
    (decode . fst $ B16L.decode "03670110056700FF")       `shouldBe` (3, Temperature 27.2)

    (decodeMany . fst $ B16L.decode "018806765ff2960a0003e8067104D2FB2E00000167FFD703670110056700FF")
      `shouldBe`
      [(1, GPS 42.3519 (-87.9094) 10.0), (6, Accelerometer 1.234 (-1.234) 0.0), (1,Temperature (-4.1)), (3,Temperature 27.2), (5,Temperature 25.5)]
  --}

main :: IO ()
main = hspec spec
