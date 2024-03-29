//
//  DetailWebViewVC.swift
//  EDUVance
//
//  Created by KimJeonghwi on 2015. 7. 6..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import UIKit

class DetailWebViewVC: BaseVC {
    
    var topTtitleText = ""
    var currentType = 0
    var currentIdx = ""
    
    @IBOutlet weak var hwi_title: UILabel!
    @IBOutlet weak var hwi_dateLabel: UILabel!
    @IBOutlet weak var hwi_webview: UIWebView!
    
    @IBOutlet weak var checkBoxBtn01_endAlarm: UIImageView!
    @IBOutlet weak var checkBoxBtn02_registSchedule: UIImageView!
    
    let checkbox_n_img = UIImage(named: "checkbox_blue_n")
    let checkbox_p_img = UIImage(named: "checkbox_blue_p")
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // 백버튼이 필요한 화면
        self.backBtnTemp.hidden = false
        
        // 상단 라벨 필요
        self.topTitleLabel.text = self.topTtitleText
        
        ListManager.commonDetailObject = CommonListItem()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        HWILib.showActivityIndicator(self)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        

        
        //상세 내용 불러오기
        ListManager.getDetailArticle(self.currentType, inputIdx: self.currentIdx) { (isSuccess, result) -> () in
            HWILib.hideActivityIndicator()
            if isSuccess
            {
                self.hwi_title.text = ListManager.commonDetailObject.wrTitle
                
                if ListManager.commonDetailObject.startDate == nil || ListManager.commonDetailObject.startDate == ""
                {
                    self.hwi_dateLabel.hidden = true
                }
                else
                {
                    self.hwi_dateLabel.hidden = false
                    self.hwi_dateLabel.text = "일정   \(ListManager.commonDetailObject.startDate!) - \(ListManager.commonDetailObject.endDate!)"
                }
                
                
                self.hwi_webview.loadHTMLString(ListManager.commonDetailObject.wrContent, baseURL: NSURL())
            }
            else
            {
                self.alertWithTitle(result, clickString: "확인", clickHandler: { () -> Void in
                    
                    self.performSegueWithIdentifier("seg_detailWeb_login", sender: self)
                })
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func onCheckBoxBtn01_endAlarm_touchupInside(sender: UIButton)
    {
        if self.checkBoxBtn01_endAlarm.image == checkbox_n_img
        {
            self.checkBoxBtn01_endAlarm.image = checkbox_p_img
        }
        else
        {
            self.checkBoxBtn01_endAlarm.image = checkbox_n_img
        }
    }
    
    
    
    @IBAction func onCheckBoxBtn02_endAlarm_touchupInside(sender: UIButton)
    {
        if self.checkBoxBtn02_registSchedule.image == checkbox_n_img
        {
            self.checkBoxBtn02_registSchedule.image = checkbox_p_img
        }
        else
        {
            self.checkBoxBtn02_registSchedule.image = checkbox_n_img
        }
        
    }
    
    
    
    override func onBackBtnTouch(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
