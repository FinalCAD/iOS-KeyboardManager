//
//  AppDelegate.swift
//  KeyboardManager Demo
//
//  Created by Louka Desroziers on 20/02/15.
//  Copyright (c) 2015 KnowledgeCorp. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        UIApplication.KeyboardManager.enabled = true
        return true
    }
}
