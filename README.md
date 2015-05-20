# Keyboard "Manager" for iOS
Have you ever been frustated when it comes to manage the keyboard in your iOS app?

Well, the "Keyboard" class is made for you.

---
######Keyboard provides some useful infos :
	
```swift
var visible: Bool { get }
var window: UIWindow? { get }

var startFrame: CGRect? { get }
func startFrame(inViewController vc: UIViewController) -> CGRect?{}
func startFrame(inView view: UIView?) -> CGRect?{}

var endFrame: CGRect? { get }
func endFrame(inViewController vc: UIViewController) -> CGRect?{}
func endFrame(inView view: UIView?) -> CGRect?{}

var animationDuration: Double? { get }
var animationCurve: UIViewAnimationCurve? { get }
var animationOptions: UIViewAnimationOptions? { get }
```

######`UIViewController` & `UIPresentationController` are extended to implement these methods :
	
```Swift
func keyboardWillAppear(animated: Bool){}
func keyboardDidAppear(animated: Bool){}
func keyboardWillDisappear(animated: Bool){}
func keyboardDidDisappear(animated: Bool){}

// (UIViewController Only):
var keyboardBottomLayoutGuideLength: CGFloat { get }
func keyboardStartFrameInView() -> CGRect?{}
func keyboardEndFrameInView() -> CGRect?{}
```

######And forget about initiating animations, just use `animateAlongsideWithKeyboard()` like this :
```swift
override func keyboardWillAppear(animated: Bool) {
	super.keyboardWillAppear(animated)
	self.animateAlongsideWithKeyboard({ keyboard in
		// execute your animations here and use the keyboard to get the info you need to update your layout
	})
}
```

##SDK & Language

iOS 8.0 / Swift 1.2 with Xcode 6.3


##Usage
First of all, you must enable the module. We extended `UIApplication` so you'll just have to do this in your `AppDelegate` :
```swift	
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
	UIApplication.KeyboardManager.enabled = true
	return true
}
```

Now, let's imagine a common usage of the keyboard : UIViewController with UITextField(s).

```swift
class MyViewController: UIViewController {	
	    
	//MARK: Keyboard Management
	override func keyboardWillAppear(animated: Bool) {
        	super.keyboardWillAppear(animated)
    
        	self.animateAlongsideWithKeyboard({ _ in
                self.textFieldsViewBottomConstraint.constant = self.keyboardBottomLengthInView()
                self.view.layoutIfNeeded()
        	})
    	}
    
    	override func keyboardWillDisappear(animated: Bool) {
        	super.keyboardWillDisappear(animated)
        
        	self.animateAlongsideWithKeyboard({ _ in
            	self.textFieldsViewBottomConstraint.constant = 0
            	self.view.layoutIfNeeded()
        	})
    	}

}
```

As you can see, the simplicity comes by the `keyboardWill(Dis)Appear` & `keyboardDid(Dis)Appear` functions, plus the ability to unify your animations using the `animateAlongsideWithKeyboard()` function.


#License (MIT)

Copyright (c) 2015 Knowledge Corp

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

