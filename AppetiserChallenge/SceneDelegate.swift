//
//  SceneDelegate.swift
//  AppetiserChallenge
//
//  Created by Daniel Marco S. Rafanan on Feb/8/21.
//

import UIKit
import CoreData
import KeychainSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var currentUserName:String!
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        //Night Mode initialization


        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // MARK: - Persistent DarkMode Support
        
        ///If an interface style  was set before use it, otherwise use the system interface style
        if UserDefaults.standard.value(forKey: "DarkModeOption") == nil {
            UserDefaults.standard.setValue(0, forKey: "DarkModeOption")
        }
        
        let darkModeOption = UserDefaults.standard.value(forKey: "DarkModeOption") as! Int
        switch darkModeOption{
        case 0:
            window?.overrideUserInterfaceStyle = .unspecified
        case 1:
            window?.overrideUserInterfaceStyle = .dark
        case 2:
            window?.overrideUserInterfaceStyle = .light
        default:
            break
        }
        
        // MARK: - Autologin Support
        let keychain = KeychainSwift()

        ///There is a user logged in, initiate an autologin and go straight to the main TabBar
        if let userName = keychain.get(Key.userLoggedIn){
            currentUserName = userName
            (UIApplication.shared.delegate as! AppDelegate).currentUserName = currentUserName
            self.window?.rootViewController = storyboard.instantiateViewController(identifier: StoryboardIdentifier.mainTabBar) as? UITabBarController
            
        }else{
        ///If no user is logged in, initiate a login via LoginVC
            self.window?.rootViewController = storyboard.instantiateViewController(identifier: StoryboardIdentifier.loginVC) as? LoginVC
        }
        self.window?.makeKeyAndVisible()
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        currentUser.lastLogin = Date()
        try? container.viewContext.save()
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    // MARK: - CoreData Helper
    
    lazy var currentUser:User = getCurrentUser(from: container, with: currentUserName!).first!
    
    lazy var container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    func getCurrentUser(from container:NSPersistentContainer,with userName:String) -> [User]{
        let request : NSFetchRequest<User> = User.fetchRequest()
        let predicate = NSPredicate(format: "userName = %@", userName)
        request.predicate = predicate
        return (try? container.viewContext.fetch(request)) ?? []
    }



}

