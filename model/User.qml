import QtQuick 2.0
import "../udata"

Document {
    _type: 'User'
    _properties: ['userId', 'json']

    property var json
    property string userId

    function get(path, def) {
        if (json) {
            return json[path]
        } else {
            return def
        }
    }
}
