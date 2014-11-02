import QtQuick 2.0
import "../udata"
import "../bubblewrap"

Bubble {
    _type: 'Repository'
    _properties: ['type', 'projectId', 'json', 'name']

    property string projectId
    property string type
    property string json
    property string name
}
