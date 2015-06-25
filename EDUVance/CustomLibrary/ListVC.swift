//
//  ListVC.swift
//  EDUVance
//
//  Created by jhkim on 2015. 6. 26..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import UIKit

class ListVC: BaseVC , UITableViewDelegate , UITableViewDataSource{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.backBtnTemp.hidden = false
    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        HWILib.showActivityIndicator(self)
        NetworkManager.getNoticeList(UserManager.currentUser!.userType!, userId: UserManager.currentUser!.userId!, accessToken: UserManager.currentUser!.accessToken!, pageNo: "", pageLimit: "") { (isSuccess, result, jsonData) -> () in
            
            HWILib.hideActivityIndicator()
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
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell") as! UITableViewCell
        
        return cell
    }

}
