//
//  Utils.swift
//  UMS_pay
//
//  Created by 张桀硕 on 2020/09/01.
//  Copyright © 2020年 jieshuo.zhang. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import AVFoundation

// MARK:- static
class Utils: NSObject {
    
    let utils_BackView_Tag = 10086
    
    // 是否是ipad
    static func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // 是否是iphone
    static func isPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    // 区分ipad和iphone的storyboard
    static func getStoryBoard() -> UIStoryboard {
        var storyBoard: UIStoryboard?
        if Utils.isPad() {
            storyBoard  = UIStoryboard(name: "Main_iPad", bundle: nil)
        }
        else {
            storyBoard  = UIStoryboard(name: "Main_iPhone", bundle: nil)
        }
        
        return storyBoard!
    }
    
    // 得到copyright
    static func getCopyright() -> String {
        return "Copyright © 2019 Merchant Support Co., Ltd."
    }
    
    // 获得本App的版本号
    static func getAppVersion() -> String {
        let infoDictionary = Bundle.main.infoDictionary!
        let version = infoDictionary["CFBundleShortVersionString"]
        let versionStr = version as! String
        
        return "Version " + versionStr
    }
    
    // 获得操作系统版本
    static func getIosVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    // 拿到硬件类型
    static func getDevice() -> String {
        return UIDevice.deviceType
    }
    
    // Merchant Support 的电话
    static func getTelephoneNoStr() -> String {
        return "03-6279-0521"
    }
    
    // Merchant Support 的主页
    static func getHomePageStr() -> String {
        return "www.merchant-s.com"
    }
}

// MARK:- get
extension Utils {
    
    // 得到随机布尔值
    func getRandomBool() -> Bool {
        let random = arc4random_uniform(2)
        if random == 0 {
            return true
        } else {
            return false
        }
    }
    
    // 获得长度指定的，随机字符串
    func getNonceString(_ size: Int) -> String {
        // 要大于0，
        guard (size > 0) && (size <= 64) else {
            return ""
        }
        
        // 制作数量内的随机字符串
        let labStr = "QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm1234567890"
        var nonceStr = ""
        for _ in 0..<size {
            let index = Int(arc4random_uniform(UInt32(labStr.count)))
            nonceStr.append(labStr[labStr.index(labStr.startIndex, offsetBy: index)])
        }
        
        return nonceStr
    }
    
    // 得到两个字符串中间的字符串
    func getMiddleString(_ originalStr: String!, from: String!, to: String!) -> String{
        
        let start: Range = originalStr.range(of: from)!
        let end: Range = originalStr.range(of: to)!
        
        return String(originalStr[start.upperBound..<end.lowerBound])
    }
    
    // 去掉最后n个字符
    func cutStringEnd(_ string: String, lenth: Int = 1) -> String {
        // 不能比string长
        if string.count < lenth {
            return string
        }
        
        if string.count == lenth {
            return ""
        }
        
        let endIndex =  string.index(string.endIndex, offsetBy: -lenth)
        let newStr = String(string[string.startIndex..<endIndex])
        
        return newStr
    }
    
    // 去掉最前n个字符
    func cutStringStart(_ string: String, lenth: Int = 1) -> String {
        // 不能比string长
        if string.count < lenth {
            return string
        }
        
        if string.count == lenth {
            return ""
        }
        
        let startIndex = string.index(string.startIndex, offsetBy: lenth)
        let newStr = String(string[startIndex..<string.endIndex])
        
        return newStr
    }
    
    // 字典转JSON
    func getJSONStringFromDictionary(dictionary:[String: Any]) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data: NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    
    // JSONString转换为字典
    func getDictionaryFromJSONString(jsonString:String) -> Dictionary<String, Any>{
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! Dictionary<String, Any>
        }
        
