//
//  BsCPayViewController.swift
//  UMS_pay
//
//  Created by 张桀硕 on 2020/09/01.
//  Copyright © 2020 jieshuo.zhang. All rights reserved.
//

import Foundation
import UIKit
import SwiftyMenu

class ExchangeRateViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var textField: UILabel!
    @IBOutlet weak var rateMenu: SwiftyMenu!
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var buttonDot: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var buttonAC: UIButton!
    @IBOutlet weak var rateButton: UIButton!

    // 输入最大长度
    let maxLen = 20 // 超过画面会崩
    // 固定零值时的显示
    let zeroString: String = "0"
    // 价格字符，用于被改变和操作
    var priceString: String = "0" {
        // 如果不定义oldString，默认可以使用oldValue
        didSet(oldString) {
            // 更新显示框价格显示
            setTextFieldAttributedText(text: priceString)
        }
    }
    
    // 实际的汇率
    private var rateDic: Dictionary<String, Double> = [:] {
        willSet(newDic) {
            if newDic.count > 0 {
                setButtonEnabled(enable: true)
            }
            else {
                setButtonEnabled(enable: false)
            }
        }
    }
    // 下拉菜单内容
    private var items: [String] = []

    // 当前货币
    private var currency: String = "USDUSD"
}

// MARK:- 生命周期
extension ExchangeRateViewController {
    // MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupRateMenu()
        getAllRate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        resetUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK:- 内部方法
extension ExchangeRateViewController {
    
    // 加载初始界面
    func setupViews() {
        // 通用方法
        func setting(button: UIButton, title: String) {
            // 设置按钮
            var color = UIColor.white // 按钮背景颜色
            var borderColor = UIColor.gray.cgColor // 边线颜色
            var borderWidth: CGFloat = 0.25 // 边线粗细
            var textColor1 = UIColor.colorWith(hexString: "#6C6C6C") // 普通状态下的文字颜色
            var textColor2 = UIColor.colorWith(hexString: "#FFFFFF") // 选中状态下的文字颜色
            var textFont = UIFont(name: "PingFangSC-Thin", size: 80) // 按钮的字体
            var backColer = UIColor.colorWith(hexString: "#228AE5") // 选中状态下的按钮背景颜色
            var backImage = Utils().getImageWithColor(color: backColer, width: button0.frame.width, height: button0.frame.height) // 选中状态下的按钮背景图片
            
            if Utils.isPhone() {
                color = UIColor.colorWith(hexString: "#F8F8F8") // 按钮背景颜色
                borderColor = UIColor.clear.cgColor // 边线颜色
                borderWidth = 0 // 边线粗细
                textColor1 = UIColor.colorWith(hexString: "#6C6C6C") // 普通状态下的文字颜色
                textColor2 = UIColor.colorWith(hexString: "#FFFFFF") // 选中状态下的文字颜色
                textFont = UIFont(name: "PingFangSC-Thin", size: 39) // 按钮的字体
                if title == "AC" {
                    textFont = UIFont(name: "PingFangSC-Thin", size: 30)
                }
                backColer = UIColor.colorWith(hexString: "#228AE5") // 选中状态下的按钮背景颜色
                backImage = Utils().getImageWithColor(color: backColer, width: button0.frame.width, height: button0.frame.height) // 选中状态下的按钮背景图片
            }
            
            // 通用按钮设置0-9
            button.layer.borderColor = borderColor
            button.layer.borderWidth = borderWidth
            button.layer.masksToBounds = true
            button.titleLabel?.font = textFont
            button.titleLabel?.textAlignment = NSTextAlignment.center
            button.setTitle(title, for:.normal)
            button.setTitleColor(textColor1, for: .normal)
            button.setTitleColor(textColor2, for: .highlighted)
            button.backgroundColor = color
            button.setBackgroundImage(backImage, for: .highlighted)
            
            if Utils.isPhone() {
                button.layer.cornerRadius = button.frame.height / 2
            }
            
            // ac按钮设置，iPhone下并没有什么作用
            if title == "AC" {
                button.backgroundColor = UIColor.colorWith(hexString: "#F8F8F8")
                let image = Utils().getImageWithColor(color: backColer, width: buttonAC.frame.width, height: buttonAC.frame.height)
                button.setBackgroundImage(image, for: .highlighted)
            }
        }

        // ふ汇率按钮
        rateButton.backgroundColor = UIColor.colorWith(hexString: "#FFC24D")
        rateButton.isEnabled = true
        
        // 显示器背景
        backView.backgroundColor = UIColor.colorWith(hexString: "#6A8AA3")
        // 显示器数字
        textField.backgroundColor = UIColor.clear
        setTextFieldAttributedText(text: priceString)
        
        // 设置按钮
        setting(button: buttonAC, title: "AC")
        setting(button: buttonDot, title: ".")
        setting(button: button0, title: "0")
        setting(button: button1, title: "1")
        setting(button: button2, title: "2")
        setting(button: button3, title: "3")
        setting(button: button4, title: "4")
        setting(button: button5, title: "5")
        setting(button: button6, title: "6")
        setting(button: button7, title: "7")
        setting(button: button8, title: "8")
        setting(button: button9, title: "9")
        setting(button: buttonC, title: "C")
    }
    
