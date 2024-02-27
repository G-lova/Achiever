//
//  WorkspaceViewController.swift
//  Achiever
//
//  Created by User on 21.02.2024.
//

import UIKit
import CoreData

class WorkspaceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userFetchedResultsController: NSFetchedResultsController<User>!
    var workspaceFetchedResultsController: NSFetchedResultsController<Workspace>!
    var boardFetchedResultsController: NSFetchedResultsController<Board>!
    
    let cellReuseIdentifier = "BoardCell"
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let workspaceLabel: UILabel = {
        let label = UILabel()
        label.text = "Рабочее пространство:"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var workspaceButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "ComplementaryTextButtonColor"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var chevronDownButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var alertTextField: UITextField?
    
//    private var newBoardTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Создать новый проект"
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//
//    private var readyButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
//        button.isHidden = true
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    private var addNewBoardButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать новый проект", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")
        
        view.addSubview(workspaceLabel)
        view.addSubview(workspaceButton)
        view.addSubview(chevronDownButton)
        view.addSubview(tableView)
//        view.addSubview(newBoardTextField)
//        view.addSubview(readyButton)
        view.addSubview(addNewBoardButton)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupWorkspaceButton()
                
        setupNavigationBar()
        setupConstraints()
        
//        newBoardTextField.delegate = self
//
//        readyButton.addTarget(self, action: #selector(didReadyButtonTapped), for: .touchUpInside)
        
        addNewBoardButton.addTarget(self, action: #selector(didAddNewButtonTapped), for: .touchUpInside)
        
        loadDataFromCoreData()
        didWorkspaceButtonTapped()
        
        
    }
    
    func setupWorkspaceButton() {
        guard let workspaces = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(Workspace.getAllWorkspaces()) else { return }
        for workspace in workspaces where "\(workspace.workspaceID)" == AuthService.shared.currentWorkspace {
            workspaceButton.setTitle("\(workspace.workspaceName)", for: .normal)
        }
        let profileViewController = UINavigationController(rootViewController: ProfileViewController())
        
        addChild(profileViewController)
        view.addSubview(profileViewController.view)
        profileViewController.didMove(toParent: self)
    
    }
    
    func setupNavigationBar() {
        
        let profilePhotoButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(photoButtonTapped))
        
        let bellButton = UIBarButtonItem(image: UIImage(systemName: "bell.badge"), style: .plain, target: self, action: #selector(bellButtonTapped))
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(backButtonTapped))
        
        self.navigationItem.leftBarButtonItem = profilePhotoButton
        self.navigationItem.rightBarButtonItems = [backButton, bellButton]
        
        guard let users = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(User.getAllUsers()) else { return }
        for user in users where "\(user.userID)" == AuthService.shared.currentUser {
//            self.navigationItem.title = user.userName
            self.navigationItem.backButtonTitle = user.userName
            
        }
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            workspaceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            workspaceLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 50),
            workspaceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            workspaceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            workspaceButton.topAnchor.constraint(equalTo: workspaceLabel.bottomAnchor, constant: 10),
            workspaceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            workspaceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            chevronDownButton.bottomAnchor.constraint(equalTo: workspaceButton.bottomAnchor),
            chevronDownButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.topAnchor.constraint(equalTo: workspaceButton.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            addNewBoardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: addNewBoardButton.topAnchor),
            addNewBoardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            addNewBoardButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
            
        ])
    }
    
    func loadDataFromCoreData() {
        // get users info
        User.loadDataFromCoreData() { [weak self] fetchedResultsController in
            self?.userFetchedResultsController = fetchedResultsController
        }
        
        // get workspaces info
        Workspace.loadDataFromCoreData() { [weak self] fetchedResultsController in
            self?.workspaceFetchedResultsController = fetchedResultsController
        }
        
        // get boards info
        Board.loadDataFromCoreData() { [weak self] fetchedResultsController in
            self?.boardFetchedResultsController = fetchedResultsController
        }
            
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func didWorkspaceButtonTapped() {
        var menuChildren: [UIMenuElement] = []
        
        guard let workspaces = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(Workspace.getAllWorkspaces()) else { return }
        
        for workspace in workspaces where "\(workspace.workspaceID)" != AuthService.shared.currentWorkspace {
            menuChildren.append(UIAction(title: "\(workspace.workspaceName)", handler: {_ in
                AuthService.shared.currentWorkspace = "\(workspace.workspaceID)"
                self.workspaceButton.setTitle("\(workspace.workspaceName)", for: .normal)
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
            }))
            menuChildren.append(UIAction(title: "----------------------", handler: {_ in
                
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
                guard let users = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(User.getAllUsers()) else { return }
                for user in users where "\(user.userID)" == AuthService.shared.currentUser {
                    let workspace = Workspace.addNewWorkspace(workspaceName: text, workspaceOwner: user) as! Workspace
                    self.workspaceButton.setTitle(workspace.workspaceName, for: .normal)
                    AuthService.shared.currentWorkspace = "\(workspace.workspaceID)"
                
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateWorkspace() {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (alertTextField) in
            
            guard let workspaces = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(Workspace.getAllWorkspaces()) else { return }
            for workspace in workspaces where "\(workspace.workspaceID)" == AuthService.shared.currentWorkspace {
                alertTextField.text = workspace.workspaceName
                self.alertTextField = alertTextField
            }
        })
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            if let text = self.alertTextField?.text {
                guard let existedWorkspaces = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(Workspace.getAllWorkspaces()) else { return }
                for workspace in existedWorkspaces where "\(workspace.workspaceID)" == AuthService.shared.currentWorkspace {
                    workspace.workspaceName = text
                    CoreDataStack.shared.saveContext()
                    AuthService.shared.currentWorkspace = "\(workspace.workspaceID)"
                    
                    self.workspaceButton.setTitle(workspace.workspaceName, for: .normal)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteWorkspace() {
        let alert = UIAlertController(title: "Вы уверены, что хотите удалить проект?", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            guard let existedWorkspaces = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(Workspace.getAllWorkspaces()) else { return }
            for workspace in existedWorkspaces where "\(workspace.workspaceID)" == AuthService.shared.currentWorkspace {
                
                CoreDataStack.shared.deleteContext(object: workspace as Workspace)
                AuthService.shared.currentWorkspace = nil
            }
            
            let profileViewController = UINavigationController(rootViewController: ProfileViewController())
            
            self.addChild(profileViewController)
            self.view.addSubview(profileViewController.view)
            profileViewController.didMove(toParent: self)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
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
    
    @objc func didAddNewButtonTapped() {
        let alert = UIAlertController(title: "Введите название проекта", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (alertTextField) in
            self.alertTextField = alertTextField
        })
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let text = self.alertTextField?.text {
                
                guard let workspaces = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(Workspace.getAllWorkspaces()),
                      let users = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(User.getAllUsers())
                else { return }
                for user in users where "\(user.userID)" == AuthService.shared.currentUser {
                    for workspace in workspaces where "\(workspace.workspaceID)" == AuthService.shared.currentWorkspace {
                        let newBoard = Board.addNewBoard(boardName: text, boardOwner: user, boardWorkspace: workspace) as! Board
                        AuthService.shared.currentBoard = "\(newBoard.boardID)"
                    }
                }
        
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                let tabBarController = TabBarController()
                self.navigationController?.pushViewController(tabBarController, animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
//    @objc func didReadyButtonTapped() {
//        guard let boardName = newBoardTextField.text,
//              let workspaces = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(Workspace.getAllWorkspaces()),
//              let users = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(User.getAllUsers())
//        else { return }
//        for user in users where "\(user.userID)" == AuthService.shared.currentUser {
//            for workspace in workspaces where "\(workspace.workspaceID)" == AuthService.shared.currentWorkspace {
//                let newBoard = Board.addNewBoard(boardName: boardName, boardOwner: user, boardWorkspace: workspace) as! Board
//                AuthService.shared.currentBoard = "\(newBoard.boardID)"
//            }
//        }
//
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//        let tabBarController = TabBarController()
//        navigationController?.pushViewController(tabBarController, animated: true)
//    }
    
    //MARK: - UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        readyButton.isHidden = false
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Проекты"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardFetchedResultsController.sections?[section].numberOfObjects ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellReuseIdentifier)
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if let board = boardFetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = board.boardName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let board = boardFetchedResultsController?.object(at: indexPath) {
            AuthService.shared.currentBoard = "\(board.boardID))"
            
            let tabBarController = TabBarController()
            navigationController?.pushViewController(tabBarController, animated: true)
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//
//        let stackView = UIStackView(arrangedSubviews: [newBoardTextField, readyButton])
//        stackView.axis = .horizontal
//        stackView.alignment = .center
//        stackView.distribution = .fill
//        return stackView
//    }
    
    
    
}
