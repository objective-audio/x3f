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
                let fileUrls = fileURLs()
                
                if fileUrls.count > 0 {
                    for fileUrl in fileUrls {
                        self.selectedFileUrl = fileUrl
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
    
    func fileURLs() -> [URL] {
        if let directoryUrl = self.selectedDirectoryUrl {
            let fileManager = FileManager.default
            return try! fileManager.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        }
        return []
    }
}
