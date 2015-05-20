//
//  ViewController.swift
//  KeyboardManager Demo
//
//  Created by Louka Desroziers on 20/02/15.
//  Copyright (c) 2015 KnowledgeCorp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK : - Edition
    @IBOutlet var titleField: UITextField!
    @IBOutlet var descriptionField: UITextField!
    @IBOutlet private var textFieldsViewBottomConstraint: NSLayoutConstraint!
    
    //MARK: - Keyboard Management
    
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
            self.textFieldsViewBottomConstraint.constant = self.keyboardBottomLengthInView()
            self.view.layoutIfNeeded()
        })
    }
}

