import UIKit

/** 
Since iOS8 and the introduction of UIPopoverPresentationController, we cannot easily determine if the current viewController is being displayed as a popover or not. The "presentationStyle" and "adaptivePresentationStyle()" of UIPresentationController still returns .PopOver on iPhone devices, whereas it's being displayed as a modal.
 
This extension of UIViewController fixes that issue by implementing a simple 'isBeingDisplayedAsPopover' property
*/
public extension UIViewController {
    public func isBeingDisplayedAsPopover() -> Bool {
        if let popoverPresentationController = self.popoverPresentationController {
            return popoverPresentationController.adaptivePresentationStyle() == .Popover
                || popoverPresentationController.adaptivePresentationStyle() == .None
        }
        /// In some cases, this fails… we cannot get the popoverPresentationController from a UIViewController… so we must suggest that if the presentingViewController is compact, so is the presented…
        if let presentationController = self.presentationController {
            return presentationController.presentationStyle == .Popover
                || self.presentingViewController?.traitCollection.horizontalSizeClass == .Regular
        }
        
        return false
    }
}