import UIKit

/** 
Since iOS8 and the introduction of UIPopoverPresentationController, we cannot easily determine if the current viewController is being displayed as a popover or not. The "presentationStyle" and "adaptivePresentationStyle()" of UIPresentationController still returns .PopOver on iPhone devices, whereas it's being displayed as a modal.
 
This extension of UIViewController fixes that issue by implementing a simple 'isBeingDisplayedAsPopover' property
*/
public extension UIViewController {
    public func isBeingDisplayedAsPopover() -> Bool {
        if let popoverPresentationController = self.popoverPresentationController {
            return popoverPresentationController.traitCollection.horizontalSizeClass == .Compact
        }
        return false
    }
}