//
//  CalendarDayHeaderView.swift
//  CALayerDemo
//
//  Created by 何文新 on 15/5/4.
//  Copyright (c) 2015年 hupun. All rights reserved.
//

import UIKit

class WSCalendarDayHeaderView: UICollectionViewCell {
    private var buttonLeft:UIButton?
    private var buttonRight:UIButton?
    private var labelTitle:UILabel?
    private var segForWeek:UISegmentedControl?
    var titleWidth:CGFloat = 100
    var headerHeight:CGFloat = 40
    
    var currentMonth:Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.grayColor()
        let rectLeft = CGRect(x: 0, y: 0, width: headerHeight * 2, height: headerHeight)
        buttonLeft = UIButton(frame: rectLeft)
        buttonLeft?.titleLabel?.adjustsFontSizeToFitWidth = true
        self.addSubview(buttonLeft!)
        let rectRight = CGRect(x: self.bounds.width - headerHeight * 2, y: 0, width: headerHeight * 2, height: headerHeight)
        buttonRight = UIButton(frame: rectRight)
        buttonRight?.titleLabel?.adjustsFontSizeToFitWidth = true
        self.addSubview(buttonRight!)
        labelTitle = UILabel()
        labelTitle?.frame = CGRect(x: (self.bounds.width - titleWidth) / 2, y: 0, width: titleWidth, height: headerHeight)
        labelTitle?.textAlignment = .Center
        self.addSubview(labelTitle!)
        
        let weekNames = NSCalendar.currentCalendar().shortStandaloneWeekdaySymbols
        segForWeek = UISegmentedControl(items: weekNames)
        segForWeek?.backgroundColor = UIColor.whiteColor()
        segForWeek?.enabled = false
        self.addSubview(segForWeek!)
        segForWeek?.frame = CGRect(x: 0, y: headerHeight, width: frame.width, height: frame.height - headerHeight)
        println(weekNames)
        
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
            NSNotificationCenter.defaultCenter().postNotificationName("scrollto", object: -1)
        } else {
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
