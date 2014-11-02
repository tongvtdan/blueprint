import QtQuick 2.0
import "../qml-extras"
import "../bubblewrap"
import "../udata"
import "../qml-extras/httplib.js" as Http

Document {
    id: github

    _id: 'github'
    _type: 'GitHubService'
    _properties: ['accessToken', 'user']

    property string accessToken
    property var user

    onAccessTokenChanged: {
        if (!user && isLoaded) refresh()
    }

    Bubblewrap {
        id: bubblewrap

        root: "https://api.github.com"

        endpoints: {
            'Repository': {
                'query': function(args) {
                    if (args && args.name)
                        return '/user/%1/repos'.arg(args.name)
                    else
                        return '/user/repos'
                }
            },
            'User': {
                'get': function(args) {
                    if (args && args.name)
                        return '/users/%1'.arg(args.name)
                    else
                        return '/user'
                }
            }
        }

        function httpGET(type, action,  args) {
            var call = endpoints[type][action]
            var url = fillIn(call, args)

            var httpArgs = {
                options: []
            }

            print("Access token in HTTP:", github.accessToken)

            if (accessToken != '') {
                httpArgs.options.push('access_token=' + github.accessToken)
            }

            var promise = Http.get(root + url, httpArgs).then(function(data) {
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
    }

    function refresh() {
        bubblewrap.get('User').done(function(json) {
            github.user = json
            print(github.user.name)
        }).error(function(error, info) {
            print(error, info.url)
        })

        bubblewrap.query('Repository').done(function(data) {
            print("Data:", data)
            data.forEach(function (repo) {
                var project = projectForRepo(repo.full_name)

                if (!project) {
                    project = createProject(repo)
                } else {
                    project.title = repo.name
                }
            })
        })
    }

    function createProject(data) {
        var project = database.newObject('Project', {title: data.name}, github)

        var repo = database.newObject('Repository', {
                                          projectId: project._id,
                                          name: data.full_name,
                                          type: 'github',
                                          json: data
                                      })

        return project
    }

    function projectForRepo(full_name) {
        var objData = database.getByPredicate('Project',
                                              "id IN (SELECT projectId " +
                                              "FROM Repository WHERE type = 'github' AND name = ?)",
                                              [full_name])

        if (objData) {
            print("Found object for full name!")
            return database.loadFromData('Project', objData)
        } else {
            return null
        }
    }

    onLoaded: {
        refresh()
    }
}
