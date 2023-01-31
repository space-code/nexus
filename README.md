![Nexus: AW and iPhone Communication Service](https://raw.githubusercontent.com/space-code/nexus/main/Resources/nexus.png)

<h1 align="center" style="margin-top: 0px;">nexus</h1>

<p align="center">
<a href="https://github.com/space-code/nexus/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/github/license/space-code/nexus?style=flat"></a> 
<a href="https://developer.apple.com/"><img alt="Platform" src="https://img.shields.io/badge/platform-ios%20%7C%20osx%20%7C%20watchos%20%7C%20tvos-%23989898"/></a> 
<a href="https://developer.apple.com/swift"><img alt="Swift5.7" src="https://img.shields.io/badge/language-Swift5.7-orange.svg"/></a>
  <a href="https://github.com/space-code/concurrency"><img alt="CI" src="https://github.com/space-code/nexus/actions/workflows/ci.yml/badge.svg?branch=main"></a>
<a href="https://github.com/apple/swift-package-manager" alt="Nexus on Swift Package Manager"><img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" /></a>
</p>

## Description
Nexus is a wrapper around `WatchConnectivity` that simplifies the interaction between watchOS and iOS.

- [Usage](#usage)
- [Requirements](#requirements)
- [Installation](#installation)
- [Communication](#communication)
- [Contributing](#contributing)
- [Author](#author)
- [License](#license)

## Usage

1. Define a message model, like this:
```swift
import Nexus

struct TestMessage: Message {
  static let identifier: String {
    return "TestModel"
  }
}
```

2. Create an instance of the `CommunicationService` and subscribe to receive messages:
```swift
import Nexus

var disposables = Set<AnyCancellable>()
let communicationService = CommunicationService()
communicationService.receiveMessage(TestMessage.self)
  .sink(receiveCompletion: { result in 
    if case let .failure(error) = result {
      // something went wrong
    }, receiveValue: { message in 
      debugPrint(message)
    }
  })
  .store(in: &disposables)
```

3. Send a message to Apple Watch or iPhone
```swift
import Nexus

let message = TestMessage()
communicationService.sendMessage(message)
```

## Requirements
- iOS 13.0+ / watchOS 7.0+
- Xcode 14.0
- Swift 5.7

## Installation
### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It is in early development, but `nexus` does support its use on supported platforms.

Once you have your Swift package set up, adding `nexus` as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/space-code/nexus.git", .upToNextMajor(from: "1.0.0"))
]
```

## Communication
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Contributing
Bootstrapping development environment

```
make bootstrap
```

Please feel free to help out with this project! If you see something that could be made better or want a new feature, open up an issue or send a Pull Request!

## Author
Nikita Vasilev, nv3212@gmail.com

## License
nexus is available under the MIT license. See the LICENSE file for more info.