import QtQuick 2.4
import Ubuntu.Components 1.3
import QtMultimedia 5.6

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "playlist.liu-xiao-guo"

    width: units.gu(60)
    height: units.gu(85)
    property var meta: player.metaData

    Page {
        id: page
        header: PageHeader {
            id: pageHeader
            title: i18n.tr("playlist")
        }

        Audio {
            id: player;
            autoPlay: true
            autoLoad: true
            playlist: Playlist {
                id: playlist
            }

            Component.onCompleted: {
                console.log(playlist.addItem(Qt.resolvedUrl("sounds/song1.mp3")))
                console.log(playlist.addItem(Qt.resolvedUrl("sounds/background.mp3")))
                console.log("playlist count: " + playlist.itemCount)
                console.log("metaData type: " + typeof(meta))

                console.log("The properties of metaData is:")
                var keys = Object.keys(meta);
                for( var i = 0; i < keys.length; i++ ) {
                    var key = keys[ i ];
                    var data = key + ' : ' + meta[ key ];
                    console.log( key + ": " + data)
                }

                play()
            }
        }

        Flickable {
            anchors {
                left: parent.left
                right: parent.right
                top: pageHeader.bottom
                bottom: parent.bottom
            }
            contentHeight: layout.childrenRect.height +
                           layout1.height + layout1.spacing

            Column {
                id: layout
                anchors.fill: parent

                ListView {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: page.height/2

                    model: playlist;
                    delegate: FileListItem {
//                        fontSize: "x-large"
                        title.text: {
                            var filename = String(source);
                            var name = filename.split("/").pop();
                            return name;
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                if (player.playbackState != Audio.PlayingState) {
                                    player.playlist.currentIndex = index;
                                    player.play();
                                } else {
                                    player.pause();
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: units.gu(0.1)
                    color: "red"
                }

                Slider {
                    id: defaultSlider
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width * 0.8
                    maximumValue: 100
                    value: player.position/player.duration * maximumValue
                }

                CustomListItem {
                    title.text:  {
                        switch (player.availability ) {
                        case Audio.Available:
                            return "availability: available";
                        case Audio.Busy:
                            return "availability: Busy";
                        case Audio.Unavailable:
                            return "availability: Unavailable";
                        case Audio.ResourceMissing:
                            return "availability: ResourceMissing";
                        default:
                            return "";
                        }
                    }
                }

                CustomListItem {
                    title.text: "bufferProgress: " + player.bufferProgress;
                }

                CustomListItem {
                    title.text: "duration: " + player.duration/1000 + " sec"
                }

                CustomListItem {
                    title.text: "hasAudio: " + player.hasAudio
                }

                CustomListItem {
                    title.text: "hasVideo: " + player.hasVideo
                }

                CustomListItem {
                    title.text: "loops: " + player.loops
                }

                CustomListItem {
                    title.text: "muted: " + player.muted
                }

                CustomListItem {
                    title.text: "playbackRate: " + player.playbackRate
                }

                CustomListItem {
                    title.text: {
                        switch (player.playbackState) {
                        case Audio.PlayingState:
                            return "playbackState : PlayingState"
                        case Audio.PausedState:
                            return "playbackState : PausedState"
                        case Audio.StoppedState:
                            return "playbackState : StoppedState"
                        default:
                            return ""
                        }
                    }
                }

                CustomListItem {
                    title.text: "seekable: " + player.seekable
                }

                CustomListItem {
                    title.text: "url: " + String(player.source)
                }

                CustomListItem {
                    title.text: "volume: " + player.volume
                }

                CustomListItem {
                    title.text: {
                        switch (player.status) {
                        case Audio.NoMedia:
                            return "status: NoMedia"
                        case Audio.Loading:
                            return "status: Loading"
                        case Audio.Loaded:
                            return "status: Loaded"
                        case Audio.Buffering:
                            return "status: Buffering"
                        case Audio.Stalled:
                            return "status: Stalled"
                        case Audio.Buffered:
                            return "status: Buffered"
                        case Audio.EndOfMedia:
                            return "status: EndOfMedia"
                        case Audio.InvalidMedia:
                            return "status: InvalidMedia"
                        case Audio.UnknownStatus:
                            return "status: UnknownStatus"
                        default:
                            return ""
                        }
                    }
                }

            }
        }

        Row {
            id: layout1
            anchors.bottom: parent.bottom
            anchors.bottomMargin: units.gu(1)
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: units.gu(5)

            Button {
                text: "Previous"
                onClicked: {
                    console.log("Previouse is clicked")
                    var previousIndex = player.playlist.previousIndex(1)
                    console.log("previousIndex: " + player.playlist.previousIndex(1))
                    if ( previousIndex == -1 ) {
                        player.playlist.currentIndex = player.playlist.itemCount - 1;
                    } else {
                        player.playlist.previous();
                    }

                    player.play()
                }
            }

            Button {
                text: "Next"
                onClicked: {
                    console.log("Next is clicked")
                    var nextIndex = player.playlist.nextIndex(1)
                    console.log("nextIndex: " + nextIndex )
                    if (nextIndex == -1) {
                        player.playlist.currentIndex = 0
                    } else {
                        player.playlist.next();
                    }

                    player.play();
                }
            }
        }
    }
}

