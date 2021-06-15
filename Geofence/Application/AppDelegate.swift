//
//  AppDelegate.swift
//  Geofence
//
//  Created by Nguyen Tan Dung on 10/06/2021.
//

import UIKit
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(kGoogleAPI)
        GMSPlacesClient.provideAPIKey(kGoogleAPI)
        let mapVC = MapVC()
        let navi = UINavigationController(rootViewController: mapVC)
        navi.navigationBar.isHidden = true
        self.window = UIWindow()
        self.window?.makeKeyAndVisible()
        self.window!.rootViewController = navi
        return true
    }
}

