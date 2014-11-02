import QtQuick 2.0
import "../qml-material" as Material
import "../qml-material/ListItems" as ListItem

Item {
    id: inbox

    property int margins: units.dp(100)

    Column {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            bottom: parent.bottom

            leftMargin: parent.margins
            rightMargin: parent.margins
            topMargin: units.dp(20)
            bottomMargin :units.dp(20)
        }

        width: Math.min(parent.width, Math.max(parent.width - units.dp(100), units.dp(600)))

        Repeater {

            model: [
                {
                    name: "Today",
                    items: [
                        {
                            plugin: "Files",
                            author: "Random Designer",
                            subject: "'Designs.psd' uploaded"
                        },

                        {
                            plugin: "Files",
                            author: "John Doe",
                            subject: "'Wireframe.psd' uploaded"
                        }
                    ]
                },

                {
                    name: "Yesterday",
                    items: [
                        {
                            plugin: "Files",
                            author: "Michael Spencer",
                            subject: "'Designs.psd' uploaded"
                        },

                        {
                            plugin: "Files",
                            author: "Sample Developer",
                            subject: "'Wireframe.psd' uploaded"
                        }
                    ]
                }
            ]

            delegate: Column {
                width: parent.width

                ListItem.Header {
                    text: modelData.name
                }

                Material.Card {
                    width: parent.width
                    height: column.height
                    fullWidth: width == inbox.width

                    Column {
                        id :column
                        width: parent.width

                        Repeater {
                            id: repeater
                            model: modelData.items
                            delegate: ListItem.Subtitled {
                                text: modelData.subject
                                subText: modelData.author
                                showDivider: index < repeater.count - 1
                            }
                        }
                    }
                }
            }
        }
    }
}
