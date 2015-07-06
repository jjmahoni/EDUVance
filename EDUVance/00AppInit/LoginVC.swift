//
//  LoginVC.swift
//  EDUVance
//
//  Created by jhkim on 2015. 6. 22..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import UIKit

class LoginVC: BaseVC , UITextFieldDelegate{

    @IBOutlet weak var scrv01_loginSC: BaseScrollView!

    @IBOutlet weak var textField01_inputId: InsetTextField!
    @IBOutlet weak var textField02_inputPW: InsetTextField!
    
    var latestContentOffset : CGFloat = 0
    var currentKeyboardHeight : CGFloat = 0
    
    @IBOutlet weak var btn01_autoLogin: UIButton!
    // 뷰 로드 시점
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.topTitleBar.hidden = true

        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onAutoLoginCheckTouchUpInside(sender: UIButton)
    {
        btn01_autoLogin.selected = !btn01_autoLogin.selected
        
    }
    
    // 로그인 버튼 클릭
    @IBAction func onBtnLogin(sender: UIButton)
    {
        println("로그인 버튼 클릭 확인")
        
        let inputId = self.textField01_inputId.text
        let inputPw = self.textField02_inputPW.text
        
        if !HWILib.isValidParam(inputId)
        {
            alertWithTitle("아이디 입력란을 확인해 주세요", clickString: "확인" , clickHandler: nil)
            self.textField01_inputId.becomeFirstResponder()
            return
        }
        
        if !HWILib.isValidParam(inputPw)
        {
            alertWithTitle("패스워드 입력란을 확인해 주세요", clickString: "확인" , clickHandler: nil)
            self.textField02_inputPW.becomeFirstResponder()
            return
        }
        
        HWILib.showActivityIndicator(self)
        
        UserManager.sharedInstance.login(inputId, inputPw: inputPw, isAutoLogin: btn01_autoLogin.selected) { (isSuccess, message) -> () in
            
            HWILib.hideActivityIndicator()
            if isSuccess
            {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                })
            }
            else
            {
                if message == "인터넷연결안됨"
                {
                    self.alertWithNoInternetConnection()
                }
                else
                {
                    self.alertWithTitle(message, clickString: "확인", clickHandler: nil)
                }
                
            }
            
        }
        
        
    }
    
    
    // 뷰 컨트롤러 소멸 시 노티피케이션 센터에서 옵져버 제거
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    // 키보드 나올 때 행동 정의
    func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.currentKeyboardHeight = keyboardSize.height
        }
        
    }
    
    // 키보드 들어갈 때 행동 정의
    func keyboardWillHide(notification: NSNotification)
    {
        self.scrv01_loginSC.contentOffset = CGPointMake(0, self.latestContentOffset)
        self.scrv01_loginSC.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)
    }
    
    
    // 텍스트필드 에디팅 시작 시 자동 뷰 크기 조절
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        HWILib.delay(0.1, closure: { () -> () in
            self.latestContentOffset = self.scrv01_loginSC.contentOffset.y
            self.scrv01_loginSC.contentOffset = CGPointMake(0, textField.frame.origin.y+50)
            self.scrv01_loginSC.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+self.currentKeyboardHeight)
        })

        return true
    }

    
    override func shouldAutorotate() -> Bool {
        return false
    }
}
