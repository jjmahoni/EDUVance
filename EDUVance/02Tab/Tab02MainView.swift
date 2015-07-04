//
//  Tab02MainView.swift
//  EDUVance
//
//  Created by jhkim on 2015. 6. 25..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import UIKit

class Tab02MainView: BaseItemView ,IconBtnProtocol
{
    let mainScrollView = BaseScrollView()
    let mainContainerView = UIView()
    let subContainerView = UIView()
    
    
    let icon01_notice  = IconView()
    let icon02_message  = IconView()
    let icon03_schedule  = IconView()
    let icon04_univeInfo  = IconView()
    let icon05_liveInfo  = IconView()
    let icon06_jobInfo  = IconView()
    let icon07_settings  = IconView()
    
    var iconsArray : [IconView] = []
    
//    var isViewDidLoad = false
    
    override func drawRect(rect: CGRect)
    {
        super.drawRect(rect)

    }


    func onViewLoad()
    {
            initViews()
    }
    
    
    
    override func onViewShow()
    {
        super.onViewShow()
        
        println("2번 페이지의 뷰가 보여질 때")
        
        
        // 액티비티 인디케이터 표시 및 배지카운트 조회
//        HWILib.showActivityIndicator(self.viewController!)
        NetworkManager.getMainMenuBadgeCount("", scheduleIdx: "", schoolInfoIdx: "", lifeInfoIdx: "", jobInfoIdx: "") { (isSuccess, result, jsonData) -> () in
            
//            HWILib.hideActivityIndicator()
            
            if !isSuccess
            {
                if result == "인터넷연결안됨"
                {
                    self.viewController?.alertWithNoInternetConnection()
                    return
                }
                
                println("배지카운트 조회 실패")
                return
            }
            
            if let json : NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
            {
                
                
                if let resultCode = json.objectForKey("resultCode") as? String
                {
                    
                    if resultCode == "911"
                    {
                        
                        if let dataDic = json.objectForKey("data") as? NSDictionary
                        {
                            
                            for oneIcon in self.iconsArray
                            {
                                oneIcon.hideBadgeInIcon()
                            }
                            
                            if let noticeCount = dataDic.objectForKey("noticeCount") as? String
                            {
                                self.setBadgeCountWithViewAndValue( self.icon01_notice, title: noticeCount)
                            }
                            if let messageCount = dataDic.objectForKey("messageCount") as? String
                            {
                                self.setBadgeCountWithViewAndValue( self.icon02_message, title: messageCount)
                            }
                            if let scheduleCount = dataDic.objectForKey("scheduleCount") as? String
                            {
                                self.setBadgeCountWithViewAndValue( self.icon03_schedule, title: scheduleCount)
                            }
                            if let schoolInfoCount = dataDic.objectForKey("schoolInfoCount") as? String
                            {
                                self.setBadgeCountWithViewAndValue( self.icon04_univeInfo, title: schoolInfoCount)
                            }
                            if let lifeInfoCount = dataDic.objectForKey("lifeInfoCount") as? String
                            {
                                self.setBadgeCountWithViewAndValue( self.icon05_liveInfo, title: lifeInfoCount)
                            }
                            if let jobInfoCount = dataDic.objectForKey("jobInfoCount") as? String
                            {
                                self.setBadgeCountWithViewAndValue( self.icon06_jobInfo, title: jobInfoCount)
                            }
                            
                            
                        }
                    }
                    else if resultCode == "999"
                    {
                        println("액세스토큰이 만료된 것으로 보임")

                        
                        self.viewController!.alertWithTitle("액세스토큰이 만료되었습니다. 다시 로그인 해 주세요", clickString: "로그인으로 이동", clickHandler: { () -> Void in
                            if let mainVC = self.viewController! as? MainVC
                            {
                                mainVC.performSegueWithIdentifier("main_login_seg", sender: mainVC)
                            }
                        })
                    }
                }
            }
            
            
            
        }
        
        
        
    }
    
    
    func setBadgeCountWithViewAndValue(iconView : IconView , title : String)
    {
        if title != "0"
        {
            iconView.showBadgeWithCount(title)
        }
    }
    
    
    
    
    
    
    // 아이콘 터치되었을 경우  --> 해당 화면으로 이동
    func onBtnTouched(index : Int)
    {
        println("아이콘 뷰 터치 감지 ---> 인덱스 : \(index)")
        
        self.viewController?.performSegueWithIdentifier("main_list", sender: ConstantValues.iconTitleArray[index])
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func initViews()
    {
        
        self.backgroundColor = ConstantValues.color_main03_230_234_242
        
        
        mainScrollView.backgroundColor = UIColor.clearColor()
        // 메인 스크롤뷰 프레임 결정
        mainScrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)


        
        // 아이콘들 배열 생성
        self.iconsArray = [
            self.icon01_notice,
            self.icon02_message,
            self.icon03_schedule,
            self.icon04_univeInfo,
            self.icon05_liveInfo,
            self.icon06_jobInfo,
            self.icon07_settings
        ]
        
        // 여백 15 * 27
        // 아이콘 뷰 1개 크기 96 * 123
        
        let marginOfWidth : CGFloat = 15
        let marginOfHeight : CGFloat = 27
        
        // 비율을 측정하기 위한 아이콘 뷰 크기  96 * 123
        
        
        
        let widthOfSubContainerView = self.frame.size.width - marginOfWidth*2
        let widthOfOneIconView = widthOfSubContainerView / 3
        
        let heightOfOneIconView = widthOfOneIconView * 123 / 96
        let heightOfSubContainerView = heightOfOneIconView * 3
        
        
        
        
        
        
        subContainerView.frame = CGRectMake(marginOfWidth, marginOfHeight, widthOfSubContainerView, heightOfSubContainerView )
        
        
        for (index, oneIconView) in enumerate(self.iconsArray)
        {
            self.arrangeIcon(index, oneIcon: oneIconView ,width : widthOfOneIconView, height : heightOfOneIconView)
        }
        
        
        
        // 테스트용
        mainContainerView.frame = CGRectMake(0, 0, self.frame.size.width, heightOfSubContainerView + marginOfHeight)
        mainContainerView.backgroundColor = UIColor.clearColor()
        mainContainerView.addSubview(self.subContainerView)
        
        

        
        // 현재 뷰에 스크롤뷰와 컨테이너 뷰 삽입
        mainScrollView.addSubview(mainContainerView)
        
        // 백그라운드 일러스트 삽입
        setBackgroundIllust()
        
        self.addSubview(mainScrollView)
        

        
        // 스크롤뷰 컨텐츠 사이즈 결정
        mainScrollView.contentSize = mainContainerView.frame.size
        

        
    }
    
    
    func arrangeIcon(index : Int , oneIcon : IconView , width : CGFloat , height : CGFloat)
    {
        let xOffset = (CGFloat)( (index%3) * Int(width))
        let yOffset = (CGFloat)((index/3) * Int(height))
        
        let rectOfIcon = CGRectMake( xOffset ,yOffset , width, height)
        oneIcon.frame = rectOfIcon
        
        
        /*println("반복문 확인 : rectOfIcon : \(rectOfIcon)")
        
        let oneRandomInt = (CGFloat)(Int(arc4random_uniform(255)))
        let twoRandomInt = (CGFloat)(Int(arc4random_uniform(255)))
        
        oneIcon.backgroundColor = UIColor(red: oneRandomInt/255, green: twoRandomInt/255, blue: oneRandomInt/255, alpha: 1)
        */
        
        
        oneIcon.initWithTitleAndIcon(ConstantValues.iconTitleArray[index], imageName: ConstantValues.iconImageNameArray[index] , index : index)
        oneIcon.deligate = self
        
        self.subContainerView.addSubview(oneIcon)
    }
    
    
    
    func setBackgroundIllust()
    {
        let backIllust = UIImage(named: "img_bg_illust")!
        
        let heightOfImage = (self.frame.size.width * backIllust.size.height) / backIllust.size.width
        
        println("이미지 확인 : \(backIllust)")
        
        let backgroundImageView = UIImageView(image: backIllust)
        backgroundImageView.frame = CGRectMake(0, self.frame.height-heightOfImage, self.frame.size.width, heightOfImage)
        
        self.addSubview(backgroundImageView)
    }
}
