import UIKit

/** Keyboards notifications for UIPresentationController are useful if your custom UIPresentationController presents its presentedView using only a portion of the screen.
    
    Default non-fullscreen modals frame automatically change once the keyboard appear/disppear on a non-compact environment (iPad, for exemple)
*/
public extension UIPresentationController {
    /** Called by the Keyboard when UIKeyboardWillShowNotification has been called. The 'animated' value depends if the keyboard did receive a duration in the userInfo.
    
    Default implementation does nothing.
    You can use this function to create animation alongside with the keyboard apparition.
    */
    public func keyboardWillAppear(animated: Bool) {
    }
    
    /** Called by the Keyboard when UIKeyboardDidShowNotification has been called. The 'animated' value depends if the keyboard did receive a duration when UIKeyboardWillShowNotification has been called earlier.
    
    Default implementation does nothing.
    */
    public func keyboardDidAppear(animated: Bool) {
    }
    
    /** Called by the Keyboard when UIKeyboardWillHideNotification has been called. The 'animated' value depends if the keyboard did receive a duration in the userInfo.
    
    Default implementation does nothing.
    You can use this function to create animation alongside with the keyboard apparition.
    */
    public func keyboardWillDisappear(animated: Bool) {
    }
    
    /** Called by the Keyboard when UIKeyboardDidHideNotification has been called. The 'animated' value depends if the keyboard did receive a duration when UIKeyboardWillHideNotification has been called earlier.
    
    Default implementation does nothing.
    */
    public func keyboardDidDisappear(animated: Bool) {
    }
    
    /**
    Gives you the opportunity to execute animations alongside with the keyboard.
    Calling this function outside a keyboardWillAppear / keyboardWillDisappear function has no effect.
    */
    public func animateAlongsideWithKeyboard(animations: KeyboardAnimation, completion: KeyboardAnimationCompletion? = nil) {
        UIApplication.sharedApplication().keyboard.animateAlongsideWithKeyboard(animations, completion: completion)
    }
    
}


private extension UIView {
    private func findFirstResponder() -> UIResponder? {
        if self.isFirstResponder() == true {
            return self
        } else {
            for subview in self.subviews {
                return subview.findFirstResponder()
            }
        }
        return nil
    }
}