# SCNActionSequence

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

SCNActionSequence is available through [CocoaPods](http://cocoapods.org).
To install
it, simply add the following line to your Podfile:

```ruby
pod 'SCNActionSequence'
```

## Usage

SCNActionSequence allows to chain several SCNActions with different nodes together.

```swift
node1
.prepare(action: SCNAction.moveBy(x: 5.0, y: 5.0, z: 0.0, duration: 2.0) )
.then(
action: SCNAction.rotate(by: CGFloat.pi / 2.0, around: SCNVector3(x: 0, y: 0, z: 1), duration: 2.0),
target: node2)
.then(wait: 2.0)
.then(transactionDuration: 5.0) {
ship.position = SCNVector3Zero
capsule?.position = SCNVector3Zero
}
.then(action: SCNAction.rotate(by: CGFloat.pi / 2.0, around: SCNVector3(x: 0, y: 0, z: 1), duration: 2.0))
.runSimultaneouslyWith()
.then(action: SCNAction.moveBy(x: -5.0, y: -2.0, z: 0.0, duration: 2.0))
.then{print("Do whatever  you want - update model for example")}
.run()

```
Please mind that sequences running themselves recursively  from the end. So if you save  sequence, attach several others  and run it - only first sequence will be executed.


## Author

Michael-Vorontsov, michel06@ukr.net

## License

SCNActionSequence is available under the MIT license. See the LICENSE file for more info.