        return Dictionary<String, Any>()
    }
    
    // 得到当前时间
    func getTimeIntervalNowToString() -> String {
        // 获取当前时间
        let now = Date()
        
        // 日期格式器 ISO8601
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let dataStr = dataFormatter.string(from: now)
        print("当前日期时间: " + dataStr)
        
        // 当前时间戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        print("当前时间的时间戳：\(timeStamp)")
        
        // 根据API文档格式，去掉相应位置的“：”号
        let endIndex = dataStr.index(dataStr.endIndex, offsetBy: -3)
        let dataStr1 = String(dataStr[dataStr.startIndex..<endIndex])
        let startIndex = dataStr.index(dataStr.endIndex, offsetBy: -2)
        let dataStr2 = String(dataStr[startIndex..<dataStr.endIndex])
        
        return dataStr1 + dataStr2
    }
    
    // 获得30天前的时间
    func getTimeStringBefore(days: Int = 30) -> String {
        // 获取当前时间
        let now = Date()
        let nextTime: TimeInterval = TimeInterval(-24*60*60*days)
        let lastDate = now.addingTimeInterval(nextTime)
        
        // 日期格式器 ISO8601
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        let dataStr = dataFormatter.string(from: lastDate)
        print(String(days) + "天前时间: " + dataStr)
        
        // 当前时间戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        print(String(days) + "天前时间戳：\(timeStamp)")
        
        // 根据API文档格式，去掉相应位置的“：”号
        let endIndex = dataStr.index(dataStr.endIndex, offsetBy: -3)
        let dataStr1 = String(dataStr[dataStr.startIndex..<endIndex])
        let startIndex = dataStr.index(dataStr.endIndex, offsetBy: -2)
        let dataStr2 = String(dataStr[startIndex..<dataStr.endIndex])
        
        return dataStr1 + dataStr2
    }
    
    // 获得指定日期时间，以端末当前时区时间为主
    func getTimeToString(mm: String, dd: String) -> String {
        // 判断mm，和dd的格式
        
        // 得到当前年，公元
        let nowStr = self.getTimeIntervalNowToString()
        let endIndex = nowStr.index(nowStr.startIndex, offsetBy: 4)
        let yearStr = String(nowStr[nowStr.startIndex..<endIndex])
        
        // 得到当前时区
        let startIndex = nowStr.index(nowStr.endIndex, offsetBy: -4)
        let timeZoneStr = String(nowStr[startIndex..<nowStr.endIndex])
        
        // 组装日期，以当日零点为基准
        let timeStr = yearStr + "-" + mm + "-" + dd + "T00:00:00.001+" + timeZoneStr
        
        return timeStr
    }
    
    // 得到appDelegate的单例对象
    func getAppDelegate() -> AppDelegate {
        // 获取Appdelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate
    }
    
    // 用颜色生成图片
    func getImageWithColor(color: UIColor, width: CGFloat, height: CGFloat) -> UIImage?
    {
        let rect = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // 把系统时间格式换成用户格式
    func getUserTimeString(string: String) -> String {
        // 2019-05-19T15:48:11.980+0900 ->  2019-05-19  15:48:11
        let endIndex = string.index(string.endIndex, offsetBy: -9)
        var time = String(string[string.startIndex..<endIndex])
        time = time.replacingOccurrences(of: "T", with: "  ")
        
        return time
    }
    
    // 将base64转化成图像image
    func getImageFromBase64(_ string: String!) -> UIImage? {
        let base64String = string.replacingOccurrences(of: "data:image/png;base64,", with: "")
        let imageData = Data(base64Encoded: base64String)
        let image = UIImage(data: imageData!) //转换内容
        
        return image
    }
    
    // 把UIView转化为UIImage
    func getImageFromView(view: UIView) -> UIImage {
        // 开始画，UIScreen.main.scale才是高清的关键
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, UIScreen.main.scale)
        
        // 双方法叠用
        view.layer.render(in: UIGraphicsGetCurrentContext()!) // 据说解析度低
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)  // 据说解析度高
        
        // 结束画
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }

    // 返回语言类型String
    func getLanguageType(_ string: String) -> String {
        // 优先级别：日语>汉语>英语，默认日语
        // 中国：zh-CN，日本：ja-JP，美国：en-US
        var type: String = "ja-JP"
        
        // 先看英语
        for (_, value) in string.enumerated() {
            if (value < "\u{4E00}") {
                type = "en-US"
            }
        }
        
        // 再看汉语
        for (_, value) in string.enumerated() {
            if ("\u{4E00}" <= value  && value <= "\u{9FAf}") {
                type = "zh-CN"
            }
        }
        
        // 最后日语
        for (_, value) in string.enumerated() {
            // 有平假名
            if ("\u{3040}" <= value  && value <= "\u{309f}") {
                type = "ja-JP"
            }
            
            // 有片假名
            if ("\u{30a0}" <= value  && value <= "\u{30ff}") {
                type = "ja-JP"
            }
        }
        
        return type
    }
    
    // 替换第n个字符
    func changeCharInString(string: String, char: String, index: Int) -> String {
        if string.count < index || index <= 0 {
            return string
        }
        
        if char.count != 1 {
            return string
        }
        
        let endIndex = string.index(string.startIndex, offsetBy: index - 1)
        let front = String(string[string.startIndex..<endIndex])
        
        let startIndex = string.index(string.startIndex, offsetBy: index)
        let behind = String(string[startIndex..<string.endIndex])
        
        return front + char + behind
    }
    
    // 得到第n个字符
    func getCharFromString(string: String, index: Int) -> String {
        if string.isEmpty {
            return ""
        }
        
        if string.count < index || index <= 0 {
            return ""
        }
        
        let startIndex = string.index(string.startIndex, offsetBy: index - 1)
        let endIndex = string.index(string.startIndex, offsetBy: index)
        let char = String(string[startIndex..<endIndex])
        
        return char
    }
    
    // 设置变化的字体：NSMutableAttributedString
    func getAttributeString(attStr: NSMutableAttributedString,
                            loc_len: (Int, Int),
                            font: UIFont,
                            color: UIColor,
                            backColor: UIColor = UIColor.clear) -> NSMutableAttributedString
    {
        let attributeStr = attStr
        let range = NSRange(location: loc_len.0, length: (loc_len.1))
        
        attributeStr.addAttribute(
            NSAttributedString.Key.font,
            value: font,
            range: range)
        attributeStr.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: color,
            range: range)
        attributeStr.addAttribute(
            NSAttributedString.Key.backgroundColor,
            value: backColor,
            range: range)
        
        return attributeStr
    }
    
    // 通过旧的价格，旧的汇率，新的汇率->で得到新的价格
    func getNewPrice(oldPrice: Double, oldRate: Double, newRate: Double) -> Double {
        // oldPrice / oldRate = newPrice / newRate
        return (newRate / oldRate) * oldPrice
    }
    
    // 保留小数点后2位
    func getDouble(_ oldValue: Double, offset: Int) -> Double {
        let format = "%." + String(offset) + "f"
        let string = String(format: format, oldValue)
        
        return Double(string) ?? 0.0
    }
}

