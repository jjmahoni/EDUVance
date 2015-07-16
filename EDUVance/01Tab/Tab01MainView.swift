//
//  Tab01MainView.swift
//  EDUVance
//
//  Created by jhkim on 2015. 6. 26..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import UIKit


class Tab01MainView: BaseItemView
{
    
    //_______________________________________________________________________________________________________________________________________________
    //// 시간표 1개 Cell
    class TimeCellView : UIView
    {
        func setViewWithTitle(titleOfSubject :String, subtitleOfSubject : String , startPointX : String , startPointY : String , endPointX : String , endPointY : String , widthOfOneCell : CGFloat, heightOfOneCell : CGFloat , backgroundColorString : String)
        {
            let widthMarginOfTitle : CGFloat = 4
            let heightMarginOfTitle : CGFloat = 7

            let fontSizeOfCellTitle : CGFloat  = 12
            let fontSizeOfCellSubTitle : CGFloat = 10
            
            let heightOfCellMultiple = endPointX.toInt()! - startPointX.toInt()!
            self.frame = CGRectMake(widthOfOneCell + CGFloat( CGFloat(startPointY.toInt()!) * widthOfOneCell), CGFloat( CGFloat(startPointX.toInt()!) * heightOfOneCell), widthOfOneCell , CGFloat(heightOfCellMultiple) * heightOfOneCell)
            
            self.backgroundColor = UIColor(rgba: backgroundColorString)
            
            let widthOfOneTitle = widthOfOneCell - (widthMarginOfTitle*2)

            

            
            let fontOfCellTitle = UIFont.boldSystemFontOfSize(fontSizeOfCellTitle)
            let fontOfCellSubTitle = UIFont.boldSystemFontOfSize(fontSizeOfCellSubTitle)
            
            let heightOfTitle = HWILib.getHeightForView(titleOfSubject, font: fontOfCellTitle, width: widthOfOneTitle)
            let heightOfSubTitle = HWILib.getHeightForView(subtitleOfSubject, font: fontOfCellSubTitle, width: widthOfOneTitle )
            
            let containerView = UIView()
            
            let titleLabel = UILabel()
            titleLabel.numberOfLines = 0
            titleLabel.font = fontOfCellTitle
            titleLabel.frame = CGRectMake(0, 0, widthOfOneTitle, heightOfTitle)
            titleLabel.text = titleOfSubject
            titleLabel.textAlignment = NSTextAlignment.Center


            
            let subTitleLabel = UILabel()
            subTitleLabel.frame = CGRectMake(0, titleLabel.frame.height + heightMarginOfTitle, widthOfOneTitle, heightOfSubTitle)
            subTitleLabel.numberOfLines = 0
            subTitleLabel.font = fontOfCellSubTitle
            subTitleLabel.text = subtitleOfSubject
            subTitleLabel.textAlignment = NSTextAlignment.Center

            
            
            let heightOfTotalText = titleLabel.frame.height + heightMarginOfTitle + heightOfSubTitle
            
            containerView.frame = CGRectMake(widthMarginOfTitle, (self.frame.size.height - heightOfTotalText)/2 , widthOfOneTitle, heightOfTotalText)
            containerView.addSubview(titleLabel)
            containerView.addSubview(subTitleLabel)
            
            self.addSubview(containerView)
            

            
        }
    }
    //// 시간표 1개 Cell
    //_______________________________________________________________________________________________________________________________________________
    

    
    
    
    var containerScrollView = UIScrollView()
    var containerViewInScroll = UIView()
    var titleLabel = UILabel()
    

    

    
    // 타이틀 라벨의 세로 크기 37
    let heightOfTitleLabel : CGFloat = 37
    let fontSizeOfTitle : CGFloat = 13
    
    
    // 가로 셀의 갯수
    let countOfWidthCell : CGFloat = 6
    
    // 추후 계산 될 가로 셀의 크기
    var widthOfOneCell : CGFloat = 0
    

    
    let marginOfContainer : CGFloat = 4
    let heightOfFirstCell : CGFloat = 29
    
    
    
    //_________________________________________________________________________________________________
    //   이 크기를 고침에 따라 시간표 1개 셀의 세로 길이가 변한다 ------> 적당하게 값을 변경해주면 UI가 예뻐질 것이다.
    let heightOfOneCell : CGFloat = 65
    //_________________________________________________________________________________________________
    
    
    
    let titleOfFirstCell = ["시간", "월요일" , "화요일", "수요일", "목요일", "금요일"]
    


