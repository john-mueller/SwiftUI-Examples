# SwiftUI-Examples
![Compatible with Swift 5.1][swift-version]
![Tested with Xcode 11.0][xcode-version]
![Tested with iOS 13.1][ios-version]

This is a personal repo for me to post useful or interesting SwiftUI views and extensions I come up with. I'll try to keep things up to date as Swift and SwiftUI continue to evolve, but no promises on timeliness.

At some point, I may check in whole Xcode projects. For now, I'll just be posting individual .swift files that you can drag into your own projects.

## Contents

### VSlider

This is, as it sounds, a vertical version of Slider. I made it because I ran into lots of problems trying to rotate SwiftUI's built-in Slider view. It should be feature-equivalent to Slider, with the exception of labels.

### FlowLayout

An experimental view to try "flowing" views into multiple rows based on the length of the individual views. Uses GeometryReader and PreferenceKey.

[swift-version]: https://img.shields.io/badge/Swift-5.1-green.svg
[xcode-version]: https://img.shields.io/badge/Xcode-11.0-green.svg
[ios-version]: https://img.shields.io/badge/iOS-13.1-green.svg