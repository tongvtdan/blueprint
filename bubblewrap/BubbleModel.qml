import QtQuick 2.0
import "../udata"

Query {

    property Bubblewrap bubblewrap
    property string bubble_id

    predicate: 'bubble_id == "%1"'.arg(bubble_id)

    function query(args) {
        clear()
        bubblewrap.query(type, args).done(function(data, info) {
            unwrap(data, info)
        })
    }

    function unwrap(json, info) {
        for (var item in json) {
            unwrapItem(type, 'query', json, info)
        }
    }

    function unwrapItem(type, action, data, info) {
        var endpoint = bubblewrap.endpoints[type]['_info']

        var results = db.getByPredicate(type, endpoint.udata_id + ' == ? AND bubble_id == ?', [data[endpoint.json_id], bubble_id])

        if (results) {
            var obj = db.loadFromData(type, results, app)
            print("Found: " + obj[endpoint.udata_id])
        } else {
            print("Unwrapping new ", type, data[endpoint.json_id])

            var args = {
                json: data,
                bubble_id: bubble_id
            }

            args[endpoint.udata_id] = data[endpoint.json_id]

            print(JSON.stringify(args))

            db.create(type, args, app)
        }
    }

    function clear() {
        _db.removeWithPredicate(type, 'bubble_id == "%1"'.arg(bubble_id))
    }
}
