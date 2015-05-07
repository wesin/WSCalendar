//
//  CalendarItem.swift
//  CALayerDemo
//
//  Created by 何文新 on 15/4/30.
//  Copyright (c) 2015年 hupun. All rights reserved.
//

import UIKit

class WSCalendarItem: UICollectionViewCell,UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    var collection:UICollectionView?
    var dayType:CalendarType = .Day {
        didSet {
            if dayType != oldValue {
                collection?.reloadData()
            }
        }
    }
    
    var yearPerCount:Int = 5
    
    var headerHeight:CGFloat = 40
    var weekHeaderHeight:CGFloat = 30
    var borderWidth:CGFloat = 5
    
    var currentDate:NSDate = NSDate() {
        didSet {
            if currentDate != oldValue {
                collection?.reloadData()
            }
        }
    }
    
    
    private var cellWidth:CGFloat {
        get {
            switch dayType {
            case .Day:
                return (self.bounds.width - 2 * borderWidth) / 7
            case .Month:
                return (self.bounds.width - 2 * borderWidth) / 4
            case .Year:
                return (self.bounds.width - 2 * borderWidth) / CGFloat(yearPerCount)
            }
            // - 8 * borderWidth
        }
    }
    
    private var cellHeight:CGFloat {
        get {
            switch dayType {
            case .Day:
                return (collection!.contentSize.height - weekHeaderHeight - headerHeight - 2 * borderWidth) / 6
            case .Month:
                return (collection!.contentSize.height - headerHeight - 2 * borderWidth) / 3
            case .Year:
                return (collection!.contentSize.height - 2 * borderWidth) / CGFloat(yearPerCount)
            }
        }
    }
    
    var flowLayout:UICollectionViewFlowLayout?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.blackColor().CGColor
        
        flowLayout = UICollectionViewFlowLayout()
        flowLayout?.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        collection = UICollectionView(frame: bounds, collectionViewLayout: flowLayout!)
        collection?.backgroundColor = UIColor.whiteColor()
        self.addSubview(collection!)
        collection?.showsHorizontalScrollIndicator = false
        collection?.showsVerticalScrollIndicator = false
        
        collection?.contentSize = CGSize(width: frame.width, height: frame.height)
        collection?.contentInset = UIEdgeInsetsZero
        flowLayout?.itemSize = CGSize(width: cellWidth, height: cellHeight)
        flowLayout?.minimumInteritemSpacing = 0
        flowLayout?.minimumLineSpacing = 0
        flowLayout?.sectionInset = UIEdgeInsetsMake(borderWidth, borderWidth, borderWidth, borderWidth)
        
        collection?.dataSource = self
        collection?.delegate = self
        collection?.pagingEnabled = true
        collection?.registerClass(WSCalendarCell.self, forCellWithReuseIdentifier: "calendarcell")
        collection?.registerClass(WSCalendarHearderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerview")
        collection?.registerClass(WSCalendarDayHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "dayheaderview")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if dayType == .Year {
            return CGSizeZero
        } else if dayType == .Day {
            return CGSize(width: bounds.width, height: headerHeight + weekHeaderHeight)
        }
        return CGSize(width: bounds.width, height: headerHeight)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch dayType {
        case .Day:
            return 42
        case .Month:
            return 12
        case .Year:
            return Int(yearPerCount * yearPerCount)
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            var title = ""
            switch dayType {
            case .Year:
                title = ""
            case .Month:
                title = "%@年"
            case .Day:
                title = "%@年%@月"
            }
            if dayType == .Day {
                let reuseView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "dayheaderview", forIndexPath: indexPath) as? WSCalendarDayHeaderView
                reuseView?.setHeader(String.localizedStringWithFormat(title, "\(currentDate.year())", "\(currentDate.month())"))
                reuseView?.setLeftText(String.localizedStringWithFormat(title, "\(currentDate.dateByAddingMonths(-1).year())","\(currentDate.dateByAddingMonths(-1).month())"))
                reuseView?.setRightText(String.localizedStringWithFormat(title, "\(currentDate.dateByAddingMonths(1).year())","\(currentDate.dateByAddingMonths(1).month())"))
                return reuseView!
            } else {
                let reuseView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "headerview", forIndexPath: indexPath) as? WSCalendarHearderView
                reuseView?.setHeader(String.localizedStringWithFormat(title, "\(currentDate.year())", "\(currentDate.month())"))
                reuseView?.setLeftText(String.localizedStringWithFormat(title, "\(currentDate.dateByAddingYears(-1).year())"))
                reuseView?.setRightText(String.localizedStringWithFormat(title, "\(currentDate.dateByAddingYears(1).year())"))
                return reuseView!
            }
            
            
        }
        return UICollectionReusableView()
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("calendarcell", forIndexPath: indexPath) as? WSCalendarCell
        cell?.setSelect(false)
        cell?.setBlackColor(true)
        cell?.setToday(false)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("calendarcell", forIndexPath: indexPath) as? WSCalendarCell
        cell?.setSelect(false)
        cell?.setBlackColor(true)
        cell?.setToday(false)
        switch dayType {
        case .Day:
            let curDay = currentDay(index)
//            println(curDay.formattedDateWithFormat("yyyy-MM-dd"))
            cell?.setContent("\(curDay.day())")
            cell?.currentDay = curDay
            if curDay.isToday() {
                cell?.setToday(true)
            }
            //选中的日期则设为选中
            if curDay == curSelectDate {
                cell?.setSelect(true)
                collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .CenteredHorizontally)
            }
            //非本月颜色置灰
            if curDay.month() != currentDate.month() {
                cell?.setBlackColor(false)
            } else {
                cell?.setBlackColor(true)
            }
        case .Month:
            if curSelectMonth?.year() == currentDate.year() && curSelectMonth?.month() == index + 1 {
                cell?.setSelect(true)
            }
            cell?.setContent("\(index + 1)月")
        case .Year:
            let curYear = currentDate.year() + indexPath.row
            if curSelectYear?.year() == curYear {
                cell?.setSelect(true)
            }
            cell?.setContent("\(curYear)年")
        }
        return cell!
    }
    
    //获取cell对应的日期
    func currentDay(index:Int) -> NSDate {
        let firstD = firstDay()
//        println("firstDay:\(firstD)")
        let appendD = -firstD.weekday() + 1 + index
        return firstD.dateByAddingDays(appendD)
    }
    
    //获取整个日历的第一天
    func firstDay() -> NSDate {
//        println("currentDate:\(currentDate)")
        return currentDate.dateByAddingDays(-currentDate.day() + 1)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! WSCalendarCell
        cell.setSelect(false)
        if dayType == .Day {
            if cell.currentDay!.isToday() {
                cell.setToday(true)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! WSCalendarCell
        cell.setSelect(true)
        curSelectDate = nil
        curSelectMonth = nil
        curSelectYear = nil
        switch dayType {
        case .Day:
            curSelectDate = cell.currentDay!
            curSelectMonth = curSelectDate
            curSelectYear = curSelectDate
            if curSelectDate?.month() != currentDate.month() && curSelectDate?.daysFrom(currentDate) > 0 {
                NSNotificationCenter.defaultCenter().postNotificationName("scrollto", object: 1)
                return
            } else if curSelectDate?.month() != currentDate.month() && curSelectDate?.daysFrom(currentDate) < 0 {
                NSNotificationCenter.defaultCenter().postNotificationName("scrollto", object: -1)
                return
            }
            return
        case .Month:
            curSelectMonth = currentDate.dateByAddingMonths(indexPath.row - currentDate.month() + 1)
            curSelectYear = curSelectMonth
            NSNotificationCenter.defaultCenter().postNotificationName("changemode", object: "toDay")
        case .Year:
            curSelectYear = currentDate.dateByAddingYears(indexPath.row)
            NSNotificationCenter.defaultCenter().postNotificationName("changemode", object: "toMonth")
        }
    }
    
    
    
    func clearSelectDate() {
        collection?.reloadData()
    }
    
}