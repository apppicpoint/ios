//
//  CustomTabBar.swift
//  Picpoint
//
//  Created by David on 29/01/2019.
//  Copyright © 2019 Joaquín Collazo Ruiz. All rights reserved.
//

import UIKit

class CustomTabBarController:  UITabBarController, UITabBarControllerDelegate {
    
    var spotsFeedViewController: UINavigationController!
    var searchViewController: SearchViewController!
    var customAlert: CustomAlertViewController!
    var publicationsFeedViewController: PublicationsFeedViewController!
    var profileViewController: ProfileViewController!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.delegate = self
        if !Connectivity.isLocationEnabled() {
            let alert = UIAlertController(title: "Pls! Activate the GPS", message:
                "Picpoint cannot work without it", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            self.present(alert, animated: true, completion: nil)
            
        } else if !Connectivity.isLocationEnabled() {
            let alert = UIAlertController(title: "Pls! Activate the internet", message:
                "Picpoint cannot work without it", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in
                    UIApplication.shared.open(URL.init(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                    
            }))
            self.present(alert, animated: true, completion: nil)
        }       
        
        //Se hace referencia a todas las vistas del tabbar.
        spotsFeedViewController = storyboard?.instantiateViewController(withIdentifier: "feedSpotNavigation") as? UINavigationController
        searchViewController = storyboard?.instantiateViewController(withIdentifier: "search") as?SearchViewController
        customAlert = storyboard?.instantiateViewController(withIdentifier: "customAlert") as?CustomAlertViewController
        publicationsFeedViewController = storyboard?.instantiateViewController(withIdentifier: "publicationsFeed") as?PublicationsFeedViewController
        profileViewController = storyboard?.instantiateViewController(withIdentifier: "profile") as?ProfileViewController
        
        spotsFeedViewController.tabBarItem.image = UIImage(named: "points_inactive")
        spotsFeedViewController.tabBarItem.selectedImage = UIImage(named: "points_active")?.withRenderingMode(.alwaysOriginal)
        searchViewController.tabBarItem.image = UIImage(named: "search_inactive")
        searchViewController.tabBarItem.selectedImage = UIImage(named: "search_active")?.withRenderingMode(.alwaysOriginal)
        customAlert.tabBarItem.image = UIImage(named: "add_active")?.withRenderingMode(.alwaysOriginal)
        customAlert.tabBarItem.selectedImage = UIImage(named: "add_active")?.withRenderingMode(.alwaysOriginal)
        publicationsFeedViewController.tabBarItem.image = UIImage(named: "feed_inactive")
        publicationsFeedViewController.tabBarItem.selectedImage = UIImage(named: "feed_active")?.withRenderingMode(.alwaysOriginal)
        profileViewController.tabBarItem.image = UIImage(named: "profile_inactive")
        profileViewController.tabBarItem.selectedImage = UIImage(named: "profile_active")?.withRenderingMode(.alwaysOriginal)
        

        self.viewControllers = [spotsFeedViewController, searchViewController, customAlert, publicationsFeedViewController, profileViewController]
        
        for tabBarItem in tabBar.items! {
            tabBarItem.title = ""
            tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    // Personaliza los botones del tabbar que no llevan a pantallas directamente, si no que hacen cosas.
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: CustomAlertViewController.self) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let alertId = UserDefaults.standard.integer(forKey: "role_id") == 4 ? "noLogged" : "customAlert"
            
            let myAlert = storyboard.instantiateViewController(withIdentifier: alertId)
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(myAlert, animated: true, completion: nil)            
            return false
            
        } else if (viewController.isKind(of: ProfileViewController.self) || viewController.isKind(of: PublicationsFeedViewController.self)) && UserDefaults.standard.integer(forKey: "role_id") == 4{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "noLogged")
            myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(myAlert, animated: true, completion: nil)
            return false
            
        }
        
        
        return true
    }
    
    
    
}
