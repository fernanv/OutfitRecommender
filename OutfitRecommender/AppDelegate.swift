//
//  AppDelegate.swift
//  Armario
//
//  Created by Fernando Villalba  on 4/4/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let coreDataStack = CoreDataStack()
    var usuario : UserViewModel {
        UserViewModel(coreDataStack: self.coreDataStack)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let tab = self.window?.rootViewController as! UITabBarController
        tab.selectedIndex = 1
        
        let navigationController = tab.viewControllers?.last as! UINavigationController
        
        let garmentsViewController = navigationController.topViewController as! GarmentsViewController
        
        let homeController = tab.viewControllers?[1] as! HomeViewController
        
        let userController = tab.viewControllers?.first as! UserViewController(user: self.usuario)
        
        let rootViewModel = TodoListViewModel(todoListStorage: todoListStorage)
        let addTodoNoteViewModel = AddTodoNoteViewModel(todoListStorage: todoListStorage)
        let rootVC = TodoListViewController(addTodoNoteViewModel: addTodoNoteViewModel, viewModel: rootViewModel)

        window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = UINavigationController(rootViewController: rootVC)

        window?.makeKeyAndVisible()

        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        // iPhone / iPad configuration name
        let configurationName = (UIDevice.current.userInterfaceIdiom == .pad
        ? "Default Configuration iPad"
        : "Default Configuration")
        
        return UISceneConfiguration(name: configurationName, sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.usuario.coreDataStack.saveContext()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.usuario.coreDataStack.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Armario")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