    // 시간표 뷰가 보여질 때마다 호출됨
    override func onViewShow()
    {
        super.onViewShow()
        

        
        
        println("시간표 뷰가 화면에 보여짐")
        
        
        //  액티비티 인디케이터 표시
        HWILib.showActivityIndicator(self.viewController!)
        
        
        /// 시간표 데이터 통신에 성공함!
        TimeTableManager.getTimeTable { (isSuccess, result) -> () in
            
        //  액티비티 인디케이터 제거
            HWILib.hideActivityIndicator()
            
            if isSuccess
            {
                
                for oneView in self.subviews
                {
                    (oneView as! UIView).removeFromSuperview()
                }
                
                
                // 가로셀 크기 계산됨
                self.widthOfOneCell = (self.frame.size.width - self.marginOfContainer*2) / self.countOfWidthCell
                
                self.containerScrollView = UIScrollView()
                self.containerViewInScroll = UIView()
                self.titleLabel = UILabel()
                
                
                // 상단 타이틀 추가
                self.titleLabel.frame = CGRectMake(0, ConstantValues.statusBarHeight, self.frame.size.width, self.heightOfTitleLabel)
                self.titleLabel.backgroundColor = ConstantValues.color01_white
                self.titleLabel.text = "\(TimeTableManager.year) 학년도 제 \(TimeTableManager.semester) 학기"
                self.titleLabel.textColor = UIColor.redColor()
                self.titleLabel.font = UIFont.boldSystemFontOfSize(self.fontSizeOfTitle)
                self.titleLabel.textAlignment = NSTextAlignment.Center
                
                self.addSubview(self.titleLabel)
                
                
                
                var yOffsetOfFirstCell = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height
                
                // 첫번째 행 -> 시간, 월요일, 화요일, 수요일 ...  출력
                for (index, oneCellFirstTitle) in enumerate(self.titleOfFirstCell)
                {
                    let oneFirstCell = UILabel()
                    oneFirstCell.textAlignment = NSTextAlignment.Center
                    oneFirstCell.text = oneCellFirstTitle
                    
                    oneFirstCell.textColor = ConstantValues.color02_black
                    oneFirstCell.frame = CGRectMake( CGFloat(index) * self.widthOfOneCell, yOffsetOfFirstCell, self.widthOfOneCell, self.heightOfFirstCell)
                    self.addSubview(oneFirstCell)
                }
                
                
                
                
                
                //스크롤뷰 크기 정하기
                let heightOfScrollView = self.frame.size.height - ConstantValues.statusBarHeight - self.heightOfTitleLabel - 80
                
                
                self.containerViewInScroll.frame = CGRectMake(self.marginOfContainer, 0, self.widthOfOneCell * 6, self.heightOfOneCell * CGFloat(TimeTableManager.timetableForm.count))
                
                self.containerScrollView.frame = CGRectMake(0, yOffsetOfFirstCell + self.heightOfFirstCell , self.frame.size.width ,  heightOfScrollView )
                
                self.containerScrollView.contentSize = self.containerViewInScroll.frame.size
                self.containerScrollView.addSubview(self.containerViewInScroll)
                
                
                self.addSubview(self.containerScrollView)
                
                
                
                
                
                
                
                
                // 첫번째 열 -> 09:00 , 10:00, 11:00 ... 출력
                for (index, oneTime) in enumerate(TimeTableManager.timetableForm)
                {
                    let oneTimeCell = UILabel()
                    oneTimeCell.textAlignment = NSTextAlignment.Center
                    oneTimeCell.text = oneTime
                    oneTimeCell.textColor = ConstantValues.color02_black
                    
                    oneTimeCell.frame = CGRectMake(0, (self.heightOfOneCell * CGFloat(index)), self.widthOfOneCell, self.heightOfOneCell)
                    self.containerViewInScroll.addSubview(oneTimeCell)
                }
                
                
                
                
                // 셀들 배치
                for oneCellData in TimeTableManager.myTimetable
                {
                    let oneTimeCellView = TimeCellView()
                    oneTimeCellView.setViewWithTitle(oneCellData.name, subtitleOfSubject: oneCellData.place, startPointX: oneCellData.startPointX, startPointY: oneCellData.startPointY, endPointX: oneCellData.endPointX, endPointY: oneCellData.endPointY, widthOfOneCell: self.widthOfOneCell, heightOfOneCell: self.heightOfOneCell, backgroundColorString: oneCellData.bgColor)
                    
                    self.containerViewInScroll.addSubview(oneTimeCellView)
                }

                
            }
            else
            {
                println("시간표 조회 중 에러 : \(result)")
                
                if result == "액세스 토큰이 만료됨"
                {
                    self.moveToLogin()
                    return
                }
            }
        }
        
        
        
    }
    
    
    
}
