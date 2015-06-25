//
//  Tab02MainView.swift
//  EDUVance
//
//  Created by jhkim on 2015. 6. 25..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import UIKit

class Tab02MainView: UIView ,IconBtnProtocol
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
    
    
    override func drawRect(rect: CGRect)
    {
        super.drawRect(rect)
        
        // 스크롤뷰와 컨테이너 뷰 초기화
        initViews()
        
    }
    
    func onBtnTouched(index : Int)
    {
        
    }
    
    
    func initViews()
    {
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
        
        mainContainerView.addSubview(self.subContainerView)
        
        
        // 현재 뷰에 스크롤뷰와 컨테이너 뷰 삽입
        mainScrollView.addSubview(mainContainerView)
        self.addSubview(mainScrollView)
        
        // 스크롤뷰 컨텐츠 사이즈 결정
        mainScrollView.contentSize = mainContainerView.frame.size
        
        // 백그라운드 일러스트 삽입
        setBackgroundIllust()
    }
    
    
    func arrangeIcon(index : Int , oneIcon : IconView , width : CGFloat , height : CGFloat)
    {
        let xOffset = (CGFloat)( (index%3) * Int(width))
        let yOffset = (CGFloat)((index/3) * Int(height))
        
        let rectOfIcon = CGRectMake( xOffset ,yOffset , width, height)
        oneIcon.frame = rectOfIcon
        
        println("반복문 확인 : rectOfIcon : \(rectOfIcon)")
        
        let oneRandomInt = (CGFloat)(Int(arc4random_uniform(255)))
        let twoRandomInt = (CGFloat)(Int(arc4random_uniform(255)))
        
        oneIcon.backgroundColor = UIColor(red: oneRandomInt/255, green: twoRandomInt/255, blue: oneRandomInt/255, alpha: 1)

        
        
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
