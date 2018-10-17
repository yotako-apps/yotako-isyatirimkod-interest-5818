//
//  YTScrollView.swift
//  App
//
//  Created by Yotako on 07/03/2018.
//  Copyright © 2018 Yotako S.A. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class YTScrollView: UIScrollView {

    @IBInspectable var maxHeight: Int = 0 {
        didSet {
            self.originalWidth = self.frame.width
            self.originalHeight = self.frame.height
            self.updateScrollView = self.updateMaxHeight
        }
    }
    
    var updateScrollView : (()-> Void)?
    var originalHeight: CGFloat = 0.0
    var originalWidth: CGFloat = 0.0
    
    override func willMove(toWindow newWindow: UIWindow?) {
       self.updateScrollView?()
    }

    func updateMaxHeight() {
        self.maxHeight = Int(CGFloat(self.maxHeight) * (self.frame.width/self.originalWidth));
        self.contentSize = CGSize(width:self.frame.width, height:CGFloat(self.maxHeight));
    }
}
