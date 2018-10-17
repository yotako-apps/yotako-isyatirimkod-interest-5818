//
//  YTSearchBox.swift
//  App
//
//  Created by Yotako on 26/02/2018.
//  Copyright © 2018 Yotako S.A. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class YTSearchBox : UITextField {
    
    @IBInspectable var borderColor: UIColor = UIColor.black
    
    @IBInspectable var leftPadding: CGFloat = 10.0
    
    @IBInspectable var addBorderTop: CGFloat = 0.0
    {
        didSet {
            self.updateBorderCall = self.updateBorder
        }
    }
    
    @IBInspectable var addBorderBottom: CGFloat = 0.0
    {
        didSet {
            self.updateBorderCall = self.updateBorder
        }
    }
    
    @IBInspectable var addBorderLeft: CGFloat = 0.0
    {
        didSet {
            self.updateBorderCall = self.updateBorder
        }
    }
    
    @IBInspectable var addBorderRight: CGFloat = 0.0
    {
        didSet {
            self.updateBorderCall = self.updateBorder
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0
    {
        didSet {
            self.updateCornerCall = self.updateCorner
        }
    }
    
    @IBInspectable var iconFromURLString: String = ""
    {
        didSet {
            self.downloadImage = self.imageFromUrl
           
        }
    }
    
    var imageView : UIImageView?
    var updateCornerCall : (()-> Void)?
    var updateBorderCall : (()-> Void)?
    var downloadImage: (() -> Void)?
    
    var originalHeight: CGFloat = 0.0
    var originalWidth: CGFloat = 0.0
    
    override func willMove(toSuperview newSuperview: UIView?) {
        originalWidth = self.frame.width
        originalHeight = self.frame.height
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        updateBorderCall?()
        updateCornerCall?()
        downloadImage?()
        super.willMove(toWindow: newWindow)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += self.leftPadding
        return textRect
    }
    
    func updateCorner() {
        let smallerRatio = (frame.height / originalHeight) > (frame.width / originalWidth ) ? (frame.width / originalWidth ) : (frame.height / originalHeight)
        layer.cornerRadius = cornerRadius * smallerRatio
        layer.masksToBounds = (cornerRadius * smallerRatio) > 0
    }
    
    func updateBorder() {
        if (addBorderTop > 0 && Set([addBorderTop, addBorderBottom, addBorderRight, addBorderLeft]).count == 1) {
            return addShapeLayer(addBorderTop)
        }
        if addBorderTop > 0  {
            self.addBorderUtility(0, y: 0, width:self.bounds.size.width, height: addBorderTop)
        }
        if addBorderBottom > 0 {
            self.addBorderUtility(0, y: self.bounds.size.height, width:self.bounds.size.width, height: addBorderBottom)
        }
        if addBorderRight > 0 {
            self.addBorderUtility(0, y: 0, width:addBorderRight, height: self.bounds.size.height)
        }
        if addBorderLeft > 0 {
            self.addBorderUtility(self.bounds.size.width - addBorderLeft, y:0, width: addBorderLeft, height: self.bounds.size.height)
        }
    }
    
    private func addBorderUtility(_ x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let border = CALayer()
        border.backgroundColor = borderColor.cgColor;
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
    
    private func addShapeLayer(_ size: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        layer.mask = maskLayer
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = size
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
    #if !TARGET_INTERFACE_BUILDER
    private func imageFromUrl() {
        if let url = URL(string: self.iconFromURLString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                        self.leftViewMode = UITextFieldViewMode.always
                        self.imageView!.contentMode = .scaleAspectFit
                        self.imageView!.image = UIImage(data: data)
                        self.leftView = self.imageView
                    }
                }
            }
        }
    }
    #endif
}
