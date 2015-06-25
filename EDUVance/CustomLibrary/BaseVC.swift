//
//  BaseVC.swift
//  EDUVance
//
//  Created by jhkim on 2015. 6. 16..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import UIKit

class BaseVC: UIViewController
{
    // 타이틀바 설정 관련
    let topTitleBar : UIView = UIView()
    let topTitleLabel : UILabel = UILabel()
    
    let topToteBarHeight : CGFloat = 68
    let statusBarHeight: CGFloat = 20

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupTopTitleBar()
        
    }
    
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // 얼럿창 띄우기
    func alertWithTitle(title : String , clickString : String , clickHandler : (()->Void)? )
    {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.Alert)

        // 클릭 텍스트 맟 액션 삽입
        alert.addAction(UIAlertAction(title: clickString, style: .Default, handler: { (action : UIAlertAction!) -> Void in
            
            // 확인 버튼 클릭 시 행동 -> 핸들러 작동
            if clickHandler != nil
            {
                clickHandler!()
            }
            
            // 얼럿 뷰 없애기
            alert.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
            

            
        }))
        
        // 현재 얼럿창을 화면에 띄움
        self.presentViewController(alert, animated: true, completion: { () -> Void in
            
        })
    }
    
    func alertWithNoInternetConnection()
    {
        self.alertWithTitle("인터넷이 연결되지 않았습니다.", clickString: "확인" , clickHandler: nil)
    }
    
    
    
    
    // 타이틀바 라벨 변경
    func setTopTitlelabelString( title : String )
    {
        self.topTitleLabel.text = title

    }
    
    
    // 타이틀바 초기화 설정
    func setupTopTitleBar()
    {
        
        self.topTitleBar.frame = CGRectMake(0, 0, self.view.frame.size.width, topToteBarHeight)
        self.topTitleBar.backgroundColor = UIColor(red: 90.0/255.0, green: 122.0/255.0, blue: 172.0/255.0, alpha: 1.0)
        self.topTitleLabel.frame = CGRectMake(0, statusBarHeight, self.topTitleBar.frame.size.width, topToteBarHeight-statusBarHeight)
        
        self.topTitleLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.topTitleLabel.font = UIFont.boldSystemFontOfSize(18.0)
        
        
        self.topTitleBar.addSubview(self.topTitleLabel)
        self.view.addSubview(self.topTitleBar)
        self.topTitleLabel.textAlignment = NSTextAlignment.Center

    }
    
    

    
        
    
    
}
