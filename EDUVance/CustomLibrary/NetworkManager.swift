//
//  NetworkManager.swift
//  EDUVance
//
//  Created by jhkim on 2015. 6. 25..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import UIKit

class NetworkManager
{
    static let SERVER_HOST : String = "http://iaudev.eeaa.co.kr"
    
    
    static let URL01_LOGIN : String = "/app/user/login.php"
    /*
    [필수]
    userId            /* 아이디 */
    password       /* 비밀번호 */
    deviceId        /* 단말기 고유정보 */
    */
    
    
    static let URL02_GET_MAIN_MENU : String  = "/app/community/information.php"
    /*
    [필수]
    userType                  /* 사용자 유형(S:학생, P:교강사) */
    userId                      /* 아이디 */
    accessToken            /* login key */
    
    [옵션]
    noticeIdx             /* 공지사항 마지막 고유번호 */
    scheduleIdx         /* 학사일정 마지막 고유번호 */
    schoolInfoIdx       /* 학교 정보 마지막 고유번호 */
    lifeInfoIdx            /* 생활 정보 마지막 고유번호 */
    jobInfoIdx           /* 취업 정보 마지막 고유번호 */
    */
    
    
    static let URL03_GET_NOTICE_LIST : String  = "/app/community/notice_list.php"
    /*
    [필수]
    userType                  /* 사용자 유형(S:학생, P:교강사) */
    userId                      /* 아이디 */
    accessToken            /* login key */
    
    [옵션]
    pageNo            /* 페이지번호(기본값 1) */
    pageLimit         /* 페이지당 갯수(기본값 10) */
    */
    
    static let URL11_GET_SCHOOL_INFO_LIST : String  = "/app/community/school_info_list.php"
    
    static let URL13_GET_LIFE_INFO_LIST : String  = "/app/community/life_info_list.php"
    
    static let URL15_GET_JOB_INFO_LIST : String  = "/app/community/job_info_list.php"

    
    
    // 로그인
    class func login(inputId : String, inputPw : String, isAutoLogin : Bool, callback : ( isSuccess : Bool, result : String, jsonData : NSData?)->())
    {
        
        if !HWILib.isConnectedToNetwork()
        {
            callback(isSuccess: false, result: "인터넷연결안됨", jsonData: nil)
            return
        }
        
        var request = HTTPTask()
        
        let inputDeviceId = UIDevice.currentDevice().identifierForVendor.UUIDString
        println("벤더 아이디 출력 : \(inputDeviceId)")
        
        let params : Dictionary<String, AnyObject> = ["userId":inputId, "password":inputPw, "deviceId":inputDeviceId]
        
