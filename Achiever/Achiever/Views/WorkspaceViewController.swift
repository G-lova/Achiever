//
//  WorkspaceViewController.swift
//  Achiever
//
//  Created by User on 21.02.2024.
//

import UIKit
import CoreData

class WorkspaceViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var fetchedResultController: NSFetchedResultsController<User>!
    var user = AuthService.shared.currentUser
    var activeWorkspace = AuthService.shared.currentWorkspace
    var userWorkspaces: [Workspace] = []
    var workspaceBoards: [Board] = []
    
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
    
    private let workspaceLabel: UILabel = {
        let label = UILabel()
        label.text = "Рабочее пространство:"
        label.textColor = UIColor(named: "PrimaryTextLabelColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let workspaceButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "PrimaryTextLabelColor"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let chevronDownButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var alertTextField: UITextField?
    
    private let boardTableView = UITableView(frame: .zero, style: .plain)
    
    private let newBoardTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Создать новый проект"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let readyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(workspaceLabel)
        contentView.addSubview(workspaceButton)
        contentView.addSubview(chevronDownButton)
        contentView.addSubview(boardTableView)
        
        if let activeWorkspace = activeWorkspace {
            workspaceButton.setTitle("\(activeWorkspace.workspaceName)", for: .normal)
        } else {
            let profileViewController = ProfileViewController()
            
            addChild(profileViewController)
            view.addSubview(profileViewController.view)
            profileViewController.didMove(toParent: self)
        }
                
        setupNavigationBar()
        setupConstraints()
        
        boardTableView.dataSource = self
        boardTableView.delegate = self
        newBoardTextField.delegate = self
        
        readyButton.addTarget(self, action: #selector(didReadyButtonTapped), for: .touchUpInside)
        
        loadDataFromCoreData()
        didWorkspaceButtonTapped()
        
        
    }
    
    func setupNavigationBar() {
        
        let profilePhotoButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = UIColor(named: "AccentButtonBackgroundColor")
            button.setImage(UIImage(systemName: "person.fill"), for: .normal)
            button.layer.cornerRadius = button.frame.size.width / 2
            button.layer.masksToBounds = true
            return button
        }()
        
        let nameButton: UIButton = {
            let button = UIButton()
            button.setTitleColor(UIColor(named: "PrimaryTextLabelColor"), for: .normal)
            if let user = user {
                button.setTitle("\(user.userName)", for: .normal)
            }
            return button
        }()
        
        profilePhotoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        
        nameButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        
        let stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [profilePhotoButton, nameButton])
            stackView.axis = .horizontal
            stackView.alignment = .center
            return stackView
        }()
        
        let bellButton = UIBarButtonItem(image: UIImage(systemName: "bell.badge"), style: .plain, target: self, action: #selector(bellButtonTapped))
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(backButtonTapped))
        
        self.navigationItem.backBarButtonItem?.accessibilityElementsHidden = true
        self.navigationItem.leftBarButtonItem?.customView = stackView
        self.navigationItem.rightBarButtonItems = [bellButton, backButton]
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        boardTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            workspaceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            workspaceLabel.topAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 20),
            workspaceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            workspaceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            workspaceButton.topAnchor.constraint(equalTo: workspaceLabel.bottomAnchor, constant: 10),
            workspaceButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            workspaceButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            chevronDownButton.topAnchor.constraint(equalTo: workspaceButton.topAnchor),
            chevronDownButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            boardTableView.topAnchor.constraint(equalTo: workspaceButton.bottomAnchor, constant: 10),
            boardTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            boardTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            boardTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10)
            
        ])
    }
    
    func loadDataFromCoreData() {
        User.loadDataFromCoreData() { [weak self] fetchedResultController in
            self?.fetchedResultController = fetchedResultController
            self?.getUserWorkspaces()
            self?.getWorkspaceBoards()
            DispatchQueue.main.async {
                self?.boardTableView.reloadData()
            }
        }
    }
    
    func getUserWorkspaces() {
        guard let users = fetchedResultController.fetchedObjects else { return }
        for user in users where user == self.user {
            guard let workspaces = user.userWorkspaces else { return }
            for workspace in workspaces {
                self.userWorkspaces.append(workspace as! Workspace)
            }
        }
    }
    
    func getWorkspaceBoards() {
        for workspace in userWorkspaces where workspace == activeWorkspace {
            guard let boards = workspace.workspaceBoards else { return }
            for board in boards {
                self.workspaceBoards.append(board as! Board)
            }
        }
    }
    
    func didWorkspaceButtonTapped() {
        var menuChildren: [UIMenuElement] = []
        
        for workspace in self.userWorkspaces where workspace != activeWorkspace {
            menuChildren.append(UIAction(title: "\(workspace.workspaceName)", handler: {_ in
                AuthService.shared.currentWorkspace = workspace
                self.workspaceButton.setTitle("\(workspace.workspaceName)", for: .normal)
                DispatchQueue.main.async {
                    self.boardTableView.reloadData()
                }
            }))
            menuChildren.append(UIAction(title: "----------------------", handler: {_ in
                print()
            }))
            menuChildren.append(UIAction(title: "Создать пространство", handler: {_ in
                self.addWorkspace()
            }))
            menuChildren.append(UIAction(title: "Редактировать пространство", handler: {_ in
                self.updateWorkspace()
            }))
            menuChildren.append(UIAction(title: "Удалить пространство", handler: {_ in
                self.deleteWorkspace()
            }))
            
            let menu = UIMenu(title: "", children: menuChildren)
            workspaceButton.menu = menu
            chevronDownButton.menu = menu
            
            workspaceButton.showsMenuAsPrimaryAction = true
            chevronDownButton.showsMenuAsPrimaryAction = true
        }
    }
    
    func addWorkspace() {
        let alert = UIAlertController(title: "Введите название пространства", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (alertTextField) in
            self.alertTextField = alertTextField
        })
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let text = self.alertTextField?.text {
                guard let user = self.user else { return }
                let workspace = Workspace.addNewWorkspace(workspaceName: text, workspaceOwner: user) as! Workspace
                self.workspaceButton.setTitle(workspace.workspaceName, for: .normal)
                DispatchQueue.main.async {
                    self.boardTableView.reloadData()
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
    }
    
    func updateWorkspace() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (alertTextField) in
            guard let workspace = self.activeWorkspace else { return }
            alertTextField.text = workspace.workspaceName
            self.alertTextField = alertTextField
        })
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let text = self.alertTextField?.text {
                guard let workspace = self.activeWorkspace else { return }
                workspace.workspaceName = text
                CoreDataStack.shared.saveContext()
                AuthService.shared.currentWorkspace = workspace
                self.activeWorkspace = AuthService.shared.currentWorkspace
                self.workspaceButton.setTitle(workspace.workspaceName, for: .normal)
                DispatchQueue.main.async {
                    self.boardTableView.reloadData()
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
    }
    
    func deleteWorkspace() {
        let alert = UIAlertController(title: "Вы уверены, что хотите удалить проект?", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            guard let workspace = self.activeWorkspace else { return }
            CoreDataStack.shared.deleteContext(object: workspace as Workspace)
            
            AuthService.shared.currentWorkspace = nil
            
            let profileViewController = ProfileViewController()
            
            self.addChild(profileViewController)
            self.view.addSubview(profileViewController.view)
            profileViewController.didMove(toParent: self)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
    }
    
    @objc func photoButtonTapped() {
        navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    @objc func bellButtonTapped() {
        navigationController?.pushViewController(NotificationsViewController(), animated: true)
    }
    
    @objc func backButtonTapped() {
        let animation = CATransition()
        animation.duration = 0.5
        animation.type = .push
        animation.subtype = .fromLeft
        
        navigationController?.view.layer.add(animation, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func didReadyButtonTapped() {
        guard let boardName = newBoardTextField.text, let user = user, let activeWorkspace = activeWorkspace else { return }
        let _ = Board.addNewBoard(boardName: boardName, boardOwner: user, boardWorkspace: activeWorkspace)
        DispatchQueue.main.async {
            self.boardTableView.reloadData()
        }
        let tabBarController = TabBarController()
        navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        readyButton.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Проекты"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workspaceBoards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let board = workspaceBoards[indexPath.row]
        cell.textLabel?.text = board.boardName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AuthService.shared.currentBoard = workspaceBoards[indexPath.row]
        
        let tabBarController = TabBarController()
        navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let stackView = UIStackView(arrangedSubviews: [newBoardTextField, readyButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }
    
}
