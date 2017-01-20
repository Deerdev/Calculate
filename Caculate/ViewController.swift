//
//  ViewController.swift
//  Caculate
//
//  Created by daoquan on 2016/12/30.
//  Copyright © 2016年 daoquan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // ！感叹号的意思：optional （implicitly unwarp it隐式解包）后续使用display变量不需要再用！解包(display!.text)
    // ？问号的意思：optional   后续使用display变量需要使用！解包(display!.text)
//    @IBOutlet weak var display: UILabel?
    // 因为display在我们使用之前，肯定已经被生成好了，不会是nil了
    @IBOutlet private weak var display: UILabel!
    
    private var userInTheMiddleOfTyping = false;

    @IBAction private func touchDigital(_ sender: UIButton) {
        // 感叹号! : unwrap optional（如果currentTitle没有值就会crash）
        let digit = sender.currentTitle!
        
        if userInTheMiddleOfTyping {
            let textCurrentlyDisplay = display.text!
            display.text = textCurrentlyDisplay + digit
        } else {
            display.text = digit
        }
        userInTheMiddleOfTyping = true
        
        
        print("touch \(digit) digit")
    }

    // 【计算属性】（computed property）：计算产出的属性，取值时转为Double，设值时转为String
    // 大括号{  get{}  set{} }
    private var displayValue:Double {
        set {
            display.text = String(newValue)
        }
        get {
            // 末尾添加！的原因：可能text的内容不是数字，是"hello"字符串之类的，无法转换double类型，需要使用optional类型
            // 通过!强制解析，如果无法转换成Double就crash
            return Double(display.text!)!
        }
    }
    
    // 这种情况swift可以判断变量类型
    private var brain/* : CalculateBrain */= CalculateBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        
        if userInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userInTheMiddleOfTyping = false
        }
        
        // 通过if来判断currentTitle是否有值（避免crash）
        // 变量mathmaticalSymbol只在if条件域内有效
        if let mathmaticalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathmaticalSymbol)
        }
        displayValue = brain.result
    }
}