        request.POST(SERVER_HOST+URL01_LOGIN, parameters: params) { (response : HTTPResponse) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let err = response.error
                {
                    callback(isSuccess: false, result: "네트워크 에러입니다.", jsonData: nil)
                    return
                }
                
                if let data = response.responseObject as? NSData
                {
                    
                    // JSON 출력 테스트 코드
                    let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("response: \(str)") //prints the HTML of the page
                    
                    callback(isSuccess: true, result: "성공적으로 데이터를 가져왔습니다.", jsonData: data)
                    
                }
                
            })
        }

    }
    
    
    
    // 메뉴 조회
    class func getMainMenuBadgeCount( noticeIdx : String, scheduleIdx : String, schoolInfoIdx : String, lifeInfoIdx : String, jobInfoIdx : String, callback : ( isSuccess : Bool, result : String, jsonData : NSData?)->())
    {
        
        if !HWILib.isConnectedToNetwork()
        {
            callback(isSuccess: false, result: "인터넷연결안됨", jsonData: nil)
            return
        }
        
        var request = HTTPTask()
        
        let params : Dictionary<String, AnyObject> = [
            "userType" : UserManager.currentUser!.userType! ,
            "userId" : UserManager.currentUser!.userId! ,
            "accessToken" : UserManager.currentUser!.accessToken! ,
            "noticeIdx" : noticeIdx ,
            "scheduleIdx" : scheduleIdx ,
            "schoolInfoIdx" : schoolInfoIdx,
            "lifeInfoIdx" : lifeInfoIdx ,
            "jobInfoIdx" : jobInfoIdx
        ]
        
        request.POST(SERVER_HOST + URL02_GET_MAIN_MENU, parameters: params) { (response : HTTPResponse) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if let err = response.error
                {
                    callback(isSuccess: false, result: "네트워크 에러입니다.", jsonData: nil)
                    return
                }
                
                if let data = response.responseObject as? NSData
                {
                    let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("메뉴 조회 응답 스트링 : \(str)")
                    
                    callback(isSuccess: true, result: "성공적으로 메뉴 가져옴", jsonData: data)
                    
                }
                
            })
        }
        
    }
    

    
    class func getNoticeList( pageNo : String, pageLimit : String, callback : ( isSuccess : Bool, result : String, jsonData : NSData?)->())
    {
        if !HWILib.isConnectedToNetwork()
        {
            callback(isSuccess: false, result: "인터넷연결안됨", jsonData: nil)
            return
        }
        
        var request = HTTPTask()
        
        let params : Dictionary<String, AnyObject> = [
            "userType" : UserManager.currentUser!.userType! ,
            "userId" : UserManager.currentUser!.userId! ,
            "accessToken" : UserManager.currentUser!.accessToken! ,
            "pageNo" : pageNo ,
            "pageLimit" : pageLimit
        ]
        
        request.POST( SERVER_HOST + URL03_GET_NOTICE_LIST , parameters: params) { (response : HTTPResponse) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if let err = response.error
                {
                    callback(isSuccess: false, result: "네트워크 에러입니다.", jsonData: nil)
                    return
                }
                
                if let data = response.responseObject as? NSData
                {
                    let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("공지사항 조회 디버그 스트링 : \(str)")
                    
                    callback(isSuccess: true, result: "성공적으로 메뉴 가져옴", jsonData: data)
                    
                }
                
            })
        }
    }

    
    // 학교 정보 가져오기
    class func getSchoolInfoList(  callback : ( isSuccess : Bool, result : String, jsonData : NSData?)->())
    {
        getCommonListInfo(SERVER_HOST + URL11_GET_SCHOOL_INFO_LIST, callback: callback)
    }
    
    
    // 생활정보 가저요기
    class func getLifeInfoList(  callback : ( isSuccess : Bool, result : String, jsonData : NSData?)->())
    {
        getCommonListInfo(SERVER_HOST + URL13_GET_LIFE_INFO_LIST, callback: callback)
    }
    
    
    
    
    /// 일반적인 리스토 네트워크 진행 시 모두 함께 사용
    class func getCommonListInfo( urlForGetList : String , callback : ( isSuccess : Bool, result : String, jsonData : NSData?)->())
    {
        if !HWILib.isConnectedToNetwork()
        {
            callback(isSuccess: false, result: "인터넷연결안됨", jsonData: nil)
            return
        }
        
        var request = HTTPTask()
        
        let params : Dictionary<String, AnyObject> = [
            "userId" : UserManager.currentUser!.userId! ,
            "accessToken" : UserManager.currentUser!.accessToken!
        ]
        
        request.POST( urlForGetList , parameters: params) { (response : HTTPResponse) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if let err = response.error
                {
                    callback(isSuccess: false, result: "네트워크 에러입니다.", jsonData: nil)
                    return
                }
                
                if let data = response.responseObject as? NSData
                {
                    let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("학교정보 조회 디버그 스트링 : \(str)")
                    
                    callback(isSuccess: true, result: "성공적으로 메뉴 가져옴", jsonData: data)
                    
                }
                
            })
        }
        
        
    }
    
}