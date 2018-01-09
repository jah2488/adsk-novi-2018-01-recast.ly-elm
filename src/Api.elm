module API exposing (..)

import Json.Decode as Decode
import Http
import Array
import Common exposing (..)


apiKey : APIKey
apiKey =
    APIKey "AIzaSyA4TxSoQxWifHImSSG6l9nj6iBcvjCzZE0"


keyToString : APIKey -> String
keyToString (APIKey apikey) =
    apikey


maxResults : String
maxResults =
    "10"


getVideos : String -> Cmd Msg
getVideos searchTerm =
    let
        url =
            "https://www.googleapis.com/youtube/v3/search/?q="
                ++ searchTerm
                ++ "&maxResults="
                ++ maxResults
                ++ "&key="
                ++ (keyToString apiKey)
                ++ "&part="
                ++ "snippet"

        request =
            Http.get url responseDecoder
    in
        Http.send VideoResponse request


responseDecoder : Decode.Decoder (Array.Array Video)
responseDecoder =
    Decode.at [ "items" ] (Decode.array videoDecoder)


videoDecoder : Decode.Decoder Video
videoDecoder =
    Decode.map4 Video
        (Decode.at [ "snippet", "title" ] Decode.string)
        (Decode.at [ "snippet", "description" ] Decode.string)
        (Decode.at [ "snippet", "thumbnails", "default", "url" ] Decode.string)
        (Decode.at [ "id", "videoId" ] Decode.string)
