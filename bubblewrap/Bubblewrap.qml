import QtQuick 2.0
import "../qml-extras"
import "../qml-extras/httplib.js" as Http

Object {
    id: bubblewrap

    property string name
    property url root

    property var endpoints: {}

    signal error(var error, var info)

    function unwrap(type, action, data, info) {
        var endpoint = endpoints[type]['_info']

        var results = db.getByPredicate(type, endpoint.udata_id + ' == ?', data[endpoint.json_id])
        if (results) {
            var obj = db.loadFromData(type, results, app)
            print("Found: " + obj[endpoint.udata_id])
        } else {
            print("Unwrapping new ", type, data[endpoint.json_id])

            var args = {
                json: data
            }

            args[endpoint.udata_id] = data[endpoint.json_id]

            db.create(type, args, app)
        }
    }

    function parseProperties(call) {
        var properties = []

        var regex = /\<(.+?)\>/g
        var match

        while ((match = regex.exec(call)) != null) {
            properties.push(match[1])
        }

        return properties
    }

    function fillIn(call, args) {
        if (typeof(call) == 'function')
            call = call(args)

        var properties = parseProperties(call)

        properties.forEach(function(name) {
            var value
            if (args && args.hasOwnProperty(name)) {
                print(args, name, args[name])
                value = args[name]
            } else if (bubblewrap.hasOwnProperty(name)) {
                value = bubblewrap[name]
            }

            call = call.replace('<' + name + '>', value)
        })

        return call
    }

    function unwrapResults(type, action, data, info) {
        if (action === 'query') {
            for (var item in data) {
                unwrap(type, action, data[item], info)
            }
        } else {
            unwrap(type, action, data, info)
        }
    }

    function httpGET(type, action,  args) {
        var call = endpoints[type][action]
        var url = fillIn(call, args)

        var promise = Http.get(root + url).then(function(data) {
            return JSON.parse(data)
        })
        promise.error(error)
        promise.info = {
            'call': call,
            'url': url,
            'args': args
        }

        return promise
    }

    function get(type, args) {
        return httpGET(type, 'get', args)
    }

    function query(type, args) {
        return httpGET(type, 'query', args)
    }
}
