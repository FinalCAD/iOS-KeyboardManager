import UIKit

public typealias KeyboardAnimation = (Keyboard) -> Void
public typealias KeyboardAnimationCompletion = (Keyboard, finished: Bool) -> Void


public extension UIApplication {
    public var keyboard: Keyboard { return Keyboard.sharedKeyboard }
    public struct KeyboardManager {
        static public var enabled: Bool {
            get { return Keyboard.sharedKeyboard.enabled }
            set { Keyboard.sharedKeyboard.enabled = newValue }
        }
    }
}


private let _KeyboardSharedInstance = Keyboard()
/**
A manager built to be used as a shared instance in order to get as much info as possible about the keyboard (if displayed).
*/
public class Keyboard {
    private class var sharedKeyboard: Keyboard {
        return _KeyboardSharedInstance
    }
    
    private init() {}
    
    public var enabled: Bool = false {
        didSet {
            if self.enabled == true {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
                
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
            } else {
                NSNotificationCenter.defaultCenter().removeObserver(self)
            }
        }
    }
    
    
    //MARK : - Basic infos
    
    /// Indicates if the keyboard is visible on screen or not. This value is set to true upon UIKeyboardWillShowNotification call, and false upon UIKeyboardDidHideNotification call.
    public private(set) var visible: Bool = false
    
    public private(set) var isBeingPresented: Bool = false
    public private(set) var isBeingDismissed: Bool = false
    
    /// Returns the window for the keyboard. Or nil if keyboard is not visible.
    public var window: UIWindow? { return visible == true ? UIApplication.sharedApplication().keyWindow : nil }
    
    //    /// Returns the firstResponder. Or nil if keyboard is not visible.
    //    public var firstResponder: UIResponder? { return self.window?.findFirstResponder() }
    
    
    /// The start frame of the keyboard inside its window
    public var startFrame: CGRect? { return self.visible ? (self.keyboardInfos?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() : nil }
    
    /// The start frame of the keyboard inside the given viewController's view
    public func startFrame(inViewController vc: UIViewController) -> CGRect? { return self.startFrame(inView: vc.isViewLoaded() ? vc.view : nil) }
    public func startFrame(inView view: UIView?) -> CGRect? {
        if let startFrame = self.endFrame {
            return self.window?.convertRect(startFrame, toView: view)
        }
        return nil
    }
    
    
    /// The end frame of the keyboard inside its window
    public var endFrame: CGRect? { return self.visible ? (self.keyboardInfos?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() : nil }
    
    /// The end frame of the keyboard inside the given viewController's view
    public func endFrame(inViewController vc: UIViewController) -> CGRect? { return self.endFrame(inView: vc.isViewLoaded() ? vc.view : nil) }
    public func endFrame(inView view: UIView?) -> CGRect? {
        if let endFrame = self.endFrame {
            return self.window?.convertRect(endFrame, toView: view)
        }
        return nil
    }
    
    
    //MARK: - Animation
    public var animationDuration: Double? {
        if let duration = (self.keyboardInfos?[UIKeyboardAnimationDurationUserInfoKey] as? Double) where duration > 0.0 {
            return duration
        }
        return nil
    }
    public var animationCurve: UIViewAnimationCurve? {
        if let animationCurveRawValue = self.keyboardInfos?[UIKeyboardAnimationCurveUserInfoKey] as? Int {
            return UIViewAnimationCurve(rawValue: animationCurveRawValue)
        }
        return nil
    }
    public var animationOptions: UIViewAnimationOptions? {
        if let animationCurve = self.animationCurve {
            return UIViewAnimationOptions(rawValue: UInt(animationCurve.rawValue << 16))
        }
        return nil
    }
    
    /**
    Gives you the opportunity to execute animations alongside with the keyboard.
    Calling this function outside a keyboardWillShow / keyboardWillHide notification has no effect.
    
    - returns: True if the animation & completion closures are accepted
    */
    public func animateAlongsideWithKeyboard(animations: KeyboardAnimation, completion: KeyboardAnimationCompletion? = nil) -> Bool {
        if self.canAnimationAlongside == true {
            self.alongsideAnimations.append(animations)
            if completion != nil { self.alonsideAnimationCompletions.append(completion!) }
        }
        
        return self.canAnimationAlongside
    }
    private var alongsideAnimations: [KeyboardAnimation] = []
    private var alonsideAnimationCompletions: [KeyboardAnimationCompletion] = []
    private var canAnimationAlongside: Bool = false {
        willSet {
            if newValue == false {
                self.alongsideAnimations.removeAll(keepCapacity: false)
                self.alonsideAnimationCompletions.removeAll(keepCapacity: false)
            }
        }
    }
    
    private func animateAlongsideWithKeyboardIfNeeded() {
        if self.alongsideAnimations.count > 0 {
            UIView.animateWithDuration(self.animationDuration ?? 0.0,
                delay: 0.0,
                options: self.animationOptions ?? .CurveLinear,
                animations: {
                    for animation in self.alongsideAnimations {
                        animation(self)
                    }
                },
                completion: nil)
        }
    }
    
    //MARK: - Private
    
    private var keyboardInfos: [NSObject : AnyObject]?
    @objc private func keyboardWillShow(n: NSNotification) {
        self.keyboardInfos =  n.userInfo
        self.visible = true
        self.isBeingPresented = true
        self.canAnimationAlongside = true
        
        // Call keyboardWillAppear(animated:) on rootViewController
        // dispatch_async() fixes https://github.com/FinalCAD/iOS-KeyboardManager/issues/2
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            self.window?.rootViewController?.keyboardWillAppear(self.animationDuration != nil)
            self.animateAlongsideWithKeyboardIfNeeded()
        }
    }
    
    @objc private func keyboardDidShow(n: NSNotification) {
        let didShowKeyboardAnimated = self.animationDuration != nil
        self.keyboardInfos =  n.userInfo
        self.isBeingPresented = false
        
        for completion in self.alonsideAnimationCompletions { completion(self, finished: true) }
        self.canAnimationAlongside = false
        
        // Call keyboardDidAppear(animated:) on rootViewController
        self.window?.rootViewController?.keyboardDidAppear(didShowKeyboardAnimated)
    }
    
    
    @objc private func keyboardWillHide(n: NSNotification) {
        self.keyboardInfos =  n.userInfo
        self.isBeingDismissed = true
        self.canAnimationAlongside = true
        
        // Call keyboardWillDisappear(animated:) on rootViewController
        self.window?.rootViewController?.keyboardWillDisappear(self.animationDuration != nil)
        self.animateAlongsideWithKeyboardIfNeeded()
    }
    
    @objc private func keyboardDidHide(n: NSNotification) {
        let didHideKeyboardAnimated = self.animationDuration != nil
        self.keyboardInfos =  n.userInfo
        self.visible = false
        self.isBeingDismissed = false
        
        for completion in self.alonsideAnimationCompletions { completion(self, finished: true) }
        self.canAnimationAlongside = false
        
        // Call keyboardDidDisappear(animated:) on rootViewController
        self.window?.rootViewController?.keyboardDidDisappear(didHideKeyboardAnimated)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
