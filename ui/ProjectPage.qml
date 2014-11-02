import QtQuick 2.0
import "../qml-material" as Material
import "../qml-material/Transitions" as MaterialTransitions
import "../model"

Material.Page {
    title: project.title

    property Project project

    transition: MaterialTransitions.CardTransition {

    }
}
