//
//  Data.swift
//  x3f_mac_viewer
//
//  Created by Yuki Yasoshima on 2017/03/04.
//  Copyright © 2017年 Yuki Yasoshima. All rights reserved.
//

import Foundation

class Data {
    var selectedDirectoryUrl: URL? {
        didSet {
            if let url = selectedDirectoryUrl {
                let fileManager = FileManager.default
                let urls = try! fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                
                if urls.count > 0 {
                    for url in urls {
                        self.selectedFileUrl = url
                        break
                    }
                } else {
                    self.selectedFileUrl = nil
                }
            }
            
            if let handler = directoryChangeHandler {
                handler(selectedDirectoryUrl)
            }
        }
    }
    
    var selectedFileUrl: URL? {
        didSet {
            if let handler = self.fileChangeHandler {
                handler(selectedFileUrl)
            }
        }
    }
    
    var directoryChangeHandler: ((URL?) -> Void)?
    var fileChangeHandler: ((URL?) -> Void)?
}