    // 设置下拉菜单
    func setupRateMenu() {
        rateMenu.delegate = self
        
        rateMenu.expandingDuration = 0.5
        rateMenu.collapsingDuration = 0.5
        rateMenu.listHeight = 350
        
        rateMenu.scrollingEnabled = true
        rateMenu.isMultiSelect = false
        rateMenu.hideOptionsWhenSelect = true
    }
    
    // 清除值
    func resetUI() {
        priceString = zeroString
        setTextFieldAttributedText(text: priceString)
    }
    
    // 显示器画面，动态多字体
    func setTextFieldAttributedText(text: String) {
        // 数据
        let priceAll = text // 对应美术效果
        var attributeStr = NSMutableAttributedString.init(string: priceAll)
        let preLen = zeroString.count - 1 // 价格以前字符长度
        let color = UIColor.colorWith(hexString: "#FFFFFF")
        
        // 尺寸
        let price = Utils().cutStringStart(text, lenth: preLen)
        let size1: CGFloat = Utils.isPhone() ? 30 : 78
        let size2: CGFloat = Utils.isPhone() ? 50 : 130
        
        // 设置："¥ "
        attributeStr = Utils().getAttributeString(
            attStr: attributeStr,
            loc_len: (0, preLen),
            font: UIFont(name: "PingFangSC-Thin", size: size1)!,
            color: color)
        
        // 设置："123"
        attributeStr = Utils().getAttributeString(
            attStr: attributeStr,
            loc_len: (preLen, price.count),
            font: UIFont(name: "PingFangSC-Thin", size: size2)!,
            color: color)
        
        textField.attributedText = attributeStr
    }
    
    // 一起设置按钮是否可用
    func setButtonEnabled(enable: Bool) {
        button0.isEnabled = enable
        button1.isEnabled = enable
        button2.isEnabled = enable
        button3.isEnabled = enable
        button4.isEnabled = enable
        button5.isEnabled = enable
        button6.isEnabled = enable
        button7.isEnabled = enable
        button8.isEnabled = enable
        button9.isEnabled = enable
        buttonDot.isEnabled = enable
    }
    
    // 点击按钮时，改变按钮背景
    func changeBackColor(sender: UIButton) {
        if sender.state == UIControl.State.highlighted {
            sender.backgroundColor = UIColor.blue
        }
        else {
            sender.backgroundColor = UIColor.white
        }
    }
    
    // 操作价格字符串
    // 只在以下字符串里选：1，2，3，4，5，6，7，8，9，0，.，c。
    func setPriceString(by string:String) {
        // 算上符号的最长长度
        let trueMax = maxLen + (zeroString.count - 1)
        
        // 根据情况修改字符
        if string == "<" { // 删除一个字符
            // 去掉最后一个字符
            priceString = Utils().cutStringEnd(priceString)
            
            // 当长度比原初字符短时，赋值为原初字符
            if priceString.lengthOfBytes(using: String.Encoding.utf8) < zeroString.lengthOfBytes(using: String.Encoding.utf8) {
                priceString = zeroString
            }
        }
        else if string == "c"{ // 清空字符
            priceString = zeroString
        }
        else { // 追加字符
            // 增加后的长度
            let futureLen = string.count + priceString.count
            
            // 限制长度
            if priceString.count == trueMax {
                Utils().okButtonAlertView(
                    title: "you can't over 20 world.",
                    controller: self,
                    block: nil)
                return
            }
            
            // 如果是从“0”开始增加改变
            if priceString == zeroString {
                // 先切割成无“0”字符
                priceString = Utils().cutStringEnd(priceString)
                
                // 如果增加的是“.”
                if string == "." {
                    priceString = priceString + "0."
                }
                else {
                    priceString = priceString + string
                }
            }
            else { // 不是从最初开始增加
                // 增加“.”的时候，不能超过长度
                if (string == ".") && (futureLen >= trueMax) {
                    return
                }
                // 文中不能出现两个点
                else if (string == ".") && priceString.contains(".") {
                    return
                }
                else {
                    priceString = priceString + string
                }
            }
        }
    }
    
