module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array
import Common exposing (..)
import API exposing (getVideos)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateActiveVideo video ->
            ( { model | activeVideo = video }, Cmd.none )

        UpdateSearch query ->
            ( { model | searchTerm = query }, Cmd.none )

        SearchForVideos ->
            ( model, getVideos model.searchTerm )

        VideoResponse (Ok payload) ->
            ( { model | videos = Array.toList payload }, Cmd.none )

        VideoResponse (Err error) ->
            ( { model | error = toString error }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


searchView : Model -> Html Msg
searchView model =
    div [ class "search-bar form-inline" ]
        [ input [ class "form-control", onInput UpdateSearch ] []
        , button [ class "btn hidden-sm-down", onClick SearchForVideos ]
            [ span [ class "glyphicon glyphicon-search" ] []
            ]
        ]


navView : Model -> Html Msg
navView model =
    nav [ class "navbar" ]
        [ div [ class "col-md-6 col-md-offset-3" ]
            [ (searchView model)
            ]
        ]


videoPlayerView : Model -> Html Msg
videoPlayerView model =
    div [ class "video-player" ]
        [ div [ class "embed-responsive embed-responsive-16by9" ]
            [ iframe
                [ class "embed-responsive-item"
                , src (urlFromid model.activeVideo.id)
                , attribute "allowFullScreen" "true"
                ]
                []
            ]
        , div [ class "video-player-details" ]
            [ h3 [] [ text model.activeVideo.title ]
            , div [] [ text model.activeVideo.description ]
            ]
        ]


videoListEntryView : Video -> Html Msg
videoListEntryView video =
    div [ class "video-list-entry media" ]
        [ div [ class "media-left media-middle" ]
            [ img [ class "media-object", src video.thumbnail, alt video.title ] []
            ]
        , div [ class "media-body" ]
            [ div [ class "video-list-entry-title", onClick <| UpdateActiveVideo video ] [ text video.title ]
            , div [ class "video-list-entry-detail" ] [ text video.description ]
            ]
        ]


videoListView : Model -> Html Msg
videoListView model =
    div [ class "video-list" ] (List.map (videoListEntryView) model.videos)


view : Model -> Html Msg
view model =
    div []
        [ (navView model)
        , div [ class "row" ]
            [ div [ class "col-md-7" ]
                [ (videoPlayerView model)
                ]
            , div [ class "col-md-5" ]
                [ (videoListView model)
                ]
            ]
        ]


urlFromid : String -> String
urlFromid id =
    "https://www.youtube.com/embed/" ++ id ++ "?autoplay=1"



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
