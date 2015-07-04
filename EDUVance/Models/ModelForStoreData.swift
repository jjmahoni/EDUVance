//
//  ModelForStoreData.swift
//  EDUVance
//
//  Created by KimJeonghwi on 2015. 7. 4..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import Foundation

class ModelForStoreData : NSObject, NSCoding
{
    
    var lastIndexOfGetData : String = ""
    var listOfReadIdx : [String] = []
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(self.lastIndexOfGetData, forKey: "lastIndexOfGetData")
        aCoder.encodeObject(self.listOfReadIdx, forKey: "listOfReadIdx")
    }
    
    required convenience init(coder aDecoder: NSCoder)
    {
        self.init()
        self.lastIndexOfGetData = aDecoder.decodeObjectForKey("lastIndexOfGetData") as! String
        self.listOfReadIdx = aDecoder.decodeObjectForKey("listOfReadIdx")as! [String]
    }
    
    init(lastIndexOfGetData : String , listOfReadIdx : [String])
    {
        self.lastIndexOfGetData = lastIndexOfGetData
        self.listOfReadIdx = listOfReadIdx
    }
    
    
    override init()
    {
        super.init()
    }

}