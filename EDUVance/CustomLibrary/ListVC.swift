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
    
    var currentIndexOfType = 0
    var selectedIdx = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.backBtnTemp.hidden = false
        
        println("리스트뷰 로딩 확인")
        
        let index = find( ConstantValues.iconTitleArray , self.topTitleLabel.text! )
        
        self.currentIndexOfType = index!
        
        HWILib.showActivityIndicator(self)
        
        
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        switch self.currentIndexOfType
        {
        case 0:
            // 공지사항 네트워크 시작
            ListManager.getNoticeList { (isSuccess, result) -> () in
                HWILib.hideActivityIndicator()
                
                if isSuccess
                {
                    ListManager.applyReadData(self.currentIndexOfType)
                    self.listTableView.reloadData()
                }
                else
                {
                    self.showLoginScreen(result)
                }
            }
        case 3:
            // 학교정보 네트워크 시작
            ListManager.getSchoolInfoList { (isSuccess, result) -> () in
                HWILib.hideActivityIndicator()
                
                if isSuccess
                {
                    ListManager.applyReadData(self.currentIndexOfType)
                    self.listTableView.reloadData()
                }
                else
                {
                    self.showLoginScreen(result)
                }
            }
        case 4:
            // 학교정보 네트워크 시작
            ListManager.getLifeInfoList { (isSuccess, result) -> () in
                HWILib.hideActivityIndicator()
                
                if isSuccess
                {
                    ListManager.applyReadData(self.currentIndexOfType)
                    self.listTableView.reloadData()
                }
                else
                {
                    self.showLoginScreen(result)
                }
            }
            
        case 5:
            // 취업정보 네트워크 시작
            ListManager.getJobInfoList { (isSuccess, result) -> () in
                HWILib.hideActivityIndicator()
                
                if isSuccess
                {
                    ListManager.applyReadData(self.currentIndexOfType)
                    self.listTableView.reloadData()
                }
                else
                {
                    self.showLoginScreen(result)
                }
            }
            
            
            
        default:
            break
        }
  
        
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
        
        let selectedColorV = UIView()
        selectedColorV.backgroundColor = ConstantValues.color_main03_230_234_242
        cell.selectedBackgroundView = selectedColorV
        
        let oneItem  = ListManager.commonList[indexPath.row]
        
        cell.hwi_titleLabel.text = oneItem.wrTitle
        cell.hwi_contentLabel.text = oneItem.wrContent
        cell.hwi_wrdateLabel.text = oneItem.wrDate
        
        cell.hwi_dateLabel.hidden =  true
        if oneItem.startDate != nil && oneItem.endDate  != nil
        {
            if oneItem.startDate != "" && oneItem.endDate  != ""
            {
                
                cell.hwi_dateLabel.text = "\(oneItem.startDate!) - \(oneItem.endDate!)"
                cell.hwi_dateLabel.hidden = false
            }
        }
        

        
        /// 읽었던 항목일 경우
        if oneItem.isRead == true
        {
            println("읽은 리스트 입니다.")
            cell.hwi_titleLabel.textColor = ConstantValues.color_main02_62_96_152_60per
            cell.hwi_contentLabel.textColor = ConstantValues.color_main08_93_93_93_60per
            cell.hwi_dateLabel.textColor = ConstantValues.color_main08_93_93_93_60per
            cell.hwi_wrdateLabel.textColor = ConstantValues.color_main08_93_93_93_60per
            cell.backgroundColor = ConstantValues.color_selectedList_246_246_246
            if oneItem.importance != nil
            {
                if oneItem.importance! == "0"
                {
                    cell.hwi_titleLabel.textColor = ConstantValues.color_main02_62_96_152_60per
                }
                else if oneItem.importance! == "1"
                {
                    cell.hwi_titleLabel.textColor = ConstantValues.color_main07_232_24_92_60per
                }
            }
        }
        // 읽지 않은 항목일 경우
        else
        {
            println("안 읽은 항목입니다.")
            cell.hwi_titleLabel.textColor = ConstantValues.color_main02_62_96_152
            cell.hwi_contentLabel.textColor = ConstantValues.color_main08_93_93_93
            cell.hwi_dateLabel.textColor = ConstantValues.color_main08_93_93_93
            cell.hwi_wrdateLabel.textColor = ConstantValues.color_main08_93_93_93
            cell.backgroundColor = ConstantValues.color01_white
            if oneItem.importance != nil
            {
                if oneItem.importance! == "0"
                {
                    cell.hwi_titleLabel.textColor = ConstantValues.color_main02_62_96_152
                }
                else if oneItem.importance! == "1"
                {
                    cell.hwi_titleLabel.textColor = ConstantValues.color_main07_232_24_92
                }
            }
        }


        
        return cell
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let oneItem = ListManager.commonList[indexPath.row]
        oneItem.isRead = true
        
        let currentItemObj = ListManager.arrayOfStoreInfo[self.currentIndexOfType]
        
        
        // 현재 터치한 목록을 파일에 저장함
        if find(currentItemObj.listOfReadIdx, oneItem.idx!) == nil
        {
            currentItemObj.listOfReadIdx.append(oneItem.idx!)
            
            // 파일 저장
            ListManager.saveDataToFile()

            // 파일에서 불러와서 적용
            ListManager.applyReadData( self.currentIndexOfType )
            
            self.listTableView.reloadData()
        }
        self.selectedIdx = oneItem.idx!
        self.performSegueWithIdentifier("list_webv_seg", sender: self)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "list_webv_seg"
        {
            let destVC = segue.destinationViewController as! DetailWebViewVC
            destVC.topTtitleText = self.topTitleLabel.text!
            destVC.currentType = self.currentIndexOfType
            destVC.currentIdx = self.selectedIdx
            
        }
    }
    
    func showLoginScreen(result : String)
    {
        self.alertWithTitle(result, clickString: "확인", clickHandler: { () -> Void in
            
            self.performSegueWithIdentifier("seg_listvc_login", sender: self)
            
        })
    }
}
