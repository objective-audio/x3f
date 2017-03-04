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
            let fileUrls = fileURLs()
            
            if fileUrls.count > 0 {
                for fileUrl in fileUrls {
                    self.selectedFileUrl = fileUrl
                    break
                }
            } else {
                self.selectedFileUrl = nil
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
            
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsPackageDescendants, . skipsSubdirectoryDescendants])
                
                return fileURLs.filter( { (url: URL) in
                    var isDirectory : ObjCBool = false
                    if fileManager.fileExists(atPath: url.path, isDirectory:&isDirectory) {
                        return !isDirectory.boolValue
                    }
                    return false
                });
            } catch {
            }
        }
        return []
    }
}
