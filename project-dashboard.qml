import QtQuick 2.2
import "bubblewrap"
import "udata"
import "model"
import "qml-material" as Material
import "qml-material/Transitions" as MaterialTransitions
import "qml-material/ListItems" as ListItem
import "qml-extras"
import "ui"
import "udata"

import io.thp.pyotherside 1.3

Material.PageApplication {
    id: app

    title: "Blueprint"

    QtObject {
        id: colors

        property color red: "#e46b60"
        property color purple: "#62c395"
        property color green: "#62c395"
        property color yellow: "#f7c72a"
        property color orange: "#ff9570"
    }

    theme {
        primary: "#00bcd4"
        primaryDark: "#0097a7"
        secondary: "#ffeb3b"
    }

    initialPage: page

    Material.Page {
        id: page

        title: "Blueprint"

        tabs: [
            {
                text: "Overview",
                icon: "action/home"
            },
            {
                text:"Inbox",
                icon: "content/drafts"
            },
            {
                text:"Projects",
                icon: "awesome/cubes"
            }
        ]

        actions: [
            Material.Action {
                name: "Add"
                iconName: "content/add"
            },

            Material.Action {
                name: "Search"
                iconName: "action/search"
            },

            Material.Action {
                name: "Refresh"
                iconName: "navigation/refresh"
            },

//            Material.Action {
//                name: "User account"
//                iconName: "social/person"
//            },

            Material.Action {
                name: "Settings"
                iconName: "action/settings"
                onTriggered: pageStack.push(Qt.resolvedUrl("ui/SettingsPage.qml"))
            }
        ]

        Material.TabView {
            id: tabView
            anchors.fill: parent
            currentIndex: toolbar.selectedTab

            model: tabs
        }

        VisualItemModel {
            id: tabs
            Item {
                width: tabView.width
                height: tabView.height

                ColumnFlow {

                    anchors {
                        left: parent.left
                        top: parent.top
                        right: sidebar.left

                        margins: units.dp(16)/2
                    }

                    columnWidth: units.dp(300)

                    model: [
                        {
                            title: "Projects",
                            subTitle: 'Your Favorites',
                            color: 'gray',
                            icon: "awesome/cube",
                            items: [
                                {
                                    text: "Super Cool App",
                                    subText: "iBeliever/demo-app"
                                }

                            ]
                        },{
                            title: "Issues",
                            subTitle: "Assigned to You",
                            color: colors.red,
                            icon: "awesome/bug",
                            items: [
                                {
                                    text: "<b>#1</b> Main home page",
                                    subText: "Version 0.1"
                                }

                            ]
                        },

                        {
                            title: "Events",
                            subTitle: "Upcoming Today",
                            color: colors.yellow,
                            icon: "action/event",
                            items: [
                                {
                                    text: "Standup @ " + htmlColor("2:00 PM", "#2baf2b"),
                                    subText: "Cool Project"
                                },

                                {
                                    text: "Tech Talk @ " + htmlColor("3:00 PM", "#2baf2b"),
                                    subText: "Sample App"
                                }
                            ]
                        },

                        {
                            title: "Tasks",
                            subTitle: "Upcoming Today",
                            color: colors.green,
                            icon: "action/done",
                            items: [
                                {
                                    text: "Automatically refresh",
                                    subText: "Blueprint"
                                },

                                {
                                    text: "Handle failures",
                                    subText: "Blueprint"
                                }
                            ]
                        }
                    ]

                    delegate: Item {
                        height: card.height + units.dp(16)

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
                                    text: "<b>" + modelData.title + "<b>" // "File uploaded"
                                    subText: modelData.subTitle

                                    showDivider: true
                                    dividerInset: 0

                                    action: Rectangle {
                                        anchors.fill: parent
                                        color: modelData.color ? modelData.color : "gray"
                                        radius: width/2

                                        Material.Icon {
                                            anchors.centerIn: parent
                                            //anchors.horizontalCenterOffset: units.gu(0.1)
                                            size: units.dp(27)
                                            name: modelData.icon
                                            color: "white"
                                        }
                                    }
                                }

                                Repeater {
                                    id: repeater
                                    model: modelData.items

                                    delegate: ListItem.Subtitled {
                                        text: modelData.text
                                        subText: modelData.subText
                                        showDivider: index < repeater.count - 1
                                    }
                                }
                            }
                        }
                    }
                }

                Material.Sidebar {
                    id: sidebar

                    mode: "right"

                    backgroundColor: "white"

                    Column {
                        width: parent.width

                        ListItem.Header {
                            text: "Recent Activity"
                        }

                        ListItem.Subtitled {
                            text: "Wireframes.psd" // "File uploaded"
                            subText: "Random Designer"

                            action: Rectangle {
                                anchors.fill: parent
                                color: "gray"
                                radius: width/2

                                Material.Icon {
                                    anchors.centerIn: parent
                                    name: "editor/insert_drive_file"
                                    color: "white"
                                    size: units.dp(27)
                                }
                            }
                        }

                        ListItem.Subtitled {
                            text: "Main home screen"
                            subText: "John Doe"

                            action: Rectangle {
                                anchors.fill: parent
                                color: colors.red
                                radius: width/2

                                Material.Icon {
                                    anchors.centerIn: parent
                                    //anchors.horizontalCenterOffset: units.gu(0.1)
                                    name: "awesome/bug"
                                    color: "white"
                                    size: units.dp(27)
                                }
                            }
                        }

                        ListItem.Subtitled {
                            text: "5 new commits"
                            subText: "Sample User"

                            action: Rectangle {
                                anchors.fill: parent
                                color: "#039be5" // "#e84e40"
                                radius: width/2

                                Material.Icon {
                                    anchors.centerIn: parent
                                    //anchors.horizontalCenterOffset: units.gu(0.1)
                                    name: "awesome/code"
                                    color: "white"
                                    size: units.dp(27)
                                }
                            }
                        }
                    }
                }
            }

            InboxView {
                width: tabView.width
                height: tabView.height
            }

            ProjectsView {
                width: tabView.width
                height: tabView.height
            }
        }
    }

    function htmlColor(text, color) {
        print("<font color=\"%1\">%2</font>".arg(color).arg(text))
        return "<font color=\"%1\">%2</font>".arg(color).arg(text)
    }

    GitHubService {
        id: github
        _db: database
    }

    Database {
        id: database
        name: "com.sonrisesoftware.blueprint"
        description: "Blueprint"
        modelPath: Qt.resolvedUrl('model')
    }
}

