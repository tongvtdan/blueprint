import QtQuick 2.0
import "../qml-material" as Material
import "../qml-material/ListItems" as ListItem
import "../qml-extras"
import "../qml-material/transitions"
import "../udata"
import "../model"

Item {
    id: projectsView

    property int margins: units.dp(100)

    property var platforms: ["github", "assembla", "launchpad"]

    Flickable {
        id: flickable
        anchors.fill: parent

        contentWidth: width
        contentHeight: content.height

        Column {
            id: content
            anchors {
                left: parent.left
                right: parent.right
            }

            Item {
                width: 1
                height: units.dp(8)
            }

            Repeater {
                model: projectsView.platforms

                delegate: Column {
                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    ListItem.Header {
                        text: modelData
                    }

                    ColumnFlow {
                        anchors {
                            left: parent.left
                            right: parent.right

                            margins: units.dp(16)/2
                        }

                        columnWidth: units.dp(250)

                        model: query

                        Query {
                            id: query
                            _db: database

                            type: 'Project'
                            sortBy: 'name'
                            predicate: "id IN (SELECT projectId FROM Repository " +
                                       "WHERE type = '%1')".arg(modelData)
                        }

                        delegate: Item {
                            height: card.height + units.dp(16)

                            property Project project: modelData

                            Material.Card {
                                id: card
                                width: parent.width - units.dp(16)
                                height: column.height

                                anchors {
                                    left: parent.left
                                    right: parent.right
                                    top: parent.top
                                    margins: units.dp(16)/2
                                }

                                Column {
                                    id: column
                                    width: parent.width

                                    ListItem.Subtitled {
                                        text: project.title
                                        subText: "iBeliever/blueprint"
                                        secondaryItem: Material.AwesomeIcon {
                                            anchors {
                                                right: parent.right
                                            }

                                            property bool favorite: index == 0 || index == 2

                                            name: favorite ? 'star' : 'star-o'
                                            size: parent.height * 0.8
                                            color: favorite ? theme.secondary : 'gray'
                                        }
                                    }
                                }

                                Material.Ink {
                                    anchors.fill: parent
                                    onClicked: pageStack.pushFrom(
                                                   card,
                                                   Qt.resolvedUrl('ProjectPage.qml'),
                                                   {project: project}
                                               )
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
