//
//  TaskViewController.swift
//  todolistYandex
//
//  Created by Елизавета Шерман on 28.06.2023.
//

import Foundation
import UIKit

protocol TaskViewControllerDelegate: AnyObject {
    func reloadDataForTable(flag: Bool, item: TodoItem, action: actions)
}


class TaskViewController: UIViewController, UIAlertViewDelegate {
    var item: TodoItem?
    
    let textOfTask = TextView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let stackImportanceAndDeadline = UIStackView()
    let importanceStack = ImportanceStack()
    let devider = UIView()
    let deadlineStack = DeadlineStack()
    let deviderBeforeCalendar = UIView()
    let calendar = UIDatePicker()
    let deleteButton = DeleteButton()
    var id: String? = nil
    
    weak var delegate: TaskViewControllerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(moveTextForKeyboard(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
        
        setNavigationBar()
        
        let tapElsewhereGesture = UITapGestureRecognizer(target: self, action: #selector(tappedNotInKeyboard))
        tapElsewhereGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapElsewhereGesture)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        textOfTask.delegate = self
        contentView.addSubview(textOfTask)
        
        stackImportanceAndDeadline.axis = .vertical
        stackImportanceAndDeadline.backgroundColor = .white
        stackImportanceAndDeadline.layer.cornerRadius = 16
        stackImportanceAndDeadline.translatesAutoresizingMaskIntoConstraints = false


        devider.backgroundColor = .systemGray
        devider.translatesAutoresizingMaskIntoConstraints = false

        stackImportanceAndDeadline.addArrangedSubview(importanceStack)
        stackImportanceAndDeadline.addArrangedSubview(devider)
        stackImportanceAndDeadline.addArrangedSubview(deadlineStack)
        
        deviderBeforeCalendar.backgroundColor = .systemGray
        deviderBeforeCalendar.isHidden = true
        deviderBeforeCalendar.translatesAutoresizingMaskIntoConstraints = false
        stackImportanceAndDeadline.addArrangedSubview(deviderBeforeCalendar)
        
        let tapDateGesture = UITapGestureRecognizer(target: self, action: #selector(dateLabelTapped))
        deadlineStack.dateLabel.addGestureRecognizer(tapDateGesture)
        deadlineStack.dateLabel.isUserInteractionEnabled = true
        deadlineStack.switcher.addTarget(self, action: #selector(deadlineSwitchTapped), for: .valueChanged)
        
        calendar.isHidden = true
        calendar.preferredDatePickerStyle = .inline
        calendar.datePickerMode = .date
        calendar.minimumDate = Date()
        calendar.addTarget(self, action: #selector(changingDate), for: .valueChanged)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        stackImportanceAndDeadline.addArrangedSubview(calendar)
        
        contentView.addSubview(stackImportanceAndDeadline)
        
        deleteButton.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        contentView.addSubview(deleteButton)
        
        myConstraints()
        
        
    }
    
    private func myConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            textOfTask.topAnchor.constraint(equalTo: contentView.topAnchor),
            textOfTask.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textOfTask.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textOfTask.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            stackImportanceAndDeadline.topAnchor.constraint(equalTo: textOfTask.bottomAnchor, constant: 16),
            stackImportanceAndDeadline.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackImportanceAndDeadline.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            importanceStack.heightAnchor.constraint(equalToConstant: 56),
            importanceStack.importanceLabel.leadingAnchor.constraint(equalTo: stackImportanceAndDeadline.leadingAnchor, constant: 16),
            importanceStack.importanceLabel.heightAnchor.constraint(equalToConstant: 17),
            importanceStack.importanceSwitch.trailingAnchor.constraint(equalTo: stackImportanceAndDeadline.trailingAnchor, constant: -12),
            importanceStack.importanceSwitch.heightAnchor.constraint(equalToConstant: 36),
            importanceStack.importanceSwitch.widthAnchor.constraint(equalToConstant: 150),
            devider.leadingAnchor.constraint(equalTo: stackImportanceAndDeadline.leadingAnchor, constant: 16),
            devider.trailingAnchor.constraint(equalTo: stackImportanceAndDeadline.trailingAnchor, constant: -16),
            devider.heightAnchor.constraint(equalToConstant: 1/UIScreen.main.scale),
            
            deadlineStack.topAnchor.constraint(equalTo: devider.bottomAnchor),
            deadlineStack.heightAnchor.constraint(equalToConstant: 56),
            deadlineStack.stack.leadingAnchor.constraint(equalTo: stackImportanceAndDeadline.leadingAnchor, constant: 16),
            deadlineStack.switcher.trailingAnchor.constraint(equalTo: stackImportanceAndDeadline.trailingAnchor, constant: -12),
            deviderBeforeCalendar.topAnchor.constraint(equalTo: deadlineStack.bottomAnchor),
            deviderBeforeCalendar.leadingAnchor.constraint(equalTo: stackImportanceAndDeadline.leadingAnchor, constant: 16),
            deviderBeforeCalendar.trailingAnchor.constraint(equalTo: stackImportanceAndDeadline.trailingAnchor, constant: -16),
            deviderBeforeCalendar.heightAnchor.constraint(equalToConstant: 1/UIScreen.main.scale),
            calendar.topAnchor.constraint(equalTo: deviderBeforeCalendar.bottomAnchor, constant: 8),
            calendar.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: stackImportanceAndDeadline.bottomAnchor, constant: 16),
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 56),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
    
    
    private func setNavigationBar() {
        self.navigationItem.title = "Дело"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancelTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveTapped))
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 17)]
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
    }
    
    private func readFromFile(filename: String) {
        fileCache.readfromfileJSON(filename: filename)
        if fileCache.listofitems.count > 0 {
            item = fileCache.listofitems[0]
            textOfTask.text = item?.text
            textOfTask.textColor = .black
        } else {
            return
        }
        
    }

    
    
    @objc func tappedNotInKeyboard() {
        textOfTask.endEditing(true)
        textOfTask.resignFirstResponder()
    }

    
    @objc func changingDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        deadlineStack.dateLabel.text = formatter.string(from: calendar.date)
        deadlineStack.date = calendar.date
    }
    
    @objc func deadlineSwitchTapped() {
        if deadlineStack.switcher.isOn {
            deadlineStack.dateLabel.isHidden = false
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM yyyy"
            guard let date = Calendar.current.date(byAdding: .day, value: 1, to: .now) else {
                return
            }
            
            deadlineStack.dateLabel.text = formatter.string(from: date)
            deadlineStack.date = date
            calendar.isHidden = true
            deviderBeforeCalendar.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            guard let date = Calendar.current.date(byAdding: .day, value: 1, to: .now) else {
                return
            }
            calendar.setDate(date, animated: true)
            deadlineStack.date = date
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
            changingDate()
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
        } else {
            deadlineStack.dateLabel.isHidden = true
            calendar.isHidden = true
            deviderBeforeCalendar.isHidden = true
        }
    }
    
    @objc func dateLabelTapped() {
        if calendar.isHidden {
            UIView.animate(withDuration: 0.5) {
                self.calendar.isHidden.toggle()
                self.deviderBeforeCalendar.isHidden.toggle()
                self.view.layoutIfNeeded()
                
                UIView.transition(with: self.calendar, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        } else {
            UIView.transition(with: self.calendar, duration: 0.5, options: .transitionCrossDissolve, animations: nil) { _ in
                UIView.animate(withDuration: 0.3) {
                    self.calendar.isHidden.toggle()
                    self.deviderBeforeCalendar.isHidden.toggle()
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    
    
    
    func getId(newId: String) {
        id = newId
    }
    
    @objc func deleteItem() {
        if let delItem = item {
            fileCache.deleteitem(id: delItem.id)
            fileCache.savetofileJSON(filename: filename)
            self.delegate?.reloadDataForTable(flag: true, item: delItem, action: .delete)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func configure(delegate: TaskViewControllerDelegate) {
        self.delegate = delegate
    }
    
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveTapped() {
        if let text = textOfTask.text,
           !text.isEmpty,
           text != "Что нужно сделать?" {
            let importance: TodoItem.Importance
            switch importanceStack.importanceSwitch.selectedSegmentIndex {
            case 0: importance = TodoItem.Importance.unimportant
            case 1: importance = TodoItem.Importance.ordinary
            case 2: importance = TodoItem.Importance.important
            default: importance = TodoItem.Importance.ordinary
            }
            
            let deadline: Date? = deadlineStack.getDate()
            var newItem: TodoItem
            var act: actions
            if let item = item {
                newItem = TodoItem(id: item.id, text: text, importance: importance, deadline: deadline)
                act = .update
            } else {
                newItem = TodoItem(id: UUID().uuidString, text: text, importance: importance, deadline: deadline)
                act = .save
            }
            
            fileCache.additem(item: newItem)
            fileCache.savetofileJSON(filename: filename)
            navigationItem.rightBarButtonItem?.isEnabled = false
            var dialogMessage = UIAlertController(title: "Внимание!", message: "Вы сохранили дело!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                self.dismiss(animated: true, completion: nil)
              })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
            self.delegate?.reloadDataForTable(flag: true, item: newItem, action: act)
        } else {
            var dialogMessage = UIAlertController(title: "Ой-ой!", message: "Вы не ввели текст! Попробуйте еще раз.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                
              })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [self] _ in
                if UIDevice.current.orientation.isLandscape {
                    self.deleteButton.isHidden = true
                    self.stackImportanceAndDeadline.isHidden = true
                    self.textOfTask.heightAnchor.constraint(greaterThanOrEqualToConstant: 330).isActive = true
                } else {
                    self.deleteButton.isHidden = false
                    self.stackImportanceAndDeadline.isHidden = false
                    self.textOfTask.heightAnchor.constraint(equalToConstant: 120).isActive = true
                    self.textOfTask.heightAnchor.constraint(equalToConstant: 120).isActive = false
                    self.myConstraints()
                }
            }, completion: nil)
        }


    
}



extension TaskViewController: UITextViewDelegate {
    // когда начинаем печатать
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Что нужно сделать?" {
            textView.text = ""
//            deleteButton.isEnabled = true
            navigationItem.rightBarButtonItem?.isEnabled = true
            textView.textColor = .black
            
        }
        deleteButton.isEnabled = true
    }
    
    // смотрим, закончилась ли печать
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text != "" {
            return true
        } else {
            textView.textColor = .lightGray
            textView.text = "Что нужно сделать?"
            deleteButton.isEnabled = true
            return false
        }
    }

    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                if estimatedSize.height > 120 {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
    
    @objc func moveTextForKeyboard(_ notification: Notification) {
        if let keys = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let protectContent = UIEdgeInsets(top: 0, left: 0, bottom: keys.cgRectValue.height, right: 0)
            scrollView.scrollIndicatorInsets = protectContent
            scrollView.contentInset = protectContent
        }
    }
    
    func loadToRedactOneItem(itemEx: TodoItem) {
        item = itemEx
        textOfTask.text = itemEx.text
        textOfTask.textColor = .black
        switch itemEx.importance {
        case TodoItem.Importance.important: importanceStack.importanceSwitch.selectedSegmentIndex = 2
        case TodoItem.Importance.unimportant:
            importanceStack.importanceSwitch.selectedSegmentIndex = 0
        case TodoItem.Importance.ordinary:
            importanceStack.importanceSwitch.selectedSegmentIndex = 1
        default:
            importanceStack.importanceSwitch.selectedSegmentIndex = 1
        }
        
        if let deadline = itemEx.deadline {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMMM yyyy"
            deadlineStack.dateLabel.text = formatter.string(from: deadline)
            deadlineStack.dateLabel.isHidden = false
            deadlineStack.switcher.isOn = true
        }
    }
}



