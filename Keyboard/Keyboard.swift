import UIKit

public typealias KeyboardAnimation = (Keyboard) -> Void
public typealias KeyboardAnimationCompletion = (Keyboard, _ finished: Bool) -> Void

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
open class Keyboard {
    fileprivate class var sharedKeyboard: Keyboard {
        return _KeyboardSharedInstance
    }

    fileprivate init() {}

    open var enabled: Bool = false {
        didSet {
            if enabled {
                NotificationCenter.default.addObserver(self, selector: #selector(Keyboard.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(Keyboard.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(Keyboard.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(Keyboard.keyboardDidHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
            } else {
                NotificationCenter.default.removeObserver(self)
            }
        }
    }
    // MARK: - Basic infos

    /// Indicates if the keyboard is visible on screen or not. This value is set to true upon UIKeyboardWillShowNotification call, and false upon UIKeyboardDidHideNotification call.
    open fileprivate(set) var visible: Bool = false

    open fileprivate(set) var isBeingPresented: Bool = false
    open fileprivate(set) var isBeingDismissed: Bool = false

    /// Returns the window for the keyboard. Or nil if keyboard is not visible.
    open var window: UIWindow? { return visible == true ? UIApplication.shared.keyWindow : nil }

    //    /// Returns the firstResponder. Or nil if keyboard is not visible.
    //    public var firstResponder: UIResponder? { return self.window?.findFirstResponder() }

    /// The start frame of the keyboard inside its window
    open var startFrame: CGRect? { return self.visible ? (self.keyboardInfos?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue : nil }

    /// The start frame of the keyboard inside the given viewController's view
    open func startFrame(inViewController vc: UIViewController) -> CGRect? { return self.startFrame(inView: vc.isViewLoaded ? vc.view : nil) }
    open func startFrame(inView view: UIView?) -> CGRect? {
        if let startFrame = self.endFrame {
            return self.window?.convert(startFrame, to: view)
        }
        return nil
    }

    /// The end frame of the keyboard inside its window
    open var endFrame: CGRect? { return self.visible ? (self.keyboardInfos?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue : nil }

    /// The end frame of the keyboard inside the given viewController's view
    open func endFrame(inViewController vc: UIViewController) -> CGRect? { return self.endFrame(inView: vc.isViewLoaded ? vc.view : nil) }
    open func endFrame(inView view: UIView?) -> CGRect? {
        if let endFrame = self.endFrame {
            return self.window?.convert(endFrame, to: view)
        }
        return nil
    }

    // MARK: - Animation
    open var animationDuration: Double? {
        if let duration = (self.keyboardInfos?[UIKeyboardAnimationDurationUserInfoKey] as? Double), duration > 0.0 {
            return duration
        }
        return nil
    }
    open var animationCurve: UIViewAnimationCurve? {
        if let animationCurveRawValue = self.keyboardInfos?[UIKeyboardAnimationCurveUserInfoKey] as? Int {
            return UIViewAnimationCurve(rawValue: animationCurveRawValue)
        }
        return nil
    }
    open var animationOptions: UIViewAnimationOptions? {
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
    open func animateAlongsideWithKeyboard(_ animations: @escaping KeyboardAnimation, completion: KeyboardAnimationCompletion? = nil) {
        if self.canAnimationAlongside == true {
            self.alongsideAnimations.append(animations)
            if completion != nil { self.alonsideAnimationCompletions.append(completion!) }
        }
    }
    fileprivate var alongsideAnimations: [KeyboardAnimation] = []
    fileprivate var alonsideAnimationCompletions: [KeyboardAnimationCompletion] = []
    fileprivate var canAnimationAlongside: Bool = false {
        willSet {
            if newValue == false {
                self.alongsideAnimations.removeAll(keepingCapacity: false)
                self.alonsideAnimationCompletions.removeAll(keepingCapacity: false)
            }
        }
    }

    fileprivate func animateAlongsideWithKeyboardIfNeeded() {
        if self.alongsideAnimations.count > 0 {
            UIView.animate(withDuration: self.animationDuration ?? 0.0,
                delay: 0.0,
                options: self.animationOptions ?? .curveLinear,
                animations: {
                    for animation in self.alongsideAnimations {
                        animation(self)
                    }
                },
                completion: nil)
        }
    }

    // MARK: - Private

    fileprivate var keyboardInfos: [AnyHashable: Any]?
    @objc fileprivate func keyboardWillShow(_ n: Notification) {
        guard self.enabled == true else { return }
        self.keyboardInfos =  n.userInfo
        self.visible = true
        self.isBeingPresented = true
        self.canAnimationAlongside = true

        // Call keyboardWillAppear(animated:) on rootViewController
        // dispatch_async() fixes https://github.com/FinalCAD/iOS-KeyboardManager/issues/2
        DispatchQueue.main.async { [unowned self] in
            self.window?.rootViewController?.keyboardWillAppear(self.animationDuration != nil)
            self.animateAlongsideWithKeyboardIfNeeded()
        }
    }

    @objc fileprivate func keyboardDidShow(_ n: Notification) {
        guard self.enabled == true else { return }
        let didShowKeyboardAnimated = self.animationDuration != nil
        self.keyboardInfos = n.userInfo
        self.isBeingPresented = false

        for completion in self.alonsideAnimationCompletions { completion(self, true) }
        self.canAnimationAlongside = false

        // Call keyboardDidAppear(animated:) on rootViewController
        self.window?.rootViewController?.keyboardDidAppear(didShowKeyboardAnimated)
    }

    @objc fileprivate func keyboardWillHide(_ n: Notification) {
        guard self.enabled == true else { return }
        self.keyboardInfos = n.userInfo
        self.isBeingDismissed = true
        self.canAnimationAlongside = true

        // Call keyboardWillDisappear(animated:) on rootViewController
        self.window?.rootViewController?.keyboardWillDisappear(self.animationDuration != nil)
        self.animateAlongsideWithKeyboardIfNeeded()
    }

    @objc fileprivate func keyboardDidHide(_ n: Notification) {
        guard self.enabled == true else { return }
        let didHideKeyboardAnimated = self.animationDuration != nil
        self.keyboardInfos = n.userInfo
        self.visible = false
        self.isBeingDismissed = false

        for completion in self.alonsideAnimationCompletions { completion(self, true) }
        self.canAnimationAlongside = false

        // Call keyboardDidDisappear(animated:) on rootViewController
        self.window?.rootViewController?.keyboardDidDisappear(didHideKeyboardAnimated)
    }
}
