# string-fromto

A collection of predictably-named functions (e.g. byteStringToString) that
convert between the common string types, as well as to and from Base16, Base32,
and Base64.

## Usage

```haskell
import Data.String.FromTo -- or imported as part of your Prelude

str :: String
str = "Hi, I'm a string"

text :: Text
text = stringToText str

encoded :: ByteString
encoded = textToBase64ByteString text

decoded :: Either String Text
decoded = base64ByteStringToText encoded
```

## Documentation

[Hackage](https://hackage.haskell.org/package/string-fromto)

## License

[BSD3](LICENSE)

## Motivation

Have you ever found yourself frustrated that you're spending 15-30% of your
time in Haskell converting between string types, remembering which module has
the `toStrict` function, importing Data.Text.Encoding and
Data.Text.Lazy.Encoding qualified, spending time thinking about how to do
Base64 encoding, etc.? Or tried to use one of the (excellent) typeclass-based
string conversion libraries, only to find yourself adding awkward type
signatures to avoid type-inferencing ambiguities?

This library exports a collection of functions that follow a simple pattern:

```haskell
stringTypeAToStringTypeB :: a -> b
```

For example:

```haskell

stringToByteString :: String -> ByteString

stringToLazyByteString :: String -> Lazy.ByteString

base64ByteStringToText :: ByteString -> Either String Text
```

This way, if you import this module unqualified, or as part of your Prelude,
all you have to think about is which type you want to convert into which other
type.

(Note that not *every* possible permutation has a function, just each one we've
ever needed. If you need one that's not included, please submit a pull request
to add it.)
