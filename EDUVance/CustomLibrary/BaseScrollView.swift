//
//  BaseScrollView.swift
//  EDUVance
//
//  Created by jhkim on 2015. 6. 24..
//  Copyright (c) 2015년 eeaa. All rights reserved.
//

import UIKit

class BaseScrollView: UIScrollView
{
    

    
    //백그라운드 터치 시 키보드 자동 내림 처리
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        println("베이스 스크롤뷰에서 터치 진입 테스트")
        
        for firstDepthView in self.subviews
        {
            if firstDepthView.isFirstResponder()
            {
                println("1 뎁스에서 텍스트필드를 찾아서 키보드를 내림")
                firstDepthView.resignFirstResponder()
                return
            }
            
            for secoundDepthView in firstDepthView.subviews
            {
                if secoundDepthView.isFirstResponder()
                {
                    println("2 뎁스에서 텍스트필드를 찾아서 키보드를 내림")
                    secoundDepthView.resignFirstResponder()
                    return
                }
                
                for thirdDepthView in secoundDepthView.subviews
                {
                    if thirdDepthView.isFirstResponder()
                    {
                        println("3 뎁스에서 텍스트필드를 찾아서 키보드를 내림")
                        thirdDepthView.resignFirstResponder()
                        return
                    }
                    
                    for forthDepthView in thirdDepthView.subviews
                    {
                        if forthDepthView.isFirstResponder()
                        {
                            forthDepthView.resignFirstResponder()
                            return
                        }
                        
                    }
                }
            }
        }
        
    }
    
}
