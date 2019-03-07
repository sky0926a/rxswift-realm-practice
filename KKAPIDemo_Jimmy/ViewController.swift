//
//  ViewController.swift
//  KKAPIDemo_Jimmy
//
//  Created by Jimmy Li on 2019/3/4.
//  Copyright © 2019 Jimmy Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let parameters: [String: Any] = ["territory": "TW",
//                                         "offset": 0,
//                                         "limit": 500]
//        API.shared.getJSON(.playlists, parameters: parameters, headers: nil)
        
        User.current.getToken()
    }


}

