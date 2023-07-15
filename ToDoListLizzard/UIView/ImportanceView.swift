//
//  ImportanceView.swift
//  todolistYandex
//
//  Created by Елизавета Шерман on 28.06.2023.
//

import Foundation
import UIKit

class ImportanceStack: UIStackView {
    var importance: TodoItem.Importance = TodoItem.Importance.ordinary
    let importanceLabel = UILabel() // надпись
    let importanceSwitch = UISegmentedControl()  // переключатель
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .horizontal
        distribution = .fill
        alignment = .center
        isLayoutMarginsRelativeArrangement = true
        translatesAutoresizingMaskIntoConstraints = false
        
        importanceLabel.text = "Важность"
        importanceLabel.textAlignment = .left
        importanceLabel.font = UIFont.systemFont(ofSize: 17)
        importanceLabel.translatesAutoresizingMaskIntoConstraints = false

        let twoPoints = UIImage(systemName: "exclamationmark.2", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .bold))?.withTintColor(.red, renderingMode: .alwaysOriginal)
        importanceSwitch.insertSegment(with: UIImage(systemName: "arrow.down"), at: 0, animated: false)
        importanceSwitch.insertSegment(withTitle: "нет", at: 1, animated: false)
        importanceSwitch.insertSegment(with: twoPoints, at: 2, animated: false)
        importanceSwitch.translatesAutoresizingMaskIntoConstraints = false
//        importanceSwitch.selectedSegmentIndex = 1
        importanceSwitch.addTarget(self, action: #selector(importanceTapped), for: .valueChanged)
        
        addArrangedSubview(importanceLabel)
        addArrangedSubview(importanceSwitch)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func importanceTapped(importanceCheck: UISegmentedControl) {
        switch importanceCheck.selectedSegmentIndex {
        case 0:
            importance = TodoItem.Importance.unimportant
        case 1:
            importance = TodoItem.Importance.ordinary
        case 2:
            importance = TodoItem.Importance.important
        default:
            importance = TodoItem.Importance.ordinary
        }
    }
    
    func getImportance() -> TodoItem.Importance {
        return importance
    }
}
