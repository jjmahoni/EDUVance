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
    static var noticeList : [NoticeListItem] = []
    
    static func getNoticeList(callback : (isSuccess : Bool, result : String)->() )
    {
        NetworkManager.getNoticeList(UserManager.currentUser!.userType!, userId: UserManager.currentUser!.userId!, accessToken: UserManager.currentUser!.accessToken!, pageNo: "", pageLimit: "") { (isSuccess, result, jsonData) -> () in
            
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
                        println("공지사항 리스트 파싱 중 결과 코드 : \(resultCode)")
                        
                        if let data = json.objectForKey("data") as? NSDictionary
                        {
                            self.totalPage =  (data.objectForKey("totalPage") as! String).toInt()!
                            self.lastIdx =  (data.objectForKey("lastIdx") as! String).toInt()!
                            
                            if let noticeListDicArr = data.objectForKey("noticeList") as? [NSDictionary]
                            {
                                self.noticeList.removeAll(keepCapacity: false)
                                for (index , oneData ) in enumerate(noticeListDicArr)
                                {
                                    let oneListItem = NoticeListItem()
                                    
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
                                    }
                                    self.noticeList.append(oneListItem)
                                    
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
    }
    
}

class NoticeListItem
{
    var wrTitle : String?
    var importance : String?
    var startDate : String?
    var endDate : String?
    var wrContent : String?
    var wrDate : String?
    var idx : String?
}



/*
"wrTitle": "공지사항 테스트1",
"importance": "1",
"startDate": "2015.06.08",
"endDate": "2015.06.10",
"wrContent": "공지사항 테스트1공지사항 테스트1공지사항 테스트1공지사항 테스트1222015학년도 하계 방학특강 안내구분영어회화사케소몰리에컨벤션기획사커피특강글로벌 바리스타 챔피언십대회 출전 특강학",
"wrDate": "2015.06.18 17:02:12",
"idx": "3"
*/