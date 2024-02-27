//
//  BoardCollectionViewCell.swift
//  Achiever
//
//  Created by User on 23.02.2024.
//

import UIKit
import CoreData

class BoardCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    var fetchedResultsController: NSFetchedResultsController<List>!
    var activeList: List!
    var tasks: [Task] = []
    var controller = UICollectionViewController()
    
    private lazy var listTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "listCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
        loadDataFromCoreData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let newTaskTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Создать задачу"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let readyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        tableView = nil
//    }
 
    func setupViews() {
        contentView.addSubview(listTableView)
        
        listTableView.dataSource = self
        listTableView.delegate = self
        newTaskTextField.delegate = self
    }
    
    func setupCollectionView(list: List, controller: UICollectionViewController) {
        AuthService.shared.currentList = "\(list.listID)"
        self.activeList = list
        guard let tasks = list.listTasks else { return }
        for task in tasks {
            self.tasks.append(task as! Task)
        }
        self.controller = controller
        DispatchQueue.main.async {
            self.listTableView.reloadData()
        }
    }
    
    func loadDataFromCoreData() {
        List.loadDataFromCoreData() { [weak self] fetchedResultsController in
            self?.fetchedResultsController = fetchedResultsController
            self?.getTasks()
            DispatchQueue.main.async {
                self?.listTableView.reloadData()
            }
        }
    }
    
    func getTasks() {
        guard let lists = fetchedResultsController.fetchedObjects else { return }
        for list in lists where "\(list.listID)" == AuthService.shared.currentList {
            self.activeList = list
            guard let tasks = list.listTasks else { return }
            for task in tasks {
                self.tasks.append(task as! Task)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListTableViewCell
        
        let task = tasks[indexPath.row]
        cell.setupTableView(taskName: task.taskName, taskDeadline: task.taskDeadline, isFinished: task.isFinished)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        AuthService.shared.currentTask = "\(task.taskID)"
        controller.navigationController?.pushViewController(TaskViewController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [newTaskTextField, readyButton])
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fillEqually
            return stackView
        }()
        
        return stackView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let listNameLabel: UILabel = {
            let label = UILabel()
            if let list = activeList { label.text = list.listName }
            return label
        }()
        
        let listMenuButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
            return button
        }()
        
        let stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [listNameLabel, listMenuButton])
            stackView.axis = .horizontal
            return stackView
        }()
        
        return stackView
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        readyButton.isHidden = false
    }
    
    @objc func didReadyButtonTapped() {
        guard let taskName = newTaskTextField.text else { return }
        let _ = Task.addNewTask(taskName: taskName, taskParentList: tasks[0].taskParentList)
        DispatchQueue.main.async {
            self.listTableView.reloadData()
        }
    }
}
