//
//  IconView.swift
//  EDUVance
//
//  Created by jhkim on 2015. 6. 24..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import UIKit

protocol IconBtnProtocol
{
    func onBtnTouched(index : Int)
}

class IconView: UIView {
    
    var indexOfBtn : Int = 0
    var titleString : String = "미입력값"
    
    let labelForTitle = UILabel()
    let labelForCount = UILabel()
    let viewForCount = UIImageView()
    
    var deligate : IconBtnProtocol? = nil
    
    
    // 타이틀의 기본/눌렸을 경우 컬러
    let colorOfTitleNormal = UIColor(red: 62/255, green: 96/255, blue: 152/255, alpha: 1)
    let colorOfTitleSelected = UIColor(red: 60/255, green: 78/255, blue: 106/255, alpha: 1)
    
    
    
    func initWithTitleAndIcon( title : String , imageName : String , index : Int)
    {
        self.indexOfBtn = index
        self.titleString = title
        
        // 이미지 뷰 파일에서 가져옴
        let iconImage = UIImage(named: imageName)!
        
        // 이미지뷰 사이즈 결정
        let widthOfImage = self.frame.size.width-14
        let heightOfImage = (widthOfImage * iconImage.size.height) / iconImage.size.width
        
        // 이미지뷰 생성 및 이미지 할당
        let imageView = UIImageView(image: iconImage)
        imageView.frame = CGRectMake(7, 10, widthOfImage, heightOfImage)
        self.addSubview(imageView)
        
        // 라벨 설정
        let offsetOfTitle = imageView.frame.origin.y + imageView.frame.size.height
        let heightSizeOfTitle = self.frame.size.height - offsetOfTitle - 5
        
        self.labelForTitle.frame = CGRectMake(0, offsetOfTitle  , self.frame.size.width, heightSizeOfTitle)
        
        labelForTitle.text = title
        
        labelForTitle.textColor = colorOfTitleNormal
        labelForTitle.textAlignment = NSTextAlignment.Center
        labelForTitle.font = UIFont.boldSystemFontOfSize(13)
        
        // 디버그 테스트용 컬러 임힘
//        labelForTitle.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

        self.addSubview(labelForTitle)
        
        // 카운트 전체 이미지뷰 생성 및 삽입
        let sizeOfCountView = widthOfImage * 3 / 8
        self.viewForCount.frame = CGRectMake( widthOfImage - sizeOfCountView , 0, sizeOfCountView, sizeOfCountView)
        self.viewForCount.image = UIImage(named: "lnc_info_noti")
        imageView.addSubview(self.viewForCount)
        
        // 카운트 라벨 생성 및 삽입
        self.labelForCount.frame = CGRectMake(0, 0, self.viewForCount.frame.size.width, self.viewForCount.frame.size.height)
        self.labelForCount.font = UIFont.boldSystemFontOfSize(13)
        self.labelForCount.textColor = UIColor.whiteColor()
        self.labelForCount.textAlignment = NSTextAlignment.Center
        self.viewForCount.addSubview(self.labelForCount)
        self.viewForCount.hidden = true
        // 테스트
        /*
        let randomInt = Int(arc4random_uniform(1000))
        self.labelForCount.text = "\(randomInt)"
        self.viewForCount.hidden = false
        */
        
        
        // 버튼 설정 및 삽입
        let btn = UIButton(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        btn.addTarget(self, action: "onTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside)
        
        btn.addTarget(self, action: "onTouchDown:", forControlEvents: UIControlEvents.TouchDown)
        btn.addTarget(self, action: "onTouchUpOutside:", forControlEvents: UIControlEvents.TouchUpOutside)
        
        self.addSubview(btn)
        
    }
    
    
    func showBadgeWithCount(count : String)
    {
        if self.viewForCount.hidden
        {
            self.viewForCount.hidden = false
        }
        
        self.labelForCount.text = count
    }
    
    func hideBadgeInIcon()
    {
        self.viewForCount.hidden = true
    }
    
    
    
    // 버튼 터치 관련
    func onTouchUpInside(sender : UIButton)
    {
        self.labelForTitle.textColor = colorOfTitleNormal
        self.deligate?.onBtnTouched(self.indexOfBtn)
    }
    
    func onTouchDown(sender : UIButton)
    {
        self.labelForTitle.textColor = colorOfTitleSelected
    }
    
    func onTouchUpOutside(sender : UIButton)
    {
        self.labelForTitle.textColor = colorOfTitleNormal
    }

}
