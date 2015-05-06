//
//  CalendarCell.swift
//  CALayerDemo
//
//  Created by 何文新 on 15/4/30.
//  Copyright (c) 2015年 hupun. All rights reserved.
//

import UIKit

class WSCalendarCell: UICollectionViewCell {

    var labelForContent = UILabel()
    
    var currentDay:NSDate?
    var selectLayer:CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(labelForContent)
        labelForContent.textAlignment = .Center
        labelForContent.adjustsFontSizeToFitWidth = true
        
        selectLayer = CAShapeLayer()

        selectLayer?.backgroundColor = UIColor.clearColor().CGColor
        selectLayer?.hidden = true
        self.layer.insertSublayer(selectLayer!, atIndex: 0)
//        labelForContent.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        labelForContent.frame = self.bounds
        let width = min(bounds.height * 5 / 6, bounds.width * 5 / 6)
        selectLayer?.frame = CGRect(x: (bounds.width - width) / 2, y: (bounds.height - width) / 2, width: width, height: width)
        selectLayer?.path = UIBezierPath(ovalInRect: selectLayer!.bounds).CGPath
    }
    
    func setContent(content:String) {
        labelForContent.text = content
    }
    
    func setSelect(boolValue:Bool) {
        selectLayer?.fillColor = boolValue ? UIColor.greenColor().CGColor : UIColor.yellowColor().CGColor
//        selectLayer?.fillColor = UIColor.yellowColor().CGColor
        selectLayer?.hidden = !boolValue
    }
    
    func setBlackColor(boolValue:Bool) {
        labelForContent.textColor = boolValue ? UIColor.blackColor() : UIColor.grayColor()
    }
    
    func setToday(boolValue:Bool) {
        selectLayer?.fillColor = boolValue ? UIColor.brownColor().CGColor : UIColor.yellowColor().CGColor
        selectLayer?.hidden = !boolValue
    }
    
}
