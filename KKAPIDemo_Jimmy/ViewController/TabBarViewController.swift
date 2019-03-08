//
//  TabBarViewController.swift
//  KKAPIDemo_Jimmy
//
//  Created by Jimmy Li on 2019/3/8.
//  Copyright © 2019 Jimmy Li. All rights reserved.
//

import UIKit

enum TabBarType: Int {
    case playlist = 0
    case favorite = 1
}

extension TabBarType {
    var title: String {
        switch self {
        case .playlist:
            return "Playlist"
        case .favorite:
            return "Favorite"
        }
    }
}

class TabBarViewController: UITabBarController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let viewControllers = viewControllers {
            for item in viewControllers.enumerated() {
                if let tabBarType: TabBarType = TabBarType.init(rawValue: item.offset) {
                    item.element.tabBarItem.title = tabBarType.title
                }
            }
        }
        
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
