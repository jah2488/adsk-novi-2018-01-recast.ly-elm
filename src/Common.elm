module Common exposing (..)

import Http
import Array


type alias Model =
    { activeVideo : Video, searchTerm : String, videos : List Video, error : String }


type alias Video =
    { title : String, description : String, thumbnail : String, id : String }


type APIKey
    = APIKey String


type Msg
    = SearchForVideos
    | UpdateSearch String
    | UpdateActiveVideo Video
    | VideoResponse (Result Http.Error (Array.Array Video))
    | NoOp


dvd : Video
dvd =
    { title = "NEVER GONNA"
    , description = "Nope"
    , thumbnail = "https://i.ytimg.com/vi/dQw4w9WgXcQ/default.jpg"
    , id = "dQw4w9WgXcQ"
    }


init : ( Model, Cmd Msg )
init =
    ( { activeVideo = dvd
      , searchTerm = ""
      , error = ""
      , videos = [ dvd, dvd, dvd, dvd, dvd, dvd ]
      }
    , Cmd.none
    )
