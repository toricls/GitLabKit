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
Tested on OS X 10.12.5 with Xcode 8.3.3 (8E3004b), self hosted GitLab CE 7.5.3 b656b85.

- [Alamofire](https://github.com/Alamofire/Alamofire)
- [Mantle](https://github.com/Mantle/Mantle)

GitLabKit is using libraries listed above.
All dependencies are resolved by [CocoaPods](http://cocoapods.org/) with its version 1.2.0 or newer.

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

see [test sources](https://github.com/toricls/GitLabKit/tree/master/GitLabKitTests) to get more usage.

## TODO

- Implement more apis
- Decide on how to deal with 404 responses. I'm just treating them as normal responses and returning an empty array for [now](https://github.com/toricls/GitLabKit/blob/master/GitLabKit/GitLabApiClient.swift#L79).
- More effective and efficient testing with stub or something like that

## Contribution

1. Fork ([https://github.com/toricls/GitLabKit/fork](https://github.com/toricls/GitLabKit/fork))
2. Create a feature branch
3. Commit your changes
4. Rebase your local changes against the master branch
5. Create new Pull Request

## Licence

[MIT](https://github.com/toricls/GitLabKit/blob/master/LICENCE)

## Author

[toricls](https://github.com/toricls)
