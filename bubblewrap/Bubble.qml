import QtQuick 2.0
import "../udata"

Document {
    id: bubble

    property Bubblewrap bubblewrap
    property var json
    property string bubble_id

    property bool enabled

    signal refreshed

    function get(path, def) {
        if (json) {
            return json[path]
        } else {
            return def
        }
    }

    function refresh() {
        bubblewrap.get(_type, bubble).done(function(data) {
            print("Data: " + data)
            bubble.json = data
            refreshed()
        })
    }
}
