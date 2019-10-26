
[![Swift 5](https://img.shields.io/badge/Swift-5-green.svg?style=flat)](https://swift.org/)

Xcode Version 11.1 (11A1027)

# Project - iOS Coding Challenge for Revolut #

The goal of this assignment is to allow you to demonstrate your programming skills and to allow us to understand your approach when developing a mobile application.

Your app should be production ready: In addition to assessing your code quality, we will be trying to break your app by testing for different usability issues that a real user might encounter.

We would like you to implement an exchange rates app.

The app must request and update currency rates every second using an API.

The API endpoint you should use is:

https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios

To obtain rates you should pass an array of currency code pairs as follows:

https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios?pairs=USDGBP&pairs=GBPU SD

Users should be able to:

Add a new currency pair Remove a currency pair

The list of currency pairs should be preserved across app launches.

  
### Dev Setup

This project uses Carthage to manage the dependencies.

  
```
- Install Swiftlint using: brew install swiftlint

- git clone https://github.com/ShadyGhalab/Revolut.git

- carthage update --platform iOS

- Run! 😎

```

## Dev Notes ##


### MVVM

This project uses the MVVM software architectural pattern.

### Dependencies

-  [FBSnapshotTestCase Page](https://github.com/uber/ios-snapshot-test-case)

### Localization

- The project is configured for localisation.

### Unit Testing
  
- The project uses XCTest for unit test.

### Snapshots Testing  

[FBSnapshotTestCase Page](https://github.com/uber/ios-snapshot-test-case)

- The project uses FBSnapshotTestCase for Snapshot tests.

- The snapshots s have been recored for these simulators:

  - iPhone 8

  - iPhone 8 plus

  - iPhone 11

  - iPhone 11 Pro  

  - iPad Air

  - iPad Pro (11 Inch)  

  - iPad Pro ( 9.7 inch)

  - iPad Pro (12.9 inch)  

- The location for the screenshots is  "Revolut/RevolutTests/ReferenceImages_64"

- Please run the snapshots tests using Revolut target to because it has the location of the  ReferenceImages and FailureDiffs folder as `Environment Variables`.
