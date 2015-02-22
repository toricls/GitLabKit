GitLabKit
====

GitLabKit is an API client library for [GitLab API](https://gitlab.com/help/api/README.md), written in Swift.

Based on [this interesting idea](http://developer.hatenastaff.com/entry/smart-api-client-with-swift-using-enum-and-generics).

Notice: Public interfaces may be changed until the project version reaches into v1.0.

## Description

Followings currently implemented.

### GET

Almost all without Labels, Notes, Deploy Keys, System Hooks, Groups.
Testing is not enough.

### POST

Nothing yet.

### DELETE

Nothing yet.

## Requirement

GitLabKit is written as a Cocoa Framework (for OS X) for now.
Tested on OS X 10.10.1 (14B25) with Xcode 6.1.1 (6A2008a), self hosted GitLab CE 7.5.3 b656b85.


- [Alamofire](https://github.com/Alamofire/Alamofire)
- [Mantle](https://github.com/Mantle/Mantle)

GitLabKit is using libraries listed above.
All dependencies are resolved by [CocoaPods](http://cocoapods.org/).

**CocoaPods is supporting Swift project from its version [0.36](https://github.com/CocoaPods/CocoaPods/milestones/0.36.0).**

Make sure your cocoapods installation is qualified that
```bash
$ pod --version
0.36.0.beta.2
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
let params = UserQueryParamBuilder()
client.get(params, { (response: GitLabResponse<User>?, error: NSError?) -> Void in
	println(response!.result!.count)
})

// Get user by Id
let params = UserQueryParamBuilder().id(1)
client.get(params, { (response: GitLabResponse<User>?, error: NSError?) -> Void in
    let user: User = response!.result![0]
	println(user.name!)
})
```

see [test sources](https://github.com/orih/GitLabKit/tree/master/GitLabKitTests) to get more usage.

## TODO

- Implement more apis
- Decide on how to deal with 404 responses. I'm just treating them as normal responses and returning an empty array for [now](https://github.com/orih/GitLabKit/blob/master/GitLabKit/GitLabApiClient.swift#L79).
- More effective and efficient testing with stub or something like that

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
