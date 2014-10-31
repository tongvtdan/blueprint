import QtQuick 2.0
import "../qml-material" as Material
import "../qml-material/ListItems" as ListItem
import "../qml-extras"

Rectangle {
    id: inbox

    property int margins: units.dp(100)

    Flickable {
        anchors.fill: parent

        ColumnFlow {
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top

                margins: units.dp(16)/2
            }

            columnWidth: units.dp(300)

            model: 4

            delegate: Item {
                height: card.height + units.dp(16)

                Material.Card {
                    id: card
                    width: parent.width - units.dp(16)
                    height: column.height

                    anchors.centerIn: parent

                    Column {
                        id: column
                        width: parent.width

                        ListItem.Subtitled {
                            text: "Blueprint"
                            subText: "iBeliever/blueprint"
                        }
                    }
                }
            }
        }
    }
}
