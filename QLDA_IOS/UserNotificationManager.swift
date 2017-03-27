//
//  UserNotificationManager.swift
//  QLDA_IOS
//
//  Created by datlh on 3/6/17.
//  Copyright © 2017 Harmony Soft. All rights reserved.
//

import UIKit
import UserNotifications
class UserNotificationManager : NSObject{
    static let share = UserNotificationManager()
    
    override init(){
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func addNotificationWithTimeIntervalTrigger(identifier : String, title : String, body : String){
        let content = UNMutableNotificationContent()
        content.title = title
        //content.subtitle = subTitle
        content.body = body
        
        //content.badge = badge
        content.sound = UNNotificationSound.default()

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func addNotificationWithFireTime(identifier : String, title : String, body : String, fireGMT : Date){
        let content = UNMutableNotificationContent()
        content.title = title
        //content.subtitle = subTitle
        content.body = body
        
        //content.badge = badge
        content.sound = UNNotificationSound.default()
        
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: fireGMT)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

    }
    
    func removeNotification(identifier : String){
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func removeAllNotification(){
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}


extension UserNotificationManager : UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
}
