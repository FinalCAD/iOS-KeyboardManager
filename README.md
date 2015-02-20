# Keyboard "Manager" for iOS
Have you ever been frustated when it comes to manage the keyboard in your iOS app? You know, this addObserver…notification… blablabla

Why such a pain ? 

Well, the "Keyboard" class is made for you.

Keyboard provides the latest infos about the keyboard, like startFrame, endFrame, animationDuration, animationOptions, etc…

And you know what? It also lets your forget about the notifications process and animating your views!



##SDK & Language

iOS 8.0 / Swift 





##Usage
First of all, you must enable the module. We extended `UIApplication` so you'll just have to 

Let's imagine a common usage of the keyboard : UIViewController with UITextField(s).

	class MyViewController: UIViewController {
	
	}




#License (MIT)

Copyright (c) 2015 Knowledge Corp

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

