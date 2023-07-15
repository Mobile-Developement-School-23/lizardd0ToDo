//
//  TextView.swift
//  todolistYandex
//
//  Created by Елизавета Шерман on 28.06.2023.
//

import Foundation
import UIKit

class TextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        text = "Что нужно сделать?"
        layer.cornerRadius = 16
        backgroundColor = .tertiarySystemBackground
        textColor = .systemGray
        isScrollEnabled = false
        font = UIFont.systemFont(ofSize: 17)
        textContainerInset = UIEdgeInsets(top: 17, left: 12, bottom: 12, right: 12)
        translatesAutoresizingMaskIntoConstraints = false
//        delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getText() -> String? {
        if textColor == .lightGray {
            return nil
        }
        
        return text
    }
}
