//
//  AppDelegate.swift
//  cubeRun
//
//  Created by Steven Muliamin on 09/01/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let launchedBefore: Bool = UserDefaults.standard.bool(forKey: "LaunchedBefore")
        
        if (launchedBefore == false) {
            UserDefaults.standard.set(1, forKey: "AvailableChapter")
            UserDefaults.standard.set(true, forKey: "LaunchedBefore")
            UserDefaults.standard.set(false, forKey: "Tutorial1Completed")
            UserDefaults.standard.set(false, forKey: "Tutorial2Completed")
            UserDefaults.standard.set(false, forKey: "Tutorial3Completed")
            UserDefaults.standard.set(true, forKey: "EnglishLanguage")
            UserDefaults.standard.set(false, forKey: "RepeatTuto")
            UserDefaults.standard.set(1.0, forKey: "MusicVolume")
            UserDefaults.standard.set(1.0, forKey: "Sensitivity")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        if (GameScene.sharedInstance != nil && GameScene.sharedInstance?.onTuto == false && GameScene.sharedInstance!.isCurrentlyPaused == false) {
            GameScene.sharedInstance!.isCurrentlyPaused = true
            GameScene.sharedInstance!.screenCover.alpha = 0.65
            GameScene.sharedInstance!.showPauseMenu {
                GameScene.sharedInstance!.gameNodeIsPaused = true
                GameScene.sharedInstance!.gameNode.isPaused = true
                GameScene.sharedInstance!.player.pause()
                GameScene.sharedInstance!.pauseTimer()
            }
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

