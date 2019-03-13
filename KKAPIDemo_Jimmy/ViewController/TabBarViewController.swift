//
//  TabBarViewController.swift
//  KKAPIDemo_Jimmy
//
//  Created by Jimmy Li on 2019/3/8.
//  Copyright © 2019 Jimmy Li. All rights reserved.
//

import UIKit

enum ViewControllerType: Int {
    case playlist = 0
    case favorite = 1
    case tracks = 2
}

extension ViewControllerType {
    var title: String {
        switch self {
        case .playlist:
            return "Playlist"
        case .favorite:
            return "Favorite"
        case .tracks:
            return "Tracks"
        }
    }
}

class TabBarViewController: UITabBarController {

    var tabTypes: [ViewControllerType] = [.playlist, .favorite]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var controllers: [UIViewController] = []
        
        for aType in tabTypes {
            let controller: PlaylistViewController = PlaylistViewController(type: aType)
            controller.title = aType.title
            let nav: UINavigationController = UINavigationController(rootViewController: controller)
            nav.tabBarItem.title = aType.title
            controllers.append(nav)
        }
        
        self.viewControllers = controllers
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
