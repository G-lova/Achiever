//
//  TaskViewController.swift
//  Achiever
//
//  Created by User on 24.02.2024.
//

import UIKit

class TaskViewController: UIViewController {
    
    let currentTask = AuthService.shared.currentTask
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.frame.size = contentSize
        return contentView
    }()
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height * 2)
    }
    
    private let boardLabel: UILabel = {
        let label = UILabel()
        label.text = "Проект:"
        label.textColor = UIColor(named: "PrimaryTextLabelColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var boardButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "ComplementaryTextButtonColor"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let listLabel: UILabel = {
        let label = UILabel()
        label.text = "Колонка:"
        label.textColor = UIColor(named: "PrimaryTextLabelColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var listButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "ComplementaryTextButtonColor"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let taskNameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor(named: "PrimaryTextLabelColor")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var isFineshedCheckbox: UISwitch = {
        let checkbox = UISwitch()
        checkbox.preferredStyle = .checkbox
        return checkbox
    }()
    
    private let clockImageView = UIImageView(image: UIImage(systemName: "clock"))
    
    private var dateButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "ComplementaryTextButtonColor"), for: .normal)
        return button
    }()
    
    var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        return datePicker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Редактирование задачи"
        

    }
    
    func setupViews() {
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(taskNameTextField)
        contentView.addSubview(boardLabel)
        contentView.addSubview(boardButton)
        contentView.addSubview(listLabel)
        contentView.addSubview(listButton)
        contentView.addSubview(isFineshedCheckbox)
        contentView.addSubview(clockImageView)
        contentView.addSubview(dateButton)
        
        boardButton.setTitle(currentTask.taskParentList.listParentBoard.boardName, for: .normal)
        listButton.setTitle(currentTask.taskParentList.listName, for: .normal)
        taskNameTextField.text = currentTask.taskName
        isFineshedCheckbox.isOn = currentTask.isFinished
        isFineshedCheckbox.addTarget(self, action: #selector(isFinishedChanged), for: .valueChanged)
        if let deadline = currentTask.taskDeadline {
            dateButton.setTitle("\(deadline)", for: .normal)
        } else {
            dateButton.setImage(UIImage(systemName: "calendar"), for: .normal)
        }
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dateButtonTapped(_:)))
        dateButton.addGestureRecognizer(tapGestureRecognizer)
        
    }

    @objc func isFinishedChanged() {
        currentTask.isFinished = isFineshedCheckbox.isOn
        CoreDataStack.shared.saveContext()
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let selectedDate = dateFormatter.string(from: sender.date)
        
        dateButton.setTitle(selectedDate, for: .normal)
    }
    
    @objc func dateButtonTapped(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let datePickerContainer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        datePickerContainer.addSubview(datePicker)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.view.addSubview(datePickerContainer)
        present(alert, animated: true, completion: nil)
    }

}
