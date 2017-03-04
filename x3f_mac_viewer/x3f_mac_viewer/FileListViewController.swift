//
//  FileListViewController.swift
//  x3f_mac_viewer
//
//  Created by Yuki Yasoshima on 2017/03/04.
//  Copyright © 2017年 Yuki Yasoshima. All rights reserved.
//

import Cocoa

class FileListViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    
    var data: Data?
    
    override var representedObject: Any? {
        didSet {
            self.data = representedObject as? Data
            self.data?.directoryChangeHandler = { [unowned self] (_: URL?) in
                self.updateTableView()
            }
        }
    }
    
    func updateTableView() {
        
    }
}
