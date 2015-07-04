//
//  ListManager.swift
//  EDUVance
//
//  Created by jhkim on 2015. 6. 26..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import Foundation

class ListManager
{
    static var totalPage = 0
    static var lastIdx = 0
    static var commonList : [CommonListItem] = []
    
    
    // 저장소 관련 변수 및 함수
    //_____________________________________________________________________________
    

    static var storeInfo01_notice = ModelForStoreData()
    static var storeInfo02_message = ModelForStoreData()
    static var storeInfo03_schedule = ModelForStoreData()
    static var storeInfo04_schoolInfo = ModelForStoreData()
    static var storeInfo05_lifeInfo = ModelForStoreData()
    static var storeInfo06_jobInfo = ModelForStoreData()

    
    static var arrayOfStoreInfo : [ModelForStoreData] = []
    
    static var currentStoreItem = ModelForStoreData()
    
    class func getStoredListData()
    {
        if let array = NSKeyedUnarchiver.unarchiveObjectWithFile(HWILib.getDocumentsDirectory().stringByAppendingPathComponent("readList")) as? [ModelForStoreData]
        {
            self.arrayOfStoreInfo = array
            
            for (index, oneItem) in enumerate(self.arrayOfStoreInfo)
            {
                arrayOfStoreInfo[index] = oneItem
            }
        }
    }
    
    class func saveDataToFile()
    {
        self.arrayOfStoreInfo = [ storeInfo01_notice, storeInfo02_message , storeInfo03_schedule , storeInfo04_schoolInfo, storeInfo05_lifeInfo, storeInfo06_jobInfo]
        
        var filePath = HWILib.getDocumentsDirectory().stringByAppendingPathComponent("readList")
        NSKeyedArchiver.archiveRootObject(self.arrayOfStoreInfo, toFile: filePath)
        
    }
    
    
    //_____________________________________________________________________________
    
    
    
    class func getNoticeList(callback : (isSuccess : Bool, result : String)->() )
    {
        getcomminInfoList(NetworkManager.SERVER_HOST+NetworkManager.URL03_GET_NOTICE_LIST, keyForValue: "noticeList", callback: callback)
    }
    
    
    class func getSchoolInfoList(callback : (isSuccess : Bool, result : String)->() )
    {
        getcomminInfoList(NetworkManager.SERVER_HOST+NetworkManager.URL11_GET_SCHOOL_INFO_LIST, keyForValue: "schoolInfoList", callback: callback)
    }
    
    class func getLifeInfoList(callback : (isSuccess : Bool, result : String)->() )
    {
        getcomminInfoList(NetworkManager.SERVER_HOST+NetworkManager.URL13_GET_LIFE_INFO_LIST, keyForValue: "lifeInfoList", callback: callback)
    }
    
    class func getJobInfoList(callback : (isSuccess : Bool, result : String)->() )
    {
        getcomminInfoList(NetworkManager.SERVER_HOST+NetworkManager.URL15_GET_JOB_INFO_LIST, keyForValue: "jobInfoList", callback: callback)
    }
    
    
    
    
    
    class func getcomminInfoList(urlString : String , keyForValue : String,  callback : (isSuccess : Bool, result : String)->() )
    {
        
        NetworkManager.getCommonListInfo(urlString, callback: { (isSuccess, result, jsonData) -> () in
            if !isSuccess
            {
                callback(isSuccess: isSuccess, result: result)
            }
            else
            {
                if let json : NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
                {
                    let resultString = json.objectForKey("result") as! Bool
                    
                    if resultString
                    {
                        let resultCode = json.objectForKey("resultCode") as! String
                        println("학교정보 리스트 파싱 중 결과 코드 : \(resultCode)")
                        
                        if let data = json.objectForKey("data") as? NSDictionary
                        {
                            self.totalPage =  (data.objectForKey("totalPage") as! String).toInt()!
                            self.lastIdx =  (data.objectForKey("lastIdx") as! String).toInt()!
                            
                            if let noticeListDicArr = data.objectForKey(keyForValue) as? [NSDictionary]
                            {
                                self.commonList.removeAll(keepCapacity: false)
                                var maxIdx = -1
                                for (index , oneData ) in enumerate(noticeListDicArr)
                                {
                                    let oneListItem = CommonListItem()
                                    
                                    if let wrTitle = oneData.objectForKey("wrTitle") as? String
                                    {
                                        oneListItem.wrTitle = wrTitle
                                    }
                                    if let importance = oneData.objectForKey("importance") as? String
                                    {
                                        oneListItem.importance = importance
                                    }
                                    if let startDate = oneData.objectForKey("startDate") as? String
                                    {
                                        oneListItem.startDate = startDate
                                    }
                                    if let endDate = oneData.objectForKey("endDate") as? String
                                    {
                                        oneListItem.endDate = endDate
                                    }
                                    if let wrContent = oneData.objectForKey("wrContent") as? String
                                    {
                                        oneListItem.wrContent = wrContent
                                    }
                                    if let wrDate = oneData.objectForKey("wrDate") as? String
                                    {
                                        oneListItem.wrDate = wrDate
                                    }
                                    if let idx = oneData.objectForKey("idx") as? String
                                    {
                                        oneListItem.idx = idx
                                        if idx.toInt() > maxIdx
                                        {
                                            maxIdx = idx.toInt()!
                                        }
                                    }
                                    self.commonList.append(oneListItem)
                                    
                                }
                                
                                
                                //// 현재 보고있는 리스트의 저장정보 객체 생성 및 마지막 인덱스 저장 --> 해당 상세 내용을 볼 경우 해당 리스트도 저장할 예정
                                self.currentStoreItem.lastIndexOfGetData = "\(maxIdx)"
                                
                                
                                if keyForValue == "noticeList"
                                {
                                    self.storeInfo01_notice = self.currentStoreItem
                                }
                                
                                if keyForValue == "schoolInfoList"
                                {
                                    self.storeInfo04_schoolInfo = self.currentStoreItem
                                }
                                
                                if keyForValue == "lifeInfoList"
                                {
                                    self.storeInfo05_lifeInfo = self.currentStoreItem
                                }
                                
                                if keyForValue == "jobInfoList"
                                {
                                    self.storeInfo06_jobInfo = self.currentStoreItem
                                }
                                
                                // 파일로 현재 내역 저장
                                self.saveDataToFile()
                                
                                
                                callback(isSuccess: true, result: "성공적으로 JSON 파싱 완료")
                            }
                            else
                            {
                                callback(isSuccess: false, result: "리스트가없음")
                            }
                            
                            
                            
                        }
                    }
                    else
                    {
                        callback(isSuccess: false, result: "JSON 서버에서 false 보냄")
                    }
                    
                }
            }
        })
        
    }
    
}

class CommonListItem
{
    var wrTitle : String?
    var importance : String?
    var startDate : String?
    var endDate : String?
    var wrContent : String?
    var wrDate : String?
    var idx : String?
}


