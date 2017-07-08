//
//  AppDelegate.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/6/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import UserNotifications
import Firebase
import  OneSignal


var internet:Bool?
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,OSSubscriptionObserver{

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        
        // load playerID if Founded
        if let currPlayerId = defaults.value(forKey: "playerID") as? String {
            playerID = currPlayerId
        }
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "181dcb38-b914-4abc-b81e-beb0df2f3523",
                                        handleNotificationAction: { result in
                                        // This block gets called when the user reacts to a notification received
        let payload: OSNotificationPayload = result!.notification.payload
                                            
        let notificationTitle = payload.body
        let additionalData = payload.additionalData
            if let data = additionalData as NSDictionary? {
                
                if let status = data["notificationStatus"] as? String {
                    
                    let senderDetails = User(data: data)
                    let long = data.getValueForKey(Key: "long", callBack: "")
                    let lat = data.getValueForKey(Key: "lat", callBack: "")
                    senderDetails.location.longtude = Double(long)
                    senderDetails.location.latitude = Double(lat)
                    
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    if status == "accept" {
                        if senderDetails.typeOfUser == "online" {
                            
                            let viewController = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
                            viewController.notificationComeProfileStatus = true
                            viewController.userProfileData = senderDetails
                            viewController.notificationTitle = notificationTitle!
                            self.window?.rootViewController = viewController
                            self.window?.makeKeyAndVisible()
                        }else {
                            let meetingPointLocation = Location()
                            meetingPointLocation.latitude = Double(data.getValueForKey(Key: "targetLat", callBack: "0.0"))
                            meetingPointLocation.longtude = Double(data.getValueForKey(Key: "targetLong", callBack: "0.0"))
                            let viewController = storyboard.instantiateViewController(withIdentifier: "MatchRequestViewController") as! MatchRequestViewController
                            RequestManager.defaultManager.loadCurrentUser()
                            viewController.notificationAcceptStatus = true
                            viewController.userDisplayWhileRequesting = senderDetails
                            viewController.meetingPointLocation = meetingPointLocation
                            viewController.accpetedRequest = true
                            
                            self.window?.rootViewController = viewController
                            self.window?.makeKeyAndVisible()
                        }
                        
                    }else if status == "newRequest"{
                        
                        if senderDetails.typeOfUser == "online" {
                            let viewController = storyboard.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
                            viewController.notificationComeProfileStatus = true
                            viewController.userProfileData = senderDetails
                            self.window?.rootViewController = viewController
                            self.window?.makeKeyAndVisible()
                        }else {
                            let meetingPointLocation = Location()
                            meetingPointLocation.latitude = Double(data.getValueForKey(Key: "targetLat", callBack: "0.0"))
                            meetingPointLocation.longtude = Double(data.getValueForKey(Key: "targetLong", callBack: "0.0"))
                            let viewController = storyboard.instantiateViewController(withIdentifier: "MatchRequestViewController") as! MatchRequestViewController
                            RequestManager.defaultManager.loadCurrentUser()
                            viewController.notificationAcceptStatus = true
                            viewController.userDisplayWhileRequesting = senderDetails
                            viewController.meetingPointLocation = meetingPointLocation
                            self.window?.rootViewController = viewController
                            self.window?.makeKeyAndVisible()
                        }
                    }
                    
                    
                }
                
            }
        }
        ,settings: onesignalInitSettings)
            OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
            OneSignal.add(self as OSSubscriptionObserver)
    
        
        if let userLogined = defaults.value(forKey: "loginStatus") as? Bool {
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var navigationController = storyboard.instantiateViewController(withIdentifier: "matchDetailsNav") as! UINavigationController
            RequestManager.defaultManager.loadCurrentUser()
            if !userLogined {
                navigationController = storyboard.instantiateViewController(withIdentifier: "siginVC") as! UINavigationController
            }
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        
        // Provide Google Maps Key
        GMSPlacesClient.provideAPIKey("AIzaSyAb6GwMWZr5zGVO7q9OqFbgDRhVXB9kEf0")
        GMSServices.provideAPIKey("AIzaSyAb6GwMWZr5zGVO7q9OqFbgDRhVXB9kEf0")
        
        // firebse configrartion
        FirebaseApp.configure()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        RequestManager.defaultManager.updateUserAvailability(userStatus: .offline)
        RequestManager.defaultManager.saveCurrentUser()
    }
    

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        RequestManager.defaultManager.updateUserAvailability(userStatus: .online)
        
    }
    

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
    // case of apple notification
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        
//        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//        
//    }
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
        
        //The player id is inside stateChanges. But be careful, this value can be nil if the user has not granted you permission to send notifications.
        if let playerId = stateChanges.to.userId {
            print("Current playerId \(playerId)")
            playerID = playerId
            defaults.set(playerID, forKey: "playerID")
        }
    }
    
    
    

}

