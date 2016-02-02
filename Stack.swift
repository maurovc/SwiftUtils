//
//  Stack.swift
//  SwiftTest
//
//  Created by Mauro Vime Castillo on 2/2/16.
//  Copyright © 2016 Mauro Vime Castillo. All rights reserved.
//

import Foundation

struct Stack <Element>: SequenceType {
    
    var items = [Element]()
    
    mutating func push(newItem: Element) {
        items.append(newItem)
    }
    
    mutating func pop() -> Element? {
        guard !items.isEmpty else {
            return nil
        }
        return items.removeLast()
    }
    
    func map<U>(f: Element -> U) -> Stack<U> {
        var mappedItems = [U]()
        for item in items {
            mappedItems.append(f(item))
        }
        return Stack<U>(items: mappedItems)
    }
    
    func generate() -> StackGenerator<Element> {
        return StackGenerator(stack: self)
    }
    
}

struct StackGenerator<T>: GeneratorType {
    
    var stack: Stack<T>
    
    mutating func next() -> T? {
        return stack.pop()
    }
    
}

// Implementation of +++ operator

infix operator +++ {}

func +++ (inout stack: Stack<AnyObject>, newElement: AnyObject) {
    stack.push(newElement)
}

// Use:
// var stack = Stack<AnyObject>()
// stack.push(1)
// stack.push(2)
// stack +++ "Hola"
//
// for element in stack {
//     print("\(element)")
// }

