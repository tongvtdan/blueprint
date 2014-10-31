import QtQuick 2.0
import "../qml-material" as Material
import "../qml-material/ListItems" as ListItem
import "../qml-extras"

Rectangle {
    id: projectsView

    property int margins: units.dp(100)

    property var platforms: ["GitHub", "Assembla", "Launchpad"]

    Flickable {
        id: flickable
        anchors.fill: parent

        contentWidth: width
        contentHeight: content.height

        Column {
            id: content
            width: parent.width

            Item {
                width: 1
                height: units.dp(8)
            }

            Repeater {
                model: projectsView.platforms

                delegate: Column {
                    width: parent.width

                    ListItem.Header {
                        text: modelData
                    }

                    ColumnFlow {
                        anchors {
                            left: parent.left
                            right: parent.right

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

            Item {
                width: 1
                height: units.dp(8)
            }
        }
    }

    Material.Scrollbar {
        flickableItem: flickable
    }
}
