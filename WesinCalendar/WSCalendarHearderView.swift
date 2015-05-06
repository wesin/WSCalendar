//
//  CalendarHearderView.swift
//  CALayerDemo
//
//  Created by 何文新 on 15/4/30.
//  Copyright (c) 2015年 hupun. All rights reserved.
//

import UIKit

class WSCalendarHearderView: UICollectionReusableView {
    
    private var buttonLeft:UIButton?
    private var buttonRight:UIButton?
    private var labelTitle:UILabel?
    var titleWidth:CGFloat = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.grayColor()
        let rectLeft = CGRect(x: 0, y: 0, width: self.bounds.height * 2, height: self.bounds.height)
        buttonLeft = UIButton(frame: rectLeft)
        buttonLeft?.titleLabel?.adjustsFontSizeToFitWidth = true
        self.addSubview(buttonLeft!)
        let rectRight = CGRect(x: self.bounds.width - self.bounds.height * 2, y: 0, width: self.bounds.height * 2, height: self.bounds.height)
        buttonRight = UIButton(frame: rectRight)
        buttonRight?.titleLabel?.adjustsFontSizeToFitWidth = true
        self.addSubview(buttonRight!)
        labelTitle = UILabel()
        labelTitle?.frame = CGRect(x: (self.bounds.width - titleWidth) / 2, y: 0, width: titleWidth, height: self.bounds.height)
        labelTitle?.textAlignment = .Center
        self.addSubview(labelTitle!)
        
        buttonRight?.addTarget(self, action: Selector("scrollTo:"), forControlEvents: UIControlEvents.TouchUpInside)
        buttonLeft?.addTarget(self, action: Selector("scrollTo:"), forControlEvents: UIControlEvents.TouchUpInside)
        let gesture = UITapGestureRecognizer(target: self, action: Selector("changeMode"))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        labelTitle?.userInteractionEnabled = true
        labelTitle?.addGestureRecognizer(gesture)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func scrollTo(button:UIButton) {
        curSelectMonth = nil
        curSelectDate = nil
        curSelectYear = nil
        if button == buttonLeft {
//            curSelectYear = curSelectDate?.dateByAddingYears(-1)
            NSNotificationCenter.defaultCenter().postNotificationName("scrollto", object: -1)
        } else {
//            curSelectYear = curSelectDate?.dateByAddingYears(1)
            NSNotificationCenter.defaultCenter().postNotificationName("scrollto", object: 1)
        }
    }
    
    func changeMode() {
        NSNotificationCenter.defaultCenter().postNotificationName("changemode", object: nil)
    }
    
    func setLeftText(content:String) {
        buttonLeft?.setTitle(content, forState: UIControlState.Normal)
    }
    
    func setRightText(content:String) {
        buttonRight?.setTitle(content, forState: UIControlState.Normal)
    }
    
    func setHeader(content:String) {
        labelTitle?.text = content
    }
}
