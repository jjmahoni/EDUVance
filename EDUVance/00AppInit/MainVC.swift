//
//  MainVC.swift
//  EDUVance
//
//  Created by jhkim on 2015. 6. 25..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import UIKit

class MainVC: BaseVC {
    
    @IBOutlet weak var tab01Btn: UIButton!
    @IBOutlet weak var tab02Btn: UIButton!
    @IBOutlet weak var tab03Btn: UIButton!
    @IBOutlet weak var tab04Btn: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var mainContainerView: UIView!
    
    var tabBarBtns : [UIButton] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTopTitlelabelString("에듀밴스")
        initTabbar()
        self.mainScrollView.contentSize = self.mainContainerView.frame.size
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initTabbar()
    {
        self.tabBarBtns = [tab01Btn,tab02Btn,tab03Btn,tab04Btn]

        var tabbarIndex = 0
        for oneTabBtn in self.tabBarBtns
        {
            oneTabBtn.setTitleColor(ConstantValues.color01_white, forState: UIControlState.Normal)
            oneTabBtn.setTitleColor(ConstantValues.color_main06_32_60_102, forState: UIControlState.Selected)
            oneTabBtn.setTitleColor(ConstantValues.color_main06_32_60_102, forState: UIControlState.Highlighted)
            oneTabBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(13)
            oneTabBtn.backgroundColor = ConstantValues.color_main04_134_156_190
            oneTabBtn.tag = tabbarIndex
            tabbarIndex++
            
            oneTabBtn.addTarget(self, action: "onTabTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
    }
    
    func onTabTouchUpInside(sender : UIButton)
    {
        for oneBtn in self.tabBarBtns
        {
            oneBtn.selected = false
        }
        sender.selected = true
    }
    

    
    
    
}
