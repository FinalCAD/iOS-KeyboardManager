import UIKit

public extension UIViewController {
    /** Called by the Keyboard when UIKeyboardWillShowNotification has been called. The 'animated' value depends if the keyboard did receive a duration in the userInfo.
    
    When overriding this function, you must call super so it can follows the call to its children & presentedViewController
    You can use this function to create animation alongside with the keyboard apparition.
    */
    @objc public func keyboardWillAppear(_ animated: Bool) {
        for childVC in self.childViewControllers { childVC.keyboardWillAppear(animated) }
        if self.childViewControllers.count == 0 {
            self.presentedViewController?.keyboardWillAppear(animated)
        }
    }

    /** Called by the Keyboard when UIKeyboardDidShowNotification has been called. The 'animated' value depends if the keyboard did receive a duration when UIKeyboardWillShowNotification has been called earlier.
    
    When overriding this function, you must call super so it can follows the call to its children & presentedViewController.
    */
    @objc public func keyboardDidAppear(_ animated: Bool) {
        for childVC in self.childViewControllers { childVC.keyboardDidAppear(animated) }
        if self.childViewControllers.count == 0 {
            self.presentedViewController?.keyboardDidAppear(animated)
        }
    }

    /** Called by the Keyboard when UIKeyboardWillHideNotification has been called. The 'animated' value depends if the keyboard did receive a duration in the userInfo.
    
    When overriding this function, you must call super so it can follows the call to its children & presentedViewController.
    You can use this function to create animation alongside with the keyboard apparition.
    */
    @objc public func keyboardWillDisappear(_ animated: Bool) {
        for childVC in self.childViewControllers { childVC.keyboardWillDisappear(animated) }
        if self.childViewControllers.count == 0 {
            self.presentedViewController?.keyboardWillDisappear(animated)
        }
    }

    /** Called by the Keyboard when UIKeyboardDidHideNotification has been called. The 'animated' value depends if the keyboard did receive a duration when UIKeyboardWillHideNotification has been called earlier.
    
    When overriding this function, you must call super so it can follows the call to its children & presentedViewController.
    */
    public func keyboardDidDisappear(_ animated: Bool) {
        for childVC in self.childViewControllers { childVC.keyboardDidDisappear(animated) }
        if self.childViewControllers.count == 0 {
            self.presentedViewController?.keyboardDidDisappear(animated)
        }
    }

    /**
    Gives you the opportunity to execute animations alongside with the keyboard.
    Calling this function outside a keyboardWillAppear / keyboardWillDisappear function has no effect.
    */
    public func animateAlongsideWithKeyboard(_ animations: @escaping KeyboardAnimation, completion: KeyboardAnimationCompletion? = nil) {
        UIApplication.shared.keyboard.animateAlongsideWithKeyboard(animations, completion: completion)
    }

    /// Returns the height of the keyboard inside the receiver's view.
    public var keyboardBottomLayoutGuideLength: CGFloat {
        if let endFrame = self.keyboardEndFrameInView(), endFrame.minY < self.view.frame.height {
            return self.view.frame.height - endFrame.minY
        }
        return 0
    }

    /// Returns the startFrame of the keyboard inside the view controller's view. This function simply converts the keyboardStartFrame to the view.
    public func keyboardStartFrameInView() -> CGRect? {
        if let keyboardStartFrame = UIApplication.shared.keyboard.startFrame {
            return self.view.convert(keyboardStartFrame, from: nil)
        }
        return nil
    }
    /// Returns the endFrame of the keyboard inside the view controller's view. This function simply converts the keyboardEndFrame to the view.
    public func keyboardEndFrameInView() -> CGRect? {
        if let keyboardEndFrame = UIApplication.shared.keyboard.endFrame {
            return self.view.convert(keyboardEndFrame, from: nil)
        }
        return nil
    }
}
