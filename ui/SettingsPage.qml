import QtQuick 2.0
import "../qml-material" as Material
import "../qml-material/ListItems" as ListItem
import "../qml-material/Transitions" as Transitions
import "../qml-extras"

Material.Page {
    id: settingsPage
    visible: false

    title: 'Settings'

    transition: Transitions.CardSlideTransition {}

    actionBar.background: "gray"

    Column {
        anchors.fill: parent
        anchors.margins: units.dp(16)
        spacing: units.dp(16)

        Material.Label {
            text: "Online Accounts"
            fontStyle: "subheading"
            color: theme.blackColor('secondary')
        }

        ListItem.Subtitled {
            text: github.user.name
            subText: github.user.login
            valueText: 'GitHub'

            action: Rectangle {
                anchors.fill: parent
                radius: width/2
                color: "gray"
                Rectangle {
                    anchors.fill: parent
                    radius: width/2
                    anchors.margins: 1
                    color: "white"
                }
                CircleImage {
                    anchors.fill: parent
                    anchors.margins: 2
                    source: github.user.avatar_url
                }
            }

            onTriggered: {
                pageStack.push(Qt.resolvedUrl("../backend/GitHubLoginPage.qml"))
            }
        }
    }
}
