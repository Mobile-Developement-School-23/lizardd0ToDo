//
//  HeaderView.swift
//  todolistYandex
//
//  Created by Елизавета Шерман on 30.06.2023.
//

import Foundation
import UIKit

protocol IsShowOrHide: AnyObject {
    func showOrHide(flag: Bool)
}

class Header: UIView {
    let labelNumberOfDone = UILabel()
    let buttonShow = UIButton()
    
    var flag = false
    weak var delegate: IsShowOrHide?
    
    private var text = "Выполнено - 0"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
        layer.cornerRadius = 16
        labelNumberOfDone.text = text
        labelNumberOfDone.textColor = .tertiaryLabel
        labelNumberOfDone.font = UIFont(name: "normal", size: 15)
        labelNumberOfDone.translatesAutoresizingMaskIntoConstraints = false
        
        buttonShow.setTitle("Скрыть", for: .normal)
        buttonShow.setTitleColor(.systemBlue, for: .normal)
        buttonShow.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
        buttonShow.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        buttonShow.addTarget(self, action: #selector(buttonShowTapped), for: .touchUpInside)
        buttonShow.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelNumberOfDone)
        addSubview(buttonShow)
        myConstraints()
    }
    
    
    func myConstraints() {
        NSLayoutConstraint.activate([
            labelNumberOfDone.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            labelNumberOfDone.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelNumberOfDone.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            buttonShow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            buttonShow.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            buttonShow.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    func configure(delegate: IsShowOrHide) {
        self.delegate = delegate
    }
    
    
    func configureDoneLabel(count: Int) {
        text = "Выполнено - \(count)"
    }
    
    @objc func buttonShowTapped() {
        // скрыть - флаг false - стоит изначально
        flag.toggle()
        if flag {
            buttonShow.setTitle("Показать", for: .normal)
        } else {
            buttonShow.setTitle("Скрыть", for: .normal)
        }
        delegate?.showOrHide(flag: flag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
