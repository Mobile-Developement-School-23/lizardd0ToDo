//
//  ListOfItemsViewController.swift
//  todolistYandex
//
//  Created by Елизавета Шерман on 28.06.2023.
//

import Foundation
import UIKit
let fileCache = FileCache()
let filename = "name"

class ListOfToDoController: UIViewController, UITableViewDelegate {
    let plusButton = UIButton()
    let headerView = Header()
    private var listofitems = [TodoItem]()
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    let networking = DefaultNetworkingService()
    
    let database = DataBase()
//    let coreData = CoreDataBase()
    
    private var isDirty = false
    enum ShowOrHide {
        case show // нажата кнопка показать - видим все элементы
        case hide // нажали кнопку скрыть - видим только несделанные дела
    }
    private var isShow = ShowOrHide.show
    override func viewDidLoad() {
        super.viewDidLoad()

        loadFromService()
        
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
        self.navigationItem.title = "Мои дела"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.directionalLayoutMargins.leading = 32
        setTableView()
        tableView.separatorStyle = .singleLine
        tableView.layer.cornerRadius = 16
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.isScrollEnabled = true
        tableView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
        view.addSubview(tableView)
        plusButton.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        plusButton.addTarget(self, action: #selector(editingTask), for: .touchUpInside)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(plusButton)
        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            plusButton.heightAnchor.constraint(equalToConstant: 44),
            plusButton.widthAnchor.constraint(equalToConstant: 44),
            plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plusButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -54)
        ])
    }
    @objc private func editingTask() {
        let rootController = TaskViewController()
        let navigationController = UINavigationController(rootViewController: rootController)
        rootController.delegate = self
        present(navigationController, animated: true)
    }
    
    private func loadFromService() {
//        fileCache.loadFromDB()
//        listofitems = fileCache.listofitems
        Task {
            do {
                let todoitems = try await networking.getListRequest()
                fileCache.deleteAll()
                fileCache.updateAllItems(with: todoitems)
                
                database.deleteAllData()
                fileCache.saveToDB()
                
                // Core Data
                //fileCache.saveToCoreData()
                
                listofitems = todoitems
                tableView.reloadData()
            }
        }
    }

    
    private func setTableView() {
        tableView.register(ItemCell.self, forCellReuseIdentifier: "\(ItemCell.self)")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 56
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.setTabeleViewData()
    }
    private func setTabeleViewData() {
        self.tableView.reloadData()
    }
}

extension ListOfToDoController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listofitems.count + 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ItemCell.self)", for: indexPath) as? ItemCell else {
            preconditionFailure("MyItemCell can not be dequeued")
        }
        cell.setRow(rowInSection: indexPath.row)
        if indexPath.row != listofitems.count {
            let item = listofitems[indexPath.row]
            cell.flagDefault()
            cell.textOfTask.textColor = .black
            let fullString = NSMutableAttributedString()
            let textString = NSAttributedString(string: item.text)
            let attachment = NSTextAttachment()
            if item.importance == TodoItem.Importance.important {
                let string = "exclamationmark.2"
                if let image = UIImage(systemName: string,
                                       withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .bold))?
                                        .withTintColor(.red, renderingMode: .alwaysOriginal) {
                    attachment.image = image
                    fullString.append(NSAttributedString(attachment: attachment))
                    cell.flagImportant()
                }
            } else if  item.importance == TodoItem.Importance.unimportant {
                let boldIcon = UIImage.SymbolConfiguration(weight: .bold)
                let image = UIImage(systemName: "arrow.down", withConfiguration: boldIcon)?.withTintColor(UIColor.systemGray, renderingMode: .alwaysOriginal)
                attachment.image = image
                fullString.append(NSAttributedString(attachment: attachment))
            }
            fullString.append(textString)
            if item.flag {
                cell.flagDone()
                fullString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: fullString.length))
                cell.textOfTask.textColor = .tertiaryLabel
            }
            cell.textOfTask.attributedText = fullString
            if let deadline = item.deadline {
                let formatter = DateFormatter()
                formatter.dateFormat = "d MMMM"
                let text = formatter.string(from: deadline)
                let attachmentCalendar = NSTextAttachment()
                attachmentCalendar.image = UIImage(systemName: "calendar")?.withTintColor(.tertiaryLabel)
                let fullString = NSMutableAttributedString()
                let textString = NSAttributedString(string: text)
                fullString.append(NSAttributedString(attachment: attachmentCalendar))
                fullString.append(textString)
                cell.deadlineLabel.attributedText = fullString
                cell.textTaskBottomConstraint.isActive = false
            } else {
                cell.textTaskBottomConstraint.isActive = true
                let normalString = NSMutableAttributedString(string: "")
                normalString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSRange(location: 0, length: normalString.length))
                cell.deadlineLabel.attributedText = normalString
            }
            if item.flag {
                if isShow == .hide {
                    listofitems.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                }
            }
        } else {
            let textString = NSAttributedString(string: "Новое")
            cell.textOfTask.attributedText = textString
            cell.textOfTask.textColor = .tertiaryLabel
            cell.flag.isHidden = true
            cell.chevron.isHidden = true
            cell.textTaskBottomConstraint.isActive = true
        }
        cell.configure(delegate: self)
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: nil) {            (_, _, complitionHand) in
            let item = self.listofitems[indexPath.row]
            fileCache.deleteitem(id: item.id)
            self.listofitems.remove(at: indexPath.row)
            self.database.delete(item: item)
            
            if self.networking.isDirty {
                Task {
                    let list = try await self.networking.patchRequest(items: self.listofitems)
                    fileCache.deleteAll()
                    fileCache.updateAllItems(with: self.listofitems)
                    
                    self.database.deleteAllData()
                    fileCache.saveToDB()
                }
                self.networking.isDirty = false
            }
            Task {
                self.database.delete(item: item)
                //CoreData
//                coreData.delete(id: item.id)
                try await self.networking.deleteRequest(item: item)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            let num = fileCache.listofitems.filter({$0.flag == true}).count
            self.headerView.labelNumberOfDone.text = "Выполнено - \(num)"
            self.headerView.configure(delegate: self)
        }
        delete.image = UIImage(systemName: "trash.fill")
        delete.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [delete])
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = UIContextualAction(style: .destructive, title: nil) {
            (_, _, complitionHand) in
            guard let cell = tableView.cellForRow(at: indexPath) as? ItemCell else {
                preconditionFailure("There is no cell in row")
            }
            cell.makeFlagDone()
            let item = self.listofitems[indexPath.row]
            let newitem = TodoItem(id: item.id, text: item.text, importance: item.importance, deadline: item.deadline, flag: true)
            self.listofitems.remove(at: indexPath.row)
            fileCache.additem(item: newitem)
            self.listofitems.insert(newitem, at: indexPath.row)
            self.database.insert(item: item.sqlReplaceStatement)
            //CoreData
//            coreData.insert(item: item)
            let num = fileCache.listofitems.filter({$0.flag == true}).count
            self.headerView.labelNumberOfDone.text = "Выполнено - \(num)"
            self.headerView.configure(delegate: self)
            tableView.reloadData()
            complitionHand(true)
        }
        done.image = UIImage(systemName: "checkmark.circle.fill")
        done.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [done])
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let num = fileCache.listofitems.filter({$0.flag == true}).count
        headerView.labelNumberOfDone.text = "Выполнено - \(num)"
        headerView.configure(delegate: self)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}


