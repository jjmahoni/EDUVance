//
//  ListVC.swift
//  EDUVance
//
//  Created by jhkim on 2015. 6. 26..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import UIKit

class ListVC: BaseVC , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var listTableView: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.backBtnTemp.hidden = false
        
        println("리스트뷰 로딩 확인")
        
        let index = find( ConstantValues.iconTitleArray , self.topTitleLabel.text! )
        HWILib.showActivityIndicator(self)
        
        switch index!
        {
        case 0:
            // 공지사항 네트워크 시작
            ListManager.getNoticeList { (isSuccess, result) -> () in
                HWILib.hideActivityIndicator()
                
                if isSuccess
                {
                    self.listTableView.reloadData()
                }
            }
        case 3:
            // 학교정보 네트워크 시작
            ListManager.getSchoolInfoList { (isSuccess, result) -> () in
                HWILib.hideActivityIndicator()
                
                if isSuccess
                {
                    self.listTableView.reloadData()
                }
            }
        case 4:
            // 학교정보 네트워크 시작
            ListManager.getLifeInfoList { (isSuccess, result) -> () in
                HWILib.hideActivityIndicator()
                
                if isSuccess
                {
                    self.listTableView.reloadData()
                }
            }
            
        case 5:
            // 취업정보 네트워크 시작
            ListManager.getJobInfoList { (isSuccess, result) -> () in
                HWILib.hideActivityIndicator()
                
                if isSuccess
                {
                    self.listTableView.reloadData()
                }
            }
            
            
            
        default:
           break
        }
        
        
        
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        
    }
    
    
    
    override func onBackBtnTouch(sender: UIButton) {
        super.onBackBtnTouch(sender)
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            println("메인뷰로 돌아가기 확인")
        })
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListManager.commonList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell") as! ListCell
        
        let oneItem  = ListManager.commonList[indexPath.row]
        
        cell.hwi_titleLabel.text = oneItem.wrTitle
        cell.hwi_contentLabel.text = oneItem.wrContent
        
        if oneItem.startDate != nil && oneItem.endDate  != nil
        {
            
            cell.hwi_dateLabel.text = "\(oneItem.startDate!) - \(oneItem.endDate!)"
            
            if ( oneItem.startDate! == "" &&  oneItem.endDate! == "")
            {
                cell.hwi_dateLabel.hidden =  true
            }
            else
            {
                cell.hwi_dateLabel.hidden =  false
            }
        }
        else
        {
            cell.hwi_dateLabel.hidden =  true
        }
        
        
        
        
        return cell
    }
    
}
