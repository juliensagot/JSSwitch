# JSSwitch
>UISwitch lookalike, for macOS.

[![MIT License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](LICENSE.md)
![Platform macOS](https://img.shields.io/badge/platform-macOS-lightgrey.svg)


![](Preview.gif)

## Usage
To turn it on:

```swift
mySwitch.on = true
print(mySwitch.on) // true
```

To turn it off:

```swift
mySwitch.on = false
print(mySwitch.on) // false
```

## Customization
You can customize the color by setting the `tintColor` property:

```swift
mySwitch.tintColor = NSColor.red
```

## Requirements
* Xcode 8
* OS X 10.11

## Integration
Download the .zip file and add `JSSwitch.swift` to your project.