// MARK:- set
extension Utils {
    
    // 只有OK键的提示
    func okButtonAlertView(title: String, controller: UIViewController, block: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if (block != nil) {
                block!()
            }
        })
        alert.addAction(ok)
        controller.present(alert, animated: true, completion: nil)
    }
    
    // 只有OK键，有题头和细节的提示
    func okButtonAlertView(title: String, message: String,
                           controller: UIViewController, block: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if (block != nil) {
                block!()
            }
        })
        alert.addAction(ok)
        controller.present(alert, animated: true, completion: nil)
    }
    
    // 有OK和Cancel的提示
    func okCancelAlertView(title: String, controller: UIViewController, okBlock: (() -> Void)?, cancelBlock: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            if (cancelBlock != nil) {
                cancelBlock!()
            }
        })
        alert.addAction(cancel)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if (okBlock != nil) {
                okBlock!()
            }
        })
        alert.addAction(ok)
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    // 开始等待
    func startActivityIndicator() {
        // 获得窗口
        let root = UIApplication.shared.delegate as! AppDelegate
        let backFrame = (root.window?.frame)!
        
        // 覆盖整个背景
        let backView = UIView(frame: backFrame)
        backView.backgroundColor = UIColor(red: 0 / 255.0,
                                           green: 0 / 255.0,
                                           blue: 0 / 255.0,
                                           alpha: 0.5)
        backView.isUserInteractionEnabled = true
        backView.tag = utils_BackView_Tag
        
        // 中间的小区
        let showWidth: CGFloat = 120
        let showHeight = showWidth
        let showX = (backView.frame.width - showWidth) / 2
        let showY = (backView.frame.height - showHeight) / 2
        //
        let showView = UIView(frame: CGRect(x: showX, y: showY,
                                            width: showWidth,
                                            height: showHeight))
        showView.backgroundColor = UIColor.clear // 可显示
        showView.layer.cornerRadius = 10
        showView.layer.masksToBounds = true
        backView.addSubview(showView)
        
        // 旋转方案一
        let indiWidth: CGFloat = 100 // 大小要统一
        let indiHeight: CGFloat = indiWidth
        let indiX: CGFloat = (showWidth - indiWidth) / 2
        let indiY: CGFloat = (showHeight - indiHeight) / 2
        let indicatorFrame = CGRect(x: indiX,
                                    y: indiY,
                                    width: indiWidth,
                                    height: indiHeight)
        let activityIndicatorView = NVActivityIndicatorView(
            frame: indicatorFrame,
            type: .circleStrokeSpin,
            color: UIColor.white,
            padding: 0)
        showView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        root.window?.addSubview(backView)
    }
    
    // 结束等待
    func stopActivityIndicator() {
        let root = UIApplication.shared.delegate as! AppDelegate
        for subview in (root.window?.subviews)! {
            if subview.tag == utils_BackView_Tag {
                subview.removeFromSuperview()
            }
        }
    }
    
    // 显示某个tag的view
    func showViewWithTag(tag: Int) {
        let root = UIApplication.shared.delegate as! AppDelegate
        for subview in (root.window?.subviews)! {
            if subview.tag == tag {
                subview.isHidden = false
            }
        }
    }
    
    // 隐藏某个tag的view
    func hideViewWithTag(tag: Int) {
        let root = UIApplication.shared.delegate as! AppDelegate
        for subview in (root.window?.subviews)! {
            if subview.tag == tag {
                subview.isHidden = true
            }
        }
    }

    // 设置view的阴影效果
    func setShadow(
        view: UIView,
        width: CGFloat,
        bColor: UIColor,
        sColor: UIColor,
        offset: CGSize,
        opacity: Float,
        radius: CGFloat)
    {
        //设置视图边框宽度
        view.layer.borderWidth = width
        //设置边框颜色
        view.layer.borderColor = bColor.cgColor
        //设置边框圆角
        view.layer.cornerRadius = radius
        //设置阴影颜色
        view.layer.shadowColor = sColor.cgColor
        //设置透明度
        view.layer.shadowOpacity = opacity
        //设置阴影半径
        view.layer.shadowRadius = radius
        //设置阴影偏移量
        view.layer.shadowOffset = offset
    }
    
    // 设置view的阴影效果，多一个宽度设置
    func setShadow(
        view: UIView,
        width: CGFloat,
        bColor: UIColor,
        sColor: UIColor,
        offset: CGSize,
        opacity: Float,
        radius: CGFloat,
        shadowRadius: CGFloat)
    {
        //设置视图边框宽度
        view.layer.borderWidth = width
        //设置边框颜色
        view.layer.borderColor = bColor.cgColor
        //设置边框圆角
        view.layer.cornerRadius = radius
        //设置阴影颜色
        view.layer.shadowColor = sColor.cgColor
        //设置透明度
        view.layer.shadowOpacity = opacity
        //设置阴影半径
        view.layer.shadowRadius = shadowRadius
        //设置阴影偏移量
        view.layer.shadowOffset = offset
    }
    
    // 生成条形码
    func generateBarCode128(barCodeStr: String) -> UIImage? {
        // 将传入的string转成nsstring，再编码
        let stringData = barCodeStr.data(using: String.Encoding.utf8)
        
        // 系统自带能生成的码
        //  CIAztecCodeGenerator 二维码
        //  CICode128BarcodeGenerator 条形码
        //  CIPDF417BarcodeGenerator
        //  CIQRCodeGenerator 二维码
        let qrFilter = CIFilter(name: "CICode128BarcodeGenerator")
        qrFilter?.setDefaults()
        qrFilter?.setValue(stringData, forKey: "inputMessage")
        
        let outputImage: CIImage? = qrFilter?.outputImage
        
        // 消除模糊方法一
        let context = CIContext()
        let cgImage = context.createCGImage(outputImage!, from: outputImage!.extent)
        let image = UIImage(cgImage: cgImage!, scale: 1.0, orientation: UIImage.Orientation.up)
        
        // 去掉白色底
        return addText(image: image, textName: barCodeStr)
    }
    
    // 添加条形码下方文字
    func addText(image: UIImage, textName: String) -> UIImage {
        // 大小
        let height: CGFloat = 14
        let baisY: CGFloat = -9
        let size = CGSize(width: image.size.width, height: image.size.height + height)
        
        // Context
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
        
        // 获得一个位图图形上下文
        let context = UIGraphicsGetCurrentContext();
        context?.draw(image.cgImage!, in: CGRect(origin: .zero, size: image.size))
        
        // 绘制文字
        let barText: String = textName
        let textStyle = NSMutableParagraphStyle()
        textStyle.lineBreakMode = .byWordWrapping
        textStyle.alignment = .center
        
        // 画图
        barText.draw(
            in: CGRect(x: 0,
                       y: image.size.height + baisY,
                       width: size.width,
                       height: height),
            withAttributes: [NSAttributedString.Key.font: UIFont(name: "PingFangSC-Thin", size: 12)!,
                             NSAttributedString.Key.backgroundColor: UIColor.clear,
                             NSAttributedString.Key.paragraphStyle: textStyle]
        )
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return changeImagePixels(image: image!)!
    }
    
    // 把某种白色像素，变成透明色像素
    func changeImagePixels(image: UIImage,
                           fromColor: UIColor.RGBA32 = UIColor.RGBA32.white,
                           toColor: UIColor.RGBA32 = UIColor.RGBA32.clear) -> UIImage?
    {
        guard let inputCGImage = image.cgImage else {
            print("unable to get cgImage")
            return nil
        }
        
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = UIColor.RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo) else
        {
            print("unable to create context")
            return nil
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            print("unable to get context data")
            return nil
        }
        
        let pixelBuffer = buffer.bindMemory(to: UIColor.RGBA32.self, capacity: width * height)
        
        for row in 0 ..< Int(height) {
            for column in 0 ..< Int(width) {
                let offset = row * width + column
                if pixelBuffer[offset] == fromColor {
                    pixelBuffer[offset] = toColor
                }
            }
        }
        
        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
        
        return outputImage
    }

    // 查看字体
    func printFontOfFamilyName() {
        // 查看字体类型用
        let names = UIFont.fontNames(forFamilyName: "PingFang SC")
        let names2 = UIFont.fontNames(forFamilyName: "Roboto")
        let names3 = UIFont.fontNames(forFamilyName: "Georgia")
        let names4 = UIFont.fontNames(forFamilyName: "Arial")
        let names5 = UIFont.fontNames(forFamilyName: "SF Pro Text")

        print(names, names2, names3, names4, names5)
    }
    
    // 播放提示音
    func playSound(ifShark: Bool) {
        // 定义声音索引
        var soundId: SystemSoundID = 0
        //
        let fileName: String = "pay_success.mp3"
        // 根据文件给索引赋值
        guard let fileUrl = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            return
        }
        
        // 播放创建
        AudioServicesCreateSystemSoundID(fileUrl as CFURL, &soundId)
        
        //全局队列（并发队列）异步执行，开多个线程，一起执行
        DispatchQueue.global().async {
            // 震我一下？
            if ifShark {
                // 有震动播放完成监听
                AudioServicesPlaySystemSoundWithCompletion(soundId, {
                    print(fileName + " sound played over.")
                })
            }
            else {
                // 无震动播放完成监听
                AudioServicesPlayAlertSoundWithCompletion(soundId, {
                    print(fileName + " sound played over.")
                })
            }
        }
    }
}

// MARK:- if
extension Utils {
    
    // 是否包含某字符串
    func ifContains(originalStr: String!, containStr: String!) -> Bool {
        if originalStr.contains(containStr) {
            return true
        } else {
            return false
        }
    }
}
