//
//  AppDelegate.swift
//  tri-tri
//
//  Created by mac on 2017-05-08.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation
import EggRating
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate,WXApiDelegate{

    var window: UIWindow?


    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        // Override point for customization after application launch.
        EggRating.rateButtonTitleText = "Cheers"
        EggRating.itunesId = "1259058860"
        EggRating.minRatingToAppStore = 3.5
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {
            (granted,erro) in
        })
        WXApi.registerApp("wxb3b370fd374d0862")
    
        return true
    }
    

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //add notification
        /**
        let notification_content = UNMutableNotificationContent()
        notification_content.title = NSString.localizedUserNotificationString(forKey: "Time is now!", arguments: nil)
        notification_content.body = NSString.localizedUserNotificationString(forKey: "客官可别忘了俺", arguments: nil)
        notification_content.sound = UNNotificationSound.default()
        notification_content.badge = 1
        //deliver the notification
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1800, repeats: false)
        let request = UNNotificationRequest.init(identifier: "Time_Now", content: notification_content, trigger: trigger)
        //schedule notification
        let center = UNUserNotificationCenter.current()
        center.add(request)
        //
 **/
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        /**
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["Time's Now"])
 **/
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return WXApi.handleOpen(url as URL!, delegate: self)
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return WXApi.handleOpen(url as URL!, delegate: self)
    }
    


}

