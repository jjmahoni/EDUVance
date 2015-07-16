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
    static let URL01_01_SEND_DEVICE_TOKEN : String = "/app/user/save_user_info.php"
    static let URL02_GET_MAIN_MENU : String  = "/app/community/information.php"
    static let URL03_GET_NOTICE_LIST : String  = "/app/community/notice_list.php"
    static let URL04_GET_DETAIL_NOTICE : String  = "/app/community/notice_detail.php"
    static let URL07_GET_MESSAGE_LIST : String  = "/app/community/message_list.php"
    static let URL07_01_DELETE_MESSAGE : String  = "/app/community/delete_message.php"
    static let URL08_GET_DETAIL_MESSAGE : String  = "/app/community/message_detail.php"
    static let URL09_GET_SCHEDULE : String  = "/app/community/schedule.php"
    static let URL10_GET_TIME_TABLE : String  = "/app/lecture/class_schedule.php"
    static let URL11_GET_SCHOOL_INFO_LIST : String  = "/app/community/school_info_list.php"
    static let URL12_GET_DETAIL_SCHOOL_INFO : String  = "/app/community/school_info_detail.php"
    static let URL13_GET_LIFE_INFO_LIST : String  = "/app/community/life_info_list.php"
    static let URL14_GET_DETAIL_LIFE_INFO : String  = "/app/community/life_info_detail.php"
    static let URL15_GET_JOB_INFO_LIST : String  = "/app/community/job_info_list.php"
    static let URL16_GET_DETAIL_JOB_INFO : String  = "/app/community/job_info_detail.php"

    
    
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
    
    
    
    
    // 푸시노티피케이션 토큰 서버로 보냄
    class func sendAPNSKey(callback : ( isSuccess : Bool, result : String, jsonData : NSData?)->())
    {
        
        if !HWILib.isConnectedToNetwork()
        {
            callback(isSuccess: false, result: "인터넷연결안됨", jsonData: nil)
            return
        }
        
        var request = HTTPTask()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let params : Dictionary<String, AnyObject> = [
            "userType" : UserManager.currentUser!.userType! ,
            "userId" : UserManager.currentUser!.userId! ,
            "accessToken" : UserManager.currentUser!.accessToken! ,
            "osType" : "I" ,
            "pushKey" : appDelegate.deviceTokenIdString
        ]
        
        request.POST(SERVER_HOST + URL01_01_SEND_DEVICE_TOKEN, parameters: params) { (response : HTTPResponse) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if let err = response.error
                {
                    callback(isSuccess: false, result: "네트워크 에러입니다.", jsonData: nil)
                    return
                }
                
                if let data = response.responseObject as? NSData
                {
                    let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("pushKey 등록 후 응답 String : \(str)")
                    
                    callback(isSuccess: true, result: "성공적으로 push key 등록", jsonData: data)
                    
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
                    println("리스트 관련 네트워크 조회 디버그 스트링 : \(str)")
                    
                    callback(isSuccess: true, result: "성공적으로 리스트 가져옴", jsonData: data)
                    
                }
                
            })
        }
    }
    
    
    
    /// 일반적인 상세 웹뷰 조회 시 모두 함께 사용
    class func getCommonDetailWeb( detailViewType : Int , inputIdx : String , callback : ( isSuccess : Bool, result : String, jsonData : NSData?)->())
    {
        
        
        var urlForWebView = ""
        
        switch detailViewType
        {
        case 0:
            println("공지사항 입니다.")
            urlForWebView = NetworkManager.URL04_GET_DETAIL_NOTICE
            
        case 1:
            println("쪽지 입니다.")
            urlForWebView = NetworkManager.URL08_GET_DETAIL_MESSAGE
            
        case 3:
            println("학교정보 입니다.")
            urlForWebView = NetworkManager.URL12_GET_DETAIL_SCHOOL_INFO
        case 4:
            println("생활정보 입니다.")
            urlForWebView = NetworkManager.URL14_GET_DETAIL_LIFE_INFO
        case 5:
            println("취업정보 입니다.")
            urlForWebView = NetworkManager.URL16_GET_DETAIL_JOB_INFO
        default:
            break
        }
        
        
        if !HWILib.isConnectedToNetwork()
        {
            callback(isSuccess: false, result: "인터넷연결안됨", jsonData: nil)
            return
        }
        
        var request = HTTPTask()
        
        let params : Dictionary<String, AnyObject> = [
            "userType" : UserManager.currentUser!.userType! ,
            "userId" : UserManager.currentUser!.userId! ,
            "accessToken" : UserManager.currentUser!.accessToken!,
            "idx" : inputIdx
        ]

        
        request.POST( SERVER_HOST+urlForWebView , parameters: params) { (response : HTTPResponse) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if let err = response.error
                {
                    callback(isSuccess: false, result: "네트워크 에러입니다.", jsonData: nil)
                    return
                }
                
                if let data = response.responseObject as? NSData
                {
                    let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("상세 웹뷰 조회 디버그 스트링 : \(str)")
                    
                    callback(isSuccess: true, result: "성공적으로 상세웹뷰 내용 가져옴", jsonData: data)
                    
                }
                
            })
        }
    }
    
    
    
    
    
    
    
    
    
    class func getTimeTable(callback :( isSuccess : Bool, result : String, jsonData : NSData?)->())
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
        
        
        request.POST( SERVER_HOST + URL10_GET_TIME_TABLE , parameters: params) { (response : HTTPResponse) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if let err = response.error
                {
                    callback(isSuccess: false, result: "네트워크 에러입니다.", jsonData: nil)
                    return
                }
                
                if let data = response.responseObject as? NSData
                {
                    let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("시간표 조회 디버그 스트링 : \(str)")
                    
                    callback(isSuccess: true, result: "성공적으로 시간표 데이터 가져옴", jsonData: data)
                    
                }
            })
        }
    }
    
    
    class func deleteOneMessage(index : String, callback :( isSuccess : Bool, result : String, jsonData : NSData?)->())
    {
        
            if !HWILib.isConnectedToNetwork()
            {
                callback(isSuccess: false, result: "인터넷연결안됨", jsonData: nil)
                return
            }
            
            var request = HTTPTask()
            
            let params : Dictionary<String, AnyObject> = [
                "userId" : UserManager.currentUser!.userId! ,
                "accessToken" : UserManager.currentUser!.accessToken!,
                "idxList" : index
                
            ]
            
            
            request.POST( SERVER_HOST + URL07_01_DELETE_MESSAGE , parameters: params) { (response : HTTPResponse) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    if let err = response.error
                    {
                        callback(isSuccess: false, result: "네트워크 에러입니다.", jsonData: nil)
                        return
                    }
                    
                    if let data = response.responseObject as? NSData
                    {
                        let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("쪽지 삭제 디버그 스트링 : \(str)")
                        
                        callback(isSuccess: true, result: "성공적으로 쪽지 삭제 네트워크", jsonData: data)
                        
                    }
                })
            }
        
        
        
    }
    
    
    
    
}