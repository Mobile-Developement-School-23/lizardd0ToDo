//
//  AppDelegate.swift
//  ToDoListLizzard
//
//  Created by Елизавета Шерман on 01.07.2023.
//

import UIKit
import CocoaLumberjack
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                print("DB url - \(description.url)")
            }
        })
        return container
    }()
    
    public let fileLogger: DDFileLogger = DDFileLogger()
    private func setLogger() {
        DDLog.add(DDTTYLogger.sharedInstance!)
        fileLogger.rollingFrequency = TimeInterval(60*60*24)
        DDLog.add(fileLogger, with: .info)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setLogger()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

