//
//  CalendarView.swift
//  CALayerDemo
//
//  Created by 何文新 on 15/4/13.
//  Copyright (c) 2015年 hupun. All rights reserved.
//

import UIKit

enum CalendarType {
    case Day
    case Month
    case Year
}

var beginDate:NSDate = NSDate(timeIntervalSince1970: 0)
var endDate:NSDate = beginDate.dateByAddingYears(100)
var curSelectDate:NSDate? = NSDate()
var curSelectMonth:NSDate? = NSDate()
var curSelectYear:NSDate? = NSDate()

class WSCalendarView: UIView,UICollectionViewDataSource,UICollectionViewDelegate {
    

//    var curDate:NSDate = NSDate()
    
    private let dayCount = 42
    var monthHorCount:Int = 4
    var monthVerCount:Int = 3
    var yearPerCount:Int = 4
    
    private var showMode:CalendarType = .Day
    
    private var collectView:UICollectionView?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    private var currentSection:Int {
        get {
            if let itemArray = collectView?.indexPathsForVisibleItems() as? [NSIndexPath] {
                if itemArray.count > 0 {
                return itemArray[0].section
                }
                return 0
            }
            return 0
        }
    }
    
    override func drawRect(rect: CGRect) {
        //设置默认的时区
//        NSDate.setDefaultCalendarIdentifier(NSCalendarIdentifierChinese)
        var collectLayout = UICollectionViewFlowLayout()
        collectLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        collectLayout.minimumInteritemSpacing = 0
        collectLayout.minimumLineSpacing = 0
        collectLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectLayout.itemSize = rect.size
        
        collectView = UICollectionView(frame: rect, collectionViewLayout: collectLayout)
        self.addSubview(collectView!)
        collectView!.delegate = self
        collectView!.dataSource = self
        collectView!.pagingEnabled = true
        collectView!.showsHorizontalScrollIndicator = false
        collectView!.showsVerticalScrollIndicator = false
        collectView?.backgroundColor = UIColor.grayColor()
        
        collectView!.registerClass(WSCalendarItem.self, forCellWithReuseIdentifier: "calendarcell")
        var todayIndex = NSDate().monthsFrom(beginDate)
        collectView?.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: todayIndex), atScrollPosition: .CenteredHorizontally, animated: false)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("scrollTo:"), name: "scrollto", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changeMode:"), name: "changemode", object: nil)
        let date = NSDate(year: 1988, month: 11, day: 3)
        let extraInterval = NSTimeZone.systemTimeZone().secondsFromGMTForDate(date)
        let utcDate = date.dateByAddingSeconds(extraInterval)
//        scrollToDate(utcDate)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        println(beginDate.weekday())
        println(endDate.weekday())
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "scrollto", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "changemode", object: nil)
    }
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        switch showMode {
        case .Day:
            return endDate.monthsFrom(beginDate)
        case .Month:
            return endDate.yearsFrom(beginDate)
        case .Year:
            return endDate.yearsFrom(beginDate) / (yearPerCount * yearPerCount)
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("calendarcell", forIndexPath: indexPath) as? WSCalendarItem
        cell?.yearPerCount = yearPerCount
        cell?.dayType = showMode
//        println(beginDate)
        var currentDate = NSDate()
        switch showMode {
        case .Day:
            currentDate = beginDate.dateByAddingMonths(indexPath.section)
        case .Month:
            currentDate = beginDate.dateByAddingYears(indexPath.section)
        case .Year:
            currentDate = beginDate.dateByAddingYears(indexPath.section * yearPerCount * yearPerCount)
        }
        cell?.currentDate = currentDate
//        println("currentDate:\(currentDate)")
        return cell!
    }
    
    
    
    //MARK:Notification
    func scrollTo(message:NSNotification) {
//        let visibleItems = collectView?.indexPathsForVisibleItems() as! [NSIndexPath]
        let cell = collectView?.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: currentSection)) as! WSCalendarItem
        let isNext = message.object as! Int
        var newIndex:NSIndexPath?
        if isNext == 1 {
            if currentSection == collectView!.numberOfSections() - 1 {
                return
            }
            newIndex = NSIndexPath(forRow: 0, inSection: currentSection + 1)
        } else {
            if currentSection == 0 {
                return
            }
            newIndex = NSIndexPath(forRow: 0, inSection: currentSection - 1)
        }
        collectView?.scrollToItemAtIndexPath(newIndex!, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
    }
    
    /**
    调整界面样式
    
    :param: message 消息通知
    */
    func changeMode(message:NSNotification) {
        if let messStr = message.object as? String {
            switch messStr {
            case "toMonth":
                showMode = .Month
                collectView?.reloadData()
                let index = curSelectYear!.yearsFrom(beginDate)
                collectView?.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: index), atScrollPosition: .CenteredHorizontally, animated: false)
                return
            case "toDay":
                showMode = .Day
                collectView?.reloadData()
                let index = curSelectMonth!.monthsFrom(beginDate)
                collectView?.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: index), atScrollPosition: .CenteredHorizontally, animated: false)
                return
            default:
                return
            }
        } else {
            switch showMode {
            case .Day:
                showMode = .Month
                let visibleYear = beginDate.dateByAddingMonths(currentSection)
                let indexYear = visibleYear.yearsFrom(beginDate)
                collectView?.reloadData()
                collectView?.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: indexYear), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
                return
            case .Month:
                showMode = .Year
                let index = Int(currentSection / (yearPerCount * yearPerCount))
                collectView?.reloadData()
                collectView?.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: index), atScrollPosition: .CenteredHorizontally, animated: false)
                return
            case .Year:
                showMode = .Day
                return
            }
        }
    }
    
    
    /**
    定位到某天
    
    :param: date
    */
    func scrollToDate(date:NSDate) {
        showMode = .Day
        let index = date.monthsFrom(beginDate)
        curSelectDate = date
        collectView?.reloadData()
        collectView?.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: index), atScrollPosition: .CenteredHorizontally, animated: false)
    }
    
    
}
