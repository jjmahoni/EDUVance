//
//  BaseItemView.swift
//  EDUVance
//
//  Created by jhkim on 2015. 6. 26..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import UIKit

class BaseItemView: UIView
{
    var viewController : BaseVC?
    func onViewShow()
    {
    
    }
    
    func onViewLoad()
    {
    
    }
    
    func moveToLogin()
    {
        self.viewController!.alertWithTitle("액세스토큰이 만료되었습니다. 다시 로그인 해 주세요", clickString: "로그인으로 이동", clickHandler: { () -> Void in
            if let mainVC = self.viewController! as? MainVC
            {
                mainVC.performSegueWithIdentifier("main_login_seg", sender: mainVC)
            }
        })
    }

}
