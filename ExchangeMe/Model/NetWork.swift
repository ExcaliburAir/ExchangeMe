//
//  NetWork.swift
//  ExchangeMe
//
//  Created by 张桀硕 on 2020/9/1.
//  Copyright © 2020年 jieshuo.zhang. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

// 内部参数
class Network: NSObject {
    
    static let baseURL = "http://api.currencylayer.com/"
    static let accessKey = "cfd62ee3c3989b342113b08448580f04"
    
    let timeOutInt: Int = 60
    let getUsdURL = "http://api.currencylayer.com/live?access_key=cfd62ee3c3989b342113b08448580f04"
}

extension Network {
    // 取token请求
    func post_getAllRate_request(
        controller: UIViewController,
        block: ((_ dic: Dictionary<String, Double>) -> Void)?)
    {
        // 进度条开始
        Utils().startActivityIndicator()
        
        // 请求地址
        let urlString: String = getUsdURL
        
        // 设置请求
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.timeoutInterval = TimeInterval(timeOutInt)
        request.setValue("application/json; charset=utf8", forHTTPHeaderField: "Content-Type")

        // 发送请求
        Alamofire.request(request)
            .validate()
            .responseJSON { (response: DataResponse<Any>) in
                // 进度条结束
                Utils().stopActivityIndicator()
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value {
                        print(data)
                        
                        let dic = data as! Dictionary<String, Any>
                        let quotes = dic["quotes"] as! Dictionary<String, Double>
                        
                        // 处理返回结果
                        if (block != nil) {
                            _ = block!(quotes)
                        }
                    }
                    else {
                        Utils().okButtonAlertView(title: "Please Try Again!",
                                                  controller: controller,
                                                  block: nil)
                    }
                    break
                case .failure(_):
                    print(response.result.error ?? (Any).self)
                    Utils().okButtonAlertView(title: "Please Try Again!",
                                              controller: controller,
                                              block: nil)
                    
                    break
                }
        }//
    }
}
