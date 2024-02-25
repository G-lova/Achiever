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
    
    private var deleteDateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить дату", for: .normal)
        button.setTitleColor(UIColor(named: "ComplementaryTextButtonColor"), for: .normal)
        return button
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание задачи..."
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 18)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = UIColor(named: "PrimaryTextLabelColor")
        textView.backgroundColor = UIColor(named: "ViewBackgroundColor")
        textView.isEditable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autoresizingMask = [.flexibleHeight]
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Редактирование задачи"
        
        setupViews()
        setupActions()

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
        contentView.addSubview(deleteDateButton)
        contentView.addSubview(placeholderLabel)
        contentView.addSubview(textView)
        
        setupConstraints()
    }

    func setupActions() {
        
        guard let currentTask = currentTask else { return }
        boardButton.setTitle(currentTask.taskParentList.listParentBoard.boardName, for: .normal)
        
        listButton.setTitle(currentTask.taskParentList.listName, for: .normal)
        
        taskNameTextField.text = currentTask.taskName
        
        isFineshedCheckbox.isOn = currentTask.isFinished
        isFineshedCheckbox.addTarget(self, action: #selector(isFinishedChanged), for: .valueChanged)
        
        if let deadline = currentTask.taskDeadline {
            dateButton.setTitle("\(deadline)", for: .normal)
            deleteDateButton.isHidden = false
        } else {
            dateButton.setTitle("Установить дату выполнения", for: .normal)
            deleteDateButton.isHidden = true
        }
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dateButtonTapped(_:)))
        dateButton.addGestureRecognizer(tapGestureRecognizer)
        
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange), name: UITextView.textDidChangeNotification, object: textView)
        
        deleteDateButton.addTarget(self, action: #selector(didDeleteDateButtonTapped), for: .touchUpInside)
        
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            boardLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            boardLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            boardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            boardButton.leadingAnchor.constraint(equalTo: boardLabel.trailingAnchor, constant: 10),
            boardButton.topAnchor.constraint(equalTo: boardLabel.topAnchor, constant: 10),
            boardButton.bottomAnchor.constraint(equalTo: boardLabel.bottomAnchor),
            listLabel.topAnchor.constraint(equalTo: boardLabel.bottomAnchor),
            listLabel.leadingAnchor.constraint(equalTo: boardLabel.leadingAnchor),
            listLabel.trailingAnchor.constraint(equalTo: boardLabel.trailingAnchor),
            listButton.leadingAnchor.constraint(equalTo: boardButton.leadingAnchor),
            listButton.trailingAnchor.constraint(equalTo: boardButton.trailingAnchor),
            listButton.topAnchor.constraint(equalTo: boardButton.bottomAnchor),
            listButton.bottomAnchor.constraint(equalTo: listLabel.bottomAnchor),
            taskNameTextField.topAnchor.constraint(equalTo: listLabel.bottomAnchor, constant: 10),
            taskNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            taskNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            isFineshedCheckbox.topAnchor.constraint(equalTo: taskNameTextField.bottomAnchor, constant: 10),
            isFineshedCheckbox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            clockImageView.bottomAnchor.constraint(equalTo: isFineshedCheckbox.bottomAnchor),
            clockImageView.leadingAnchor.constraint(equalTo: isFineshedCheckbox.trailingAnchor, constant: 5),
            dateButton.bottomAnchor.constraint(equalTo: clockImageView.bottomAnchor),
            dateButton.leadingAnchor.constraint(equalTo: clockImageView.trailingAnchor),
            deleteDateButton.bottomAnchor.constraint(equalTo: dateButton.bottomAnchor),
            deleteDateButton.leadingAnchor.constraint(equalTo: dateButton.trailingAnchor, constant: 5),
            textView.topAnchor.constraint(equalTo: isFineshedCheckbox.bottomAnchor, constant: 5),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor)
            
        ])
    }
    
    @objc func isFinishedChanged() {
        guard let currentTask = currentTask else { return }
        currentTask.isFinished = isFineshedCheckbox.isOn
        CoreDataStack.shared.saveContext()
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let selectedDate = dateFormatter.string(from: sender.date)
        
        guard let currentTask = currentTask else { return }
        currentTask.taskDeadline = sender.date
        CoreDataStack.shared.saveContext()
        
        dateButton.setTitle(selectedDate, for: .normal)
        deleteDateButton.isHidden = false
    }
    
    @objc func dateButtonTapped(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Выберите дату", message: "", preferredStyle: .actionSheet)
        
        let datePickerContainer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        datePickerContainer.addSubview(datePicker)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.view.addSubview(datePickerContainer)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func textViewDidChange() {
        guard let currentTask = currentTask else { return }
        placeholderLabel.isHidden = !textView.text.isEmpty
        currentTask.taskDescription = textView.text
        CoreDataStack.shared.saveContext()
    }
    
    @objc func didDeleteDateButtonTapped() {
        guard let currentTask = currentTask else { return }
        currentTask.taskDeadline = nil
        CoreDataStack.shared.saveContext()
        
        dateButton.setTitle("Установить дату выполнения", for: .normal)
        deleteDateButton.isHidden = true
    }

}
