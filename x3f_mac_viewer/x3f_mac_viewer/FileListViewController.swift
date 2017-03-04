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
    public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if row < self.fileURLs.count {
            self.data?.selectedFileUrl = self.fileURLs[row]
        } else {
            self.data?.selectedFileUrl = nil
        }
        
        return true
    }
}

extension FileListViewController: NSTableViewDataSource {
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return self.fileURLs.count
    }
    
    public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if row < self.fileURLs.count {
            return self.fileURLs[row].lastPathComponent
        }
        return "out of range"
    }
}
