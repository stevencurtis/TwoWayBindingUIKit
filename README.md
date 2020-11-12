# Two-way binding with UIKit

MVVM is a fantastic Architecture pattern for iOS, and is highly recommended to be used in your production code. However, if you do not implement the two-way binding your architecture better represents Model-View-Presenter (MVP).

Many developers will rely on *RxSwift* and *RxCocoa* to implement bindings, which is a rather heavyweight solution to simply implement Two-way binding.

This library offers an alternative: provide Two-way bind in a small, tested library.

## Installation
This library is intended to be installed as a Swift Package [guide](https://stevenpcurtis.medium.com/use-swift-package-manager-to-add-dependencies-b605f91a4990b605f91a4990?sk=adfd10c7d96557b37ba6ea0443145eb4), where you would add [https://github.com/stevencurtis/SwiftCoding/TwoWayBindingUIKit](https://github.com/stevencurtis/TwoWayBindingUIKit)



## Usage
**Bind to identical types**
Values can be created as `MakeBindable`

```swift
var value: MakeBindable<String> = MakeBindable("Test Value")
lazy var label: UILabel = {
    let lab = UILabel()
    return lab
}()
```
which can then be bound to a `UIControl` using a keypath: Providing the input and output are the same type (in this case,  `String` is the type for `value` and the text of `label` is also a `String`)

```swift
value.bind(\String.self, to: lab, \.text)
```
Other uses include binding a `UIButton` and it's `isEnabled` property, for example:

```swift
var buttonEnabled: MakeBindable<Bool> = MakeBindable(true)
buttonEnabled.bind(\Bool.self, to: button, \.isEnabled)
```

**Map bound types**
If you would like to bind a value to a type that is different to that of the value, you need to provide a mapping function of the type `(T) -> R?`.

A series of these are provided in this library:

Mappers.transformBoolToStringFunction
Mappers.transformFloatToStringFunction
Mappers.transformIntToStringFunction

Which are then passed to the bind function. A good example of hte use of this is where we can bind a Boolean value to the text of a `UILabel`:

```swift
var switchValue: MakeBindable<Bool> = MakeBindable(true)
viewModel.switchValue.bind(
    \Bool.self,
    to: switchLabel,
    \.text,
    mapper: Mappers.transformBoolToStringFunction )
```

If you wish to use a mapper that is not provided, you may also use a mapper inline, and here is an example of how that may be implemented:

```swift
let transformBoolToStringFunction: (Bool) -> String = String.init(_:)
viewModel.switchValue.bind(\Bool.self, to: switchLabel, \.text, mapper: transformBoolToStringFunction)
```

## Example Post
There is a full post regarding this library at [https://github.com/stevencurtis/SwiftCoding/TwoWayBinding](https://github.com/stevencurtis/SwiftCoding/TwoWayBinding)
