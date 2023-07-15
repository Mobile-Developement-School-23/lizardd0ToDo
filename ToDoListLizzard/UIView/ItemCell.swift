//
//  ItemCell.swift
//  todolistYandex
//
//  Created by Елизавета Шерман on 28.06.2023.
//

import Foundation
import UIKit

protocol ButtonFlagTapped: AnyObject {
    func buttonTapped(isDone: Bool, rowInSection: Int)
}

class ItemCell: UITableViewCell {
    let textOfTask = UILabel()
    let deadlineLabel = UILabel()
    let chevron = UIImageView()
    weak var delegate: ButtonFlagTapped?
    
    var row = 0
    lazy var flag: UIButton = {
        let flag = UIButton()
        flag.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        flag.addTarget(self, action: #selector(done), for: .touchUpInside)
        flag.translatesAutoresizingMaskIntoConstraints = false
        
        return flag
    }()

    lazy var textTaskBottomConstraint = textOfTask.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)


        backgroundColor = .tertiarySystemBackground
        translatesAutoresizingMaskIntoConstraints = false
        

        textOfTask.textColor = .black
        textOfTask.font = UIFont(name: "normal", size: 17)
        textOfTask.numberOfLines = 3
        let normalString = NSMutableAttributedString(string: "")
        normalString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSRange(location: 0, length: normalString.length))
        textOfTask.attributedText = normalString
        textOfTask.translatesAutoresizingMaskIntoConstraints = false

        deadlineLabel.textColor = .lightGray
        deadlineLabel.font = UIFont.boldSystemFont(ofSize: 13)
        deadlineLabel.translatesAutoresizingMaskIntoConstraints = false

        let boldIcon = UIImage.SymbolConfiguration(weight: .bold)
        chevron.image = UIImage(systemName: "chevron.right", withConfiguration: boldIcon)?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        chevron.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(flag)
        contentView.addSubview(textOfTask)
        contentView.addSubview(deadlineLabel)
        contentView.addSubview(chevron)

        myConstraints()
    }

    func configure(delegate: ButtonFlagTapped) {
        self.delegate = delegate
    }
    
    func setRow(rowInSection: Int) {
        row = rowInSection
    }
    
    @objc func done() {
        var isGreen = false
        if flag.tintColor == .systemGreen {
            isGreen = true
            
        }
        
        delegate?.buttonTapped(isDone: isGreen, rowInSection: row)
    }

    private func myConstraints() {
        NSLayoutConstraint.activate([
            flag.heightAnchor.constraint(equalToConstant: 24),
            flag.widthAnchor.constraint(equalToConstant: 24),
            flag.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            flag.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            textOfTask.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            textOfTask.leadingAnchor.constraint(equalTo: flag.trailingAnchor, constant: 12),
            textOfTask.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -16),


            deadlineLabel.topAnchor.constraint(equalTo: textOfTask.bottomAnchor),
            deadlineLabel.leadingAnchor.constraint(equalTo: textOfTask.leadingAnchor),
            deadlineLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevron.widthAnchor.constraint(equalToConstant: 7),
            chevron.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeFlagDone() {
        flagDone()
        textOfTask.textColor = .tertiaryLabel
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: textOfTask.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        textOfTask.attributedText = attributeString
        deadlineLabel.isHidden = true
    }

    func flagDefault() {
        flag.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        flag.tintColor = .tertiaryLabel
    }

    func flagImportant() {
        flag.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        flag.tintColor = .systemRed
    }

    func flagDone() {
        flag.tintColor = .systemGreen
        flag.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        flag.layer.cornerRadius = 12
    }

    override func prepareForReuse() {
        let normalString = NSMutableAttributedString(string: "")
        normalString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSRange(location: 0, length: normalString.length))
        
        textOfTask.attributedText = normalString
        
        deadlineLabel.attributedText = normalString
        
        flagDefault()
        flag.isHidden = false

        chevron.isHidden = false
    }
    
}

