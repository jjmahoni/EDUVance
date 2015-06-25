//
//  MainVC.swift
//  EDUVance
//
//  Created by jhkim on 2015. 6. 25..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import UIKit

class MainVC: BaseVC , UIScrollViewDelegate{
    
    @IBOutlet weak var tab01Btn: UIButton!
    @IBOutlet weak var tab02Btn: UIButton!
    @IBOutlet weak var tab03Btn: UIButton!
    @IBOutlet weak var tab04Btn: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var mainContainerView: UIView!
    
    var tabBarBtns : [UIButton] = []
    
    
    // 뷰가 로드된 후 초기 뷰들 배치
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setTopTitlelabelString("에듀밴스")
        initTabbar()


    }
    
    // 뷰가 모두 배치되고 난 다음 마지막에 스크롤 컨텐츠 사이즈 부여
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        self.mainScrollView.contentSize = self.mainContainerView.frame.size
        self.changeTabWithIndex(1)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initTabbar()
    {
        self.tabBarBtns = [tab01Btn,tab02Btn,tab03Btn,tab04Btn]


        for (index, oneTabBtn) in enumerate(self.tabBarBtns)
        {
            oneTabBtn.setTitleColor(ConstantValues.color01_white, forState: UIControlState.Normal)
            oneTabBtn.setTitleColor(ConstantValues.color_main06_32_60_102, forState: UIControlState.Selected)
            oneTabBtn.setTitleColor(ConstantValues.color_main06_32_60_102, forState: UIControlState.Highlighted)
            oneTabBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(13)
            oneTabBtn.backgroundColor = ConstantValues.color_main04_134_156_190
            oneTabBtn.tag = index
            println("인덱스 : \(index)")
            oneTabBtn.addTarget(self, action: "onTabTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
    }
    
    func onTabTouchUpInside(sender : UIButton)
    {
        self.changeTabWithIndex(sender.tag)
    }
    
    
    // 탭 체인지
    func changeTabWithIndex( index : Int)
    {
        
        for oneBtn in self.tabBarBtns
        {
            oneBtn.selected = false
        }
        
        self.tabBarBtns[index].selected = true
        
        println("들어온 인덱스 확인 : \(index)")
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.mainScrollView.contentOffset = CGPointMake( self.view.frame.size.width * CGFloat(index) , 0)
        })
        
        // 탑 타이틀바 텍스트 변경
        self.setTopTitlelabelString(self.tabBarBtns[index].titleLabel!.text!)
        
    }
    

    // 스크롤뷰 드래그가 끝날 때
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        let currentPageIndex  = Int(scrollView.contentOffset.x / self.view.frame.size.width)
        self.changeTabWithIndex(currentPageIndex)
    }
    

}
