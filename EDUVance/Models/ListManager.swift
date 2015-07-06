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
    static var commonDetailObject = CommonListItem()
    
    // 저장소 관련 변수 및 함수
    //_____________________________________________________________________________
    
    
    
    static var arrayOfStoreInfo : [ModelForStoreData] = []
    
    
    
    class func getStoredListData()
    {
        if let array = NSKeyedUnarchiver.unarchiveObjectWithFile(HWILib.getDocumentsDirectory().stringByAppendingPathComponent(UserManager.currentUser!.userId!)) as? [ModelForStoreData]
        {
            self.arrayOfStoreInfo = array
            
            for (index, oneItem) in enumerate(self.arrayOfStoreInfo)
            {
                arrayOfStoreInfo[index] = oneItem
                println("파일에서 데이터 가져옴 : oneItem.lastIndexOfGetData : \(oneItem.lastIndexOfGetData)  oneItem.listOfReadIdx : \(oneItem.listOfReadIdx)")
            }
        }
    }
    
    class func saveDataToFile()
    {
        var filePath = HWILib.getDocumentsDirectory().stringByAppendingPathComponent(UserManager.currentUser!.userId!)
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
                        println("리스트 아이템 파싱 중 결과 코드 : \(resultCode)")
                        
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
                                        
                                        // idx 의 최대값 찾기
                                        if idx.toInt() > maxIdx
                                        {
                                            maxIdx = idx.toInt()!
                                        }
                                    }
                                    self.commonList.append(oneListItem)
                                    
                                }
                                
                                // 저장된 데이터가 한개도 없으면 빈 데이터를 생성해 낸다
                                if self.arrayOfStoreInfo.count == 0
                                {
                                    for index in 0...5
                                    {
                                        self.arrayOfStoreInfo.append(ModelForStoreData())
                                    }
                                }
                                
                                /// 마지막으로 웹에서 가져온 idx 저장
                                if keyForValue == "noticeList"
                                {
                                    self.arrayOfStoreInfo[0].lastIndexOfGetData = "\(maxIdx)"
                                }
                                
                                if keyForValue == "schoolInfoList"
                                {
                                    self.arrayOfStoreInfo[3].lastIndexOfGetData = "\(maxIdx)"
                                }
                                
                                if keyForValue == "lifeInfoList"
                                {
                                    self.arrayOfStoreInfo[4].lastIndexOfGetData = "\(maxIdx)"
                                }
                                
                                if keyForValue == "jobInfoList"
                                {
                                    self.arrayOfStoreInfo[5].lastIndexOfGetData = "\(maxIdx)"
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
    
    class func applyReadData(currentIndex : Int)
    {
        ListManager.getStoredListData()
        let oneStoredData = ListManager.arrayOfStoreInfo[currentIndex]
        
        
        for oneIdx in oneStoredData.listOfReadIdx
        {
            for oneListItem in ListManager.commonList
            {
                println("읽은 목록 적용 중 디버깅 02 :  oneListItem : \(oneListItem)")
                if oneListItem.idx == oneIdx
                {
                    oneListItem.isRead = true
                    break
                }
                
            }
            
        }
        
        
    }
    
    class func getDetailArticle( detailViewType : Int , inputIdx : String , callback : (isSuccess : Bool , result : String)  -> ())
    {
        var keyForValue = ""
        
        switch detailViewType
        {
        case 0:
            keyForValue = "noticeInfo"
            
        case 3:
            keyForValue = "schoolInfo"
            
        case 4:
            keyForValue = "lifeInfo"
            
        case 5:
            keyForValue = "jobInfo"
        default:
            break
        }
        
        
        NetworkManager.getCommonDetailWeb(detailViewType, inputIdx: inputIdx) { (isSuccess, result, jsonData) -> () in
            
            //  JSON 파싱 및 데이터 구조화
            if let json : NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
            {
                let resultString = json.objectForKey("result") as! Bool
                
                if resultString
                {
                    let resultCode = json.objectForKey("resultCode") as! String
                    println("리스트 아이템 파싱 중 결과 코드 : \(resultCode)")
                    
                    if let data = json.objectForKey("data") as? NSDictionary
                    {
                        
                        if let noticeListDicArr = data.objectForKey(keyForValue) as? NSDictionary
                        {
                            if let wrTitle = noticeListDicArr.objectForKey("wrTitle") as? String
                            {
                                self.commonDetailObject.wrTitle = wrTitle
                            }
                            if let importance = noticeListDicArr.objectForKey("importance") as? String
                            {
                                self.commonDetailObject.importance = importance
                            }
                            if let startDate = noticeListDicArr.objectForKey("startDate") as? String
                            {
                                self.commonDetailObject.startDate = startDate
                            }
                            if let endDate = noticeListDicArr.objectForKey("endDate") as? String
                            {
                                self.commonDetailObject.endDate = endDate
                            }
                            if let wrContent = noticeListDicArr.objectForKey("wrContent") as? String
                            {
                                self.commonDetailObject.wrContent = wrContent
                            }
                            if let wrDate = noticeListDicArr.objectForKey("wrDate") as? String
                            {
                                self.commonDetailObject.wrDate = wrDate
                            }
                            if let idx = noticeListDicArr.objectForKey("idx") as? String
                            {
                                self.commonDetailObject.idx = idx
                                
                            }
                            
                        }
                        
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
    var isRead : Bool?
    
    
}


