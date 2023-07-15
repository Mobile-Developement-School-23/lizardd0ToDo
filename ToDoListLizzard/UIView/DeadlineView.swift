//
//  DeadlineView.swift
//  todolistYandex
//
//  Created by Елизавета Шерман on 28.06.2023.
//

import Foundation
import UIKit

class DeadlineStack: UIStackView {
    let stack = UIStackView()
    let deadlineLabel = UILabel()
    let dateLabel = UILabel()
    let switcher = UISwitch()
    var date: Date? = nil

    func getDate() -> Date? {
        return date
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .horizontal
        distribution = .fill
        alignment = .center
        translatesAutoresizingMaskIntoConstraints = false
        
        
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 3
        stack.distribution = .fill
        
        deadlineLabel.text = "Сделать до"
        deadlineLabel.textAlignment = .left
        deadlineLabel.font = UIFont.systemFont(ofSize: 17)
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(deadlineLabel)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        guard let date = Calendar.current.date(byAdding: .day, value: 1, to: .now) else {
            return
        }
        
        dateLabel.text = formatter.string(from: date)
        dateLabel.textAlignment = .left
        dateLabel.font = UIFont.boldSystemFont(ofSize: 13)
        dateLabel.textColor = .systemBlue
        dateLabel.isHidden = true
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(dateLabel)
        
        
        
        addArrangedSubview(stack)
        addArrangedSubview(switcher)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
