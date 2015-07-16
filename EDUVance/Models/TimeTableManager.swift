//
//  TimeTableManager.swift
//  EDUVance
//
//  Created by KimJeonghwi on 2015. 7. 16..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import Foundation

class TimeTableManager
{
    
    static var year = ""
    static var semester = ""
    static var timetableForm : [String]  = []
    static var myTimetable : [SubjectObj] = []
    static let sharp = "#"
    class SubjectObj
    {
        var startPointX = ""   // 시간
        var startPointY = ""   // 요일
        var endPointX = ""     // 시간
        var endPointY = ""    //  요일
        var name = ""
        var place = ""
        var bgColor = ""
        var lineColor = ""
        var lectureIdx = ""
        
    }
    
    
    class func getTimeTable(callback : (isSuccess : Bool, result : String)->() )
    {
        NetworkManager.getTimeTable { (isSuccess, result, jsonData) -> () in
            
            if isSuccess
            {
                if let json : NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
                {
                    if let resultCode = json.objectForKey("resultCode") as? String
                    {
                        if resultCode == "999"
                        {
                            callback(isSuccess: false, result: "액세스 토큰이 만료됨")
                            return
                        }
                        let timeTableObj = json.objectForKey("data") as! NSDictionary

                        self.year = timeTableObj.objectForKey("year") as! String
                        self.semester = timeTableObj.objectForKey("semester") as! String
                        self.timetableForm = timeTableObj.objectForKey("timetableForm") as! [String]

                        let tempArray = timeTableObj.objectForKey("myTimetable") as! [NSDictionary]
                        self.myTimetable.removeAll(keepCapacity: false)
                        for oneItem in tempArray
                        {
                            let oneSubject = SubjectObj()
                            oneSubject.startPointX = oneItem.objectForKey("startPointX") as! String
                            oneSubject.startPointY = oneItem.objectForKey("startPointY") as! String
                            oneSubject.endPointX = oneItem.objectForKey("endPointX") as! String
                            oneSubject.endPointY = oneItem.objectForKey("endPointY") as! String
                            
                            let classInfo = oneItem.objectForKey("classInfo") as! NSDictionary
                            
                            oneSubject.name = classInfo.objectForKey("name") as! String
                            oneSubject.place = classInfo.objectForKey("place") as! String
                            oneSubject.bgColor = self.sharp + (classInfo.objectForKey("bgColor") as! String)

                            oneSubject.lineColor = self.sharp + (classInfo.objectForKey("lineColor") as! String)
                            oneSubject.lectureIdx = (classInfo.objectForKey("lectureIdx") as! String)
                            self.myTimetable.append(oneSubject)
                        }
                        
                        callback(isSuccess: true, result: "성공적으로 JSON 파싱 완료")
                        return
                    }
                    
                }
                else
                {
                    callback(isSuccess: false, result: "JSON 파싱 실패")
                    return
                }
            }
            else
            {
                println("시간표 조회 중 에러 : result : \(result)")
                callback(isSuccess: false, result: result)
                return
            }
            

        }
    }

}