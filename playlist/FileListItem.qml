import QtQuick 2.4
import Ubuntu.Components 1.3
import QtMultimedia 5.6

ListItem {
    id: listitem
    property alias title: layout.title
    property alias iconName: icon.name

    height: layout.height + (divider.visible ? divider.height : 0)
    ListItemLayout {
        id: layout
        Icon {
            width: units.gu(2)
            name: "stock_music"
            SlotsLayout.position: SlotsLayout.Leading
        }

        Icon {
            id: icon
            width: units.gu(2)
            name: (player.playlist.currentIndex === index &&
                   player.playbackState === Audio.PlayingState )?
                      "media-playback-pause" :
                      "media-playback-start"
            SlotsLayout.position: SlotsLayout.Trailing
        }
    }
}
