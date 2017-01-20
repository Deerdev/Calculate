//
//  CalculateBrain.swift
//  Caculate
//
//  Created by daoquan on 2017/1/20.
//  Copyright © 2017年 daoquan. All rights reserved.
//

// Model模块，不包含UIKit，与UI无关
import Foundation

func multiply(op1: Double, op2: Double) -> Double {
    return op1 * op2
}

class CalculateBrain {
    
    /*
    // associated value
    // optional的原理也是一个enum
    enum Optional<T> {
        case None
        case some(T)
    }
    */
    
    // 初始化后，swift知道它的类型
    var accumulator/*: Double*/ = 0.0
    // 设置当前显示值
    func setOperand(operand: Double) -> Void {
        accumulator = operand
    }
    
    var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI), //M_PI
        "e" : Operation.Constant(M_E), // M_E
        "√" : Operation.UnaryOperation(sqrt), // sqrt
        "cos" : Operation.UnaryOperation(cos), //cos
        "±" : Operation.UnaryOperation({ -$0}),
        
//        // --1--外置函数
//        "×" : Operation.BinaryOperation(multiply),
//        // --2--闭包{1 in 2}
//        "×" : Operation.BinaryOperation({(op1: Double, op2: Double) -> Double in
//            return op1 * op2
//            }),
//        // --3--精简，swift可以判断类型（根据BinaryOperation的enum定义）
//        "×" : Operation.BinaryOperation({(op1, op2) in return op1 * op2}),
//        // --4--再精简。($0,$1)第一第二个参数
//        "×" : Operation.BinaryOperation({return $0 * $1}),
//        // --5-- swift可以判断返回类型（根据BinaryOperation的enum定义）
        "×" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "−" : Operation.BinaryOperation({$0 - $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        
        "=" : Operation.Equals
    ]
    
    // associated value 添加关联值
    enum Operation {
        case Constant(Double) //常量
        // 关联一个函数
        case UnaryOperation((Double)->Double) // 一元操作符
        case BinaryOperation((Double, Double)->Double) // 二元操作符
        case Equals //相等
    }
    // 操作符计算
    func performOperation(symbol: String) -> Void {
        //        if symbol == "π" {
        //            accumulator = M_PI
        //        } else if symbol == "√" {
        //            // 取值调用get函数，设置值调用get函数
        //            accumulator = sqrt(accumulator)
        //        }
        
        // ---1---
//        switch symbol {
//        case "π":
//            accumulator = M_PI
//        case "√":
//            accumulator = sqrt(accumulator)
//        default:
//            break
//        }
        
        // ---2---
        // 可能symbol不是一个key，所以返回时optional
        if let operation = operations[symbol] {
            // 四种类型全部罗列完，不需要加default
            switch operation {
            // 添加关联值之后
            case .Constant(let associatedConstantValue): accumulator = associatedConstantValue
            case .UnaryOperation(let function): accumulator = function(accumulator)
            // 按下二元操作符只记录前一个数值
            case .BinaryOperation(let foo): pending = PendingBinaryOperationInfo(binaryFuncion: foo, firstOperand: accumulator)
            // 计算之前的值
            case .Equals:
                executePendingBinaryOperation()
            }
        }
        
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFuncion(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    var pending : PendingBinaryOperationInfo?
    
    // 存储二元操作的数值，因为按下X之后，要按下=号才能计算结果
    struct PendingBinaryOperationInfo {
        // 结构体可以不初始化对象，但是要定义时需要使用optional变量
        // 初始化时，也要多所有的成员变量初始化
        var binaryFuncion: (Double, Double) -> Double
        var firstOperand:Double
        
    }
    
    // 只读属性，set只在本类内执行
    var result: Double {
        get {
            return accumulator
        }
    }
    
}
