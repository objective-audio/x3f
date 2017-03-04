//
//  RootViewController.swift
//  x3f_mac_viewer
//
//  Created by Yuki Yasoshima on 2017/03/04.
//  Copyright © 2017年 Yuki Yasoshima. All rights reserved.
//

import Cocoa

class RootViewController : NSSplitViewController {
    var data: Data = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in self.splitViewItems {
            item.viewController.representedObject = self.data
        }
    }
}