    func getAllRate() {
        // 设置初始数据
        Network().post_getAllRate_request(
            controller: self,
            block: { [weak self] quotes in
                self!.rateDic = quotes
                
                var list: [SwiftyMenuDisplayable] = []
                for (key, _) in self!.rateDic {
                    list.append(key)
                }
                self!.items = list as! [String]
                
                self!.rateMenu.items = self!.items
                self!.rateMenu.selectedIndex = self!.items.index(of: self!.currency)
        })
    }
    
}

// MARK:- 界面交互
extension ExchangeRateViewController {
    
    @IBAction func tap1Button(_ sender: UIButton) {
        setPriceString(by: "1")
    }
    
    @IBAction func tap2Button(_ sender: UIButton) {
        setPriceString(by: "2")
    }
    
    @IBAction func tap3Button(_ sender: UIButton) {
        setPriceString(by: "3")
    }
    
    @IBAction func tap4Button(_ sender: UIButton) {
        setPriceString(by: "4")
    }
    
    @IBAction func tap5Button(_ sender: UIButton) {
        setPriceString(by: "5")
    }
    
    @IBAction func tap6Button(_ sender: UIButton) {
        setPriceString(by: "6")
    }
    
    @IBAction func tap7Button(_ sender: UIButton) {
        setPriceString(by: "7")
    }
    
    @IBAction func tap8Button(_ sender: UIButton) {
        setPriceString(by: "8")
    }
    
    @IBAction func tap9Button(_ sender: UIButton) {
        setPriceString(by: "9")
    }
    
    @IBAction func tap0Button(_ sender: UIButton) {
        setPriceString(by: "0")
    }
    
    @IBAction func tap00Button(_ sender: UIButton) {
        setPriceString(by: ".")
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        setPriceString(by: "<")
    }
    
    @IBAction func tapClearButton(_ sender: UIButton) {
        setPriceString(by: "c")
    }
    
    // 点击获取汇率按钮
    @IBAction func tapGetRateButton(_ sender: UIButton) {
        getAllRate()
    }
}

// MARK:- 下拉代理
extension ExchangeRateViewController: SwiftyMenuDelegate {
    // 从下拉菜单选中的元素
    func swiftyMenu(_ swiftyMenu: SwiftyMenu, didSelectItem item: SwiftyMenuDisplayable, atIndex index: Int) {
        print("Selected item: \(item), at index: \(index)")
        
        let oldRate = rateDic[currency]!
        let oldPrice = Double(priceString)!
        let newRate = rateDic[item as! String]!
        var newPrice = Utils().getNewPrice(oldPrice: oldPrice, oldRate: oldRate, newRate: newRate)
        newPrice = Utils().getDouble(newPrice, offset: 2)
        
        priceString = String(newPrice)
        currency = item as! String
    }
    
    // 下拉菜单将要展开
    func swiftyMenu(willExpand swiftyMenu: SwiftyMenu) {
        print("SwiftyMenu willExpand.")
    }
    
    // 下拉菜单已经展开
    func swiftyMenu(didExpand swiftyMenu: SwiftyMenu) {
        print("SwiftyMenu didExpand.")
    }
    
    // 下拉菜单将要合起
    func swiftyMenu(willCollapse swiftyMenu: SwiftyMenu) {
        print("SwiftyMenu willCollapse.")
    }
    
    // 下拉菜单已经合起
    func swiftyMenu(didCollapse swiftyMenu: SwiftyMenu) {
        print("SwiftyMenu didCollapse.")
    }
}
