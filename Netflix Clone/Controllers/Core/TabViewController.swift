//
//  ViewController.swift
//  Netflix Clone
//
//  Created by Joshua Figueroa on 8/12/23.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadsViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc1.tabBarItem.title = "Home"
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc2.tabBarItem.title = "Coming Soon"
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc3.tabBarItem.title = "Top Search"
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        vc4.tabBarItem.title = "Downloads"
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }


}

