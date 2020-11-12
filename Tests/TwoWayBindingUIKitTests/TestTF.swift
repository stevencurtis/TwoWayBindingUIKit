//
//  File.swift
//  
//
//  Created by Steven Curtis on 12/11/2020.
//

import UIKit

class TestTF: UITextField {
    var closure: ((String) -> ())?
    override var text: String? {
         didSet {
            if let closure = closure {
                closure(text!)
            }
         }
     }
}
