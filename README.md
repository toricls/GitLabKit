GitLabKit
====

GitLabKit is an API client library for [GitLab API](https://gitlab.com/help/api/README.md), wrriten in Swift.

Based on [this interesting idea](http://developer.hatenastaff.com/entry/smart-api-client-with-swift-using-enum-and-generics).

## Description

Followings are currently implemented.

### GET

#### [Users](https://gitlab.com/help/api/users.md)

- /users (For normal users)
- /users/:id
- /user

#### [Projects](https://gitlab.com/help/api/projects.md)

- /projects
- /projects/:id
- /projects/:namewithnamespace
- /projects/:id/members
- /projects/:id/issues

#### [Issues](https://gitlab.com/help/api/issues.md)

- /issues

### POST

Nothing yet.

## Requirement

GitLabKit is wrriten as a Cocoa Framework (for OS X) for now.
I tested this library on OS X 10.10.1 (14B25) with Xcode 6.1.1 (6A2008a), self hosted GitLab CE 7.5.3 b656b85.


- [Alamofire](https://github.com/Alamofire/Alamofire)
- [Mantle](https://github.com/Mantle/Mantle)

GitLabKit is using libraries listed above.
All dependencies are resolved by [CocoaPods](http://cocoapods.org/).

**CocoaPods is supporting Swift project from its version [0.36](https://github.com/CocoaPods/CocoaPods/milestones/0.36.0).**  

Make sure your cocoapods installation is qualified that
```bash
$ pod --version
0.36.0.beta.1
```

and if not, install pre version.
```bash
$ (sudo) gem install cocoapods --pre
```

## Usage

```swift
// Init api client
let client: GitLabApiClient = GitLabApiClient(host: "https://git.example.com", privateToken: "YOUR-PRIVATE-TOKEN")

// Get users
client.getUsers({ (users: [GitLabUserBasic]?, error: NSError?) -> Void in
    println(users?.count)
})
```

## Contribution

1. Fork ([https://github.com/orih/GitLabKit/fork](https://github.com/orih/GitLabKit/fork))
2. Create a feature branch
3. Commit your changes
4. Rebase your local changes against the master branch
5. Create new Pull Request

## Licence

[MIT](https://github.com/orih/GitLabKit/blob/master/LICENCE)

## Author

[orih](https://github.com/orih)
