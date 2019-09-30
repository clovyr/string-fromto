{-|
Have you ever found yourself frustrated that you're spending 15-30% of your
time in Haskell converting between string types, remembering which module has
the `toStrict` function, importing Data.Text.Encoding and
Data.Text.Lazy.Encoding qualified, spending time thinking about how to do
Base64 encoding, etc.? Or tried to use one of the (excellent) typeclass-based
string conversion libraries, only to find yourself adding awkward type
signatures to avoid type-inferencing ambiguities?

This module exports a collection of functions that follow a simple pattern:

@stringTypeAToStringTypeB :: a -> b@

This way, if you import this module unqualified, or as part of your Prelude,
all you have to think about is which type you want to convert into which
other type.

For convenience, this module also exposes conversions between Base16, Base32,
and Base64-encoded strings.

Note:

  - Not *every* possible permutation has a function, just each one we've ever
    needed. If you need one that's not included, please submit a pull request
    to add it.

  - When converting a Text to and from ByteString, UTF-8 is used.
-}
module Data.String.FromTo where

import Data.ByteArray.Encoding (Base(..), convertFromBase, convertToBase)
import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as BC
import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString.Lazy.Char8 as BLC
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import qualified Data.Text.Lazy as TL
import qualified Data.Text.Lazy.Encoding as TLE

-- * ByteString to...
base16ByteStringToByteString :: ByteString -> Either String ByteString
base16ByteStringToByteString = convertFromBase Base16

base32ByteStringToByteString :: ByteString -> Either String ByteString
base32ByteStringToByteString = convertFromBase Base32

base64ByteStringToByteString :: ByteString -> Either String ByteString
base64ByteStringToByteString = convertFromBase Base64

base64UrlByteStringToByteString :: ByteString -> Either String ByteString
base64UrlByteStringToByteString = convertFromBase Base64URLUnpadded

base64ByteStringToText :: ByteString -> Either String Text
base64ByteStringToText = fmap byteStringToText . base64ByteStringToByteString

byteStringToBase16ByteString :: ByteString -> ByteString
byteStringToBase16ByteString = convertToBase Base16

byteStringToBase32ByteString :: ByteString -> ByteString
byteStringToBase32ByteString = convertToBase Base32

byteStringToBase64ByteString :: ByteString -> ByteString
byteStringToBase64ByteString = convertToBase Base64

byteStringToBase64UrlByteString :: ByteString -> ByteString
byteStringToBase64UrlByteString = convertToBase Base64URLUnpadded

byteStringToBase32Text :: ByteString -> Text
byteStringToBase32Text = byteStringToText . byteStringToBase32ByteString

byteStringToBase64Text :: ByteString -> Text
byteStringToBase64Text = byteStringToText . byteStringToBase64ByteString

byteStringToLazyByteString :: ByteString -> BL.ByteString
byteStringToLazyByteString = BL.fromStrict

byteStringToString :: ByteString -> String
byteStringToString = BC.unpack

byteStringToText :: ByteString -> Text
byteStringToText = TE.decodeUtf8

lazyByteStringToByteString :: BL.ByteString -> ByteString
lazyByteStringToByteString = BL.toStrict

lazyByteStringToString :: BL.ByteString -> String
lazyByteStringToString = textToString . lazyByteStringToText

lazyByteStringToText :: BL.ByteString -> Text
lazyByteStringToText = TL.toStrict . TLE.decodeUtf8

-- * Text to...
base16TextToByteString :: Text -> Either String ByteString
base16TextToByteString = base16ByteStringToByteString . textToByteString

base32TextToByteString :: Text -> Either String ByteString
base32TextToByteString = base32ByteStringToByteString . textToByteString

base64TextToByteString :: Text -> Either String ByteString
base64TextToByteString = base64ByteStringToByteString . textToByteString

lazyTextToString :: TL.Text -> String
lazyTextToString = TL.unpack

lazyTextToText :: TL.Text -> Text
lazyTextToText = TL.toStrict

textToBase16ByteString :: Text -> ByteString
textToBase16ByteString = byteStringToBase16ByteString . textToByteString

textToBase16String :: Text -> String
textToBase16String = byteStringToString . textToBase16ByteString

textToBase16Text :: Text -> Text
textToBase16Text = byteStringToText . textToBase16ByteString

textToBase32ByteString :: Text -> ByteString
textToBase32ByteString = byteStringToBase32ByteString . textToByteString

textToBase32String :: Text -> String
textToBase32String = byteStringToString . textToBase32ByteString

textToBase32Text :: Text -> Text
textToBase32Text = byteStringToText . textToBase32ByteString

textToBase64ByteString :: Text -> ByteString
textToBase64ByteString = byteStringToBase64ByteString . textToByteString

textToBase64String :: Text -> String
textToBase64String = byteStringToString . textToBase64ByteString

textToBase64Text :: Text -> Text
textToBase64Text = byteStringToText . textToBase64ByteString

textToByteString :: Text -> ByteString
textToByteString = TE.encodeUtf8

textToLazyByteString :: Text -> BL.ByteString
textToLazyByteString = byteStringToLazyByteString . textToByteString

textToLazyText :: Text -> TL.Text
textToLazyText = TL.fromStrict

textToString :: Text -> String
textToString = T.unpack

-- * String to...
stringToByteString :: String -> ByteString
stringToByteString = BC.pack

stringToLazyByteString :: String -> BL.ByteString
stringToLazyByteString = BLC.pack

stringToLazyText :: String -> TL.Text
stringToLazyText = TL.pack

stringToText :: String -> Text
stringToText = T.pack
