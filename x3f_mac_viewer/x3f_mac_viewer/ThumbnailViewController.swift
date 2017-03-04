//
//  ViewController.swift
//  x3f_mac_viewer
//
//  Created by Yuki Yasoshima on 2017/03/04.
//  Copyright © 2017年 Yuki Yasoshima. All rights reserved.
//

import Cocoa

class ThumbnailViewController: NSViewController {
    @IBOutlet weak var imageView: NSImageView!
    
    var data: Data?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
            self.data = representedObject as? Data
        }
    }
    
    @IBAction func open(sender: AnyObject) {
        let openPanel = NSOpenPanel()
        openPanel.allowedFileTypes = ["x3f"]
        openPanel.canChooseDirectories = false;
        openPanel.canChooseFiles = true;
        openPanel.allowsMultipleSelection = false;
        
        if openPanel.runModal() == NSFileHandlingPanelOKButton {
            self.data?.selectedFileUrl = openPanel.url
            
            self.updateImage()
        }
    }
    
    func updateImage() {
        if let fileURL = self.data?.selectedFileUrl {
            let urlString = fileURL.absoluteString
            let urlSubstring = urlString.substring(from: urlString.index(urlString.startIndex, offsetBy: 7))
            let path = urlSubstring.cString(using: .utf8)
            
            if let jpgData = load_jpg(path) {
                self.imageView.image = NSImage(data: jpgData)
            }
        }
    }
}

