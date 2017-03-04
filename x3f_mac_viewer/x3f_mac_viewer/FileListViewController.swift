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
    var fileURLs: [URL] = []
    
    override var representedObject: Any? {
        didSet {
            self.data = representedObject as? Data
            self.data?.directoryChangeHandler = { [unowned self] (directoryUrl: URL?) in
                self.fileURLs = self.data?.fileURLs() ?? []
                self.tableView.reloadData()
            }
        }
    }
}

extension FileListViewController: NSTableViewDelegate {
    
}

extension FileListViewController: NSTableViewDataSource {
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return self.fileURLs.count
    }
    
    public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return "\(row)"
    }
}