extension ListOfToDoController: TaskViewControllerDelegate {
    func reloadDataForTable(flag: Bool, item: TodoItem, action: actions) {
        listofitems = fileCache.listofitems
        if action == .save {
            // сохраняем новый айтем
            if networking.isDirty {
                Task {
                    let list = try await networking.patchRequest(items: listofitems)
                    fileCache.deleteAll()
                    fileCache.updateAllItems(with: list)
                    listofitems = list
                    
                    self.database.deleteAllData()
                    fileCache.saveToDB()
                }
                networking.isDirty = false
            }
            Task {
                database.insert(item: item.sqlReplaceStatement)
                
                //CoreData
//                coreData.insert(item: item)
                try await networking.postRequest(item: item)
            }
        } else if action == .update {
            // меняем айтем
            if networking.isDirty {
                Task {
                    let list = try await networking.patchRequest(items: listofitems)
                    fileCache.deleteAll()
                    fileCache.updateAllItems(with: list)
                    listofitems = list
                    
                    self.database.deleteAllData()
                    fileCache.saveToDB()
                }
                networking.isDirty = false
            }
            Task {
                database.insert(item: item.sqlReplaceStatement)
                //CoreData
//                coreData.insert(item: item)
                try await networking.putRequest(item: item)
            }
        } else {
            // удаляем айтем
            if networking.isDirty {
                Task {
                    let list = try await networking.patchRequest(items: listofitems)
                    fileCache.deleteAll()
                    fileCache.updateAllItems(with: list)
                    listofitems = list
                    
                    self.database.deleteAllData()
                    fileCache.saveToDB()
                }
                networking.isDirty = false
            }
            Task {
                database.delete(item: item)
                //CoreData
//                coreData.delete(id: item.id)
                try await networking.deleteRequest(item: item)
            }
        }
        Task {
            listofitems = try await networking.getListRequest()
        }
        tableView.reloadData()
    }
}

extension ListOfToDoController: IsShowOrHide {
    func showOrHide(flag: Bool) {
        if !flag {
            isShow = .show
            listofitems = fileCache.listofitems
        } else {
            isShow = .hide
            listofitems = fileCache.listofitems.filter({$0.flag == false})
        }
        tableView.reloadData()
    }
}

extension ListOfToDoController: ButtonFlagTapped {
    func buttonTapped(isDone: Bool, rowInSection: Int) {
        let item = listofitems[rowInSection]
        let newitem: TodoItem
        if isDone {
            newitem = TodoItem(id: item.id, text: item.text, importance: item.importance, deadline: item.deadline, flag: false)
        } else {
            newitem = TodoItem(id: item.id, text: item.text, importance: item.importance, deadline: item.deadline, flag: true)
        }
        listofitems.remove(at: rowInSection)
        fileCache.additem(item: newitem)
        listofitems.insert(newitem, at: rowInSection)
        fileCache.saveToDB()
        let num = fileCache.listofitems.filter({$0.flag == true}).count
        if networking.isDirty {
            Task {
                let list = try await networking.patchRequest(items: listofitems)
                listofitems = list
                
                fileCache.deleteAll()
                fileCache.updateAllItems(with: listofitems)
                fileCache.saveToDB()
            }
            networking.isDirty = false
        }
        Task {
            try await networking.putRequest(item: newitem)
            database.insert(item: newitem.sqlReplaceStatement)
        }
        headerView.labelNumberOfDone.text = "Выполнено - \(num)"
        headerView.configure(delegate: self)
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != listofitems.count {
            let item = listofitems[indexPath.row]
            let rootController = TaskViewController()
            let navigationController = UINavigationController(rootViewController: rootController)
            rootController.loadToRedactOneItem(itemEx: item)
            rootController.getId(newId: item.id)
            rootController.configure(delegate: self)
            present(navigationController, animated: true)
        } else {
            let rootController = TaskViewController()
            let navigationController = UINavigationController(rootViewController: rootController)
            rootController.delegate = self
            present(navigationController, animated: true)
        }
    }
}

enum actions {
    case save
    case update
    case delete
}
