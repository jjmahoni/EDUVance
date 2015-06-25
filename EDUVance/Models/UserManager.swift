//
//  UserManager.swift
//  EDUVance
//
//  Created by jhkim on 2015. 6. 17..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import Foundation

class UserManager
{
    
    static let sharedInstance = UserManager()
    static var currentUser : CurrentUser?
    static let store = NSUserDefaults.standardUserDefaults()
    
    static var isAutoLogin : Bool
    {
        get
        {
            if let isAutoLoginTemp = store.objectForKey("isAutoLogin") as? Bool
            {
                println("자동로그인 설정됨 확인")
                return isAutoLoginTemp
            }
            return false
        }
        
        set(newValue)
        {
            store.setObject(newValue, forKey: "isAutoLogin")
            store.synchronize()
        }
    }
    
    class CurrentUser
    {
        var userId : String?
        var accessToken : String?
        var userType : String?   // S : 학생    P : 강사
    }
    
    
    
    func login(inputId : String, inputPw : String,isAutoLogin : Bool, callback : (isSuccess : Bool, message:String)->())
    {   
        
        NetworkManager.login(inputId, inputPw: inputPw, isAutoLogin: isAutoLogin) { (isSuccess, result, jsonData) -> () in
            
            if result == "인터넷연결안됨"
            {
                callback(isSuccess: false, message: result)
                return
            }
            
            
            if let json : NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
            {
                
                // 로그인 실패 시 리턴 처리 코드
                if let resultCode = json.objectForKey("resultCode") as? String
                {
                    if resultCode == "111"
                    {
                        callback(isSuccess: false, message: "해당 아이디가 존재하지 않습니다.")
                        return
                    }
                    else if resultCode == "112"
                    {
                        callback(isSuccess: false, message: "아이디와 패스워드가 일치하지 않습니다.")
                        return
                    }
                    else if resultCode == "113"
                    {
                        callback(isSuccess: false, message: "단말기는 중복사용할 수 없습니다.")
                        return
                    }
                }
                
                // 성공적으로 로그인 할 경우
                if let loginData = json.objectForKey("data") as? NSDictionary
                {
                    println("로그인테이터 출력 테스트 : \(loginData)")
                    println("로그인테이터 타입 출력 테스트 : \(loginData.dynamicType)")
                    
                    if let userInfo = loginData.objectForKey("userInfo") as? NSDictionary
                    {
                        
                        UserManager.currentUser = UserManager.CurrentUser()
                        UserManager.currentUser?.accessToken = userInfo.objectForKey("accessToken") as? String
                        UserManager.currentUser?.userId = userInfo.objectForKey("userId")as? String
                        UserManager.currentUser?.userType = userInfo.objectForKey("userType") as? String
                        
                        if (isAutoLogin == true)
                        {
                            UserManager.sharedInstance.setUserInfoToStore()
                        }
                        else
                        {
                            UserManager.sharedInstance.clearUserInfoInStore()
                        }
                        
                        callback(isSuccess: true, message: "단말기는 중복사용할 수 없습니다.")
                        return
                    }
                    
                    callback(isSuccess: false, message: "알 수 없는 에러입니다")
                    return
                }
                

                callback(isSuccess: false, message: "JSON 데이터에 result 가 존재하지 않습니다.")
                return
                
            }
            else
            {
                callback(isSuccess: false, message: "잘못된 JSON 데이터입니다.")
                return
            }
        
        }

        
    }
    
    
    func setUserInfoToStore()
    {
        UserManager.store.setObject(true, forKey: "isAutoLogin")
        UserManager.store.setObject(UserManager.currentUser?.accessToken, forKey: "accessToken")
        UserManager.store.setObject(UserManager.currentUser?.userId, forKey: "userId")
        UserManager.store.setObject(UserManager.currentUser?.userType, forKey: "userType")
        
        let isStoreOK = UserManager.store.synchronize()
        
        if isStoreOK
        {
            println("성공적으로 로그인 데이터 저장")
        }
        else
        {
            println("로그인 데이터 내부 저장소에 저장 실패")
        }
    }
    
    func clearUserInfoInStore()
    {
        UserManager.store.setObject(false, forKey: "isAutoLogin")
        UserManager.store.setObject(nil, forKey: "accessToken")
        UserManager.store.setObject(nil, forKey: "userId")
        UserManager.store.setObject(nil, forKey: "userType")
        
        
        let isClearOK = UserManager.store.synchronize()
        
        if isClearOK
        {
            println("성공적으로 로그인 데이터 비움")
        }
        else
        {
            println("로그인 데이터 비움 실패")
        }
    }
    
    class func getUserInfoFromStore()  -> (Bool)
    {
        if UserManager.currentUser == nil
        {
            UserManager.currentUser = CurrentUser()
        }
        
        if let userId = UserManager.store.objectForKey("userId") as? String
        {   
            UserManager.currentUser?.userId = userId
        }
        else
        {
            println("저장소에 userId 없어서 아이디 가져오기 실패")
            UserManager.currentUser = nil
            return false
        }
        
        if let accessToken = UserManager.store.objectForKey("accessToken") as? String
        {
            UserManager.currentUser?.accessToken = accessToken
        }
        else
        {
            println("저장소에 accessToken 없어서 아이디 가져오기 실패")
            UserManager.currentUser = nil
            return false
        }
        
        if let userType = UserManager.store.objectForKey("userType") as? String
        {
            UserManager.currentUser?.userType = userType
        }
        else
        {
            println("저장소에 userType 없어서 아이디 가져오기 실패")
            UserManager.currentUser = nil            
            return false
        }
        
        return true
    }
}