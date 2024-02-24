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
    
    
    private let profilePhotoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "AccentButtonBackgroundColor")
        button.setImage(UIImage(systemName: "person"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
//        label.text = user.userName
        label.textColor = UIColor(named: "PrimaryTextLabelColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bellButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bell.badge"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
    
    private let shevronDownButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let boardLabel: UILabel = {
        let label = UILabel()
        label.text = "Проекты:"
        label.textColor = UIColor(named: "PrimaryTextLabelColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        contentView.addSubview(nameLabel)
        contentView.addSubview(bellButton)
        contentView.addSubview(workspaceLabel)
        contentView.addSubview(workspaceButton)
        contentView.addSubview(shevronDownButton)
        contentView.addSubview(boardLabel)
        contentView.addSubview(boardTableView)
        contentView.addSubview(newBoardTextField)
        contentView.addSubview(readyButton)
        
        nameLabel.text = "\(user.userName)"
        workspaceButton.setTitle("\(activeWorkspace.workspaceName)", for: .normal)
                
        setupConstraints()
        
        boardTableView.dataSource = self
        boardTableView.delegate = self
        newBoardTextField.delegate = self
        
        loadDataFromCoreData()
        didWorkspaceButtonTapped()
        
        readyButton.addTarget(self, action: #selector(didReadyButtonTapped), for: .touchUpInside)
        
    }
    
    func setupConstraints() {
        boardTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profilePhotoButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            profilePhotoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profilePhotoButton.widthAnchor.constraint(equalToConstant: 50),
            profilePhotoButton.heightAnchor.constraint(equalTo: profilePhotoButton.widthAnchor),
            nameLabel.topAnchor.constraint(equalTo: profilePhotoButton.topAnchor, constant: 20),
            nameLabel.heightAnchor.constraint(equalTo: profilePhotoButton.heightAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profilePhotoButton.trailingAnchor, constant: 10),
            bellButton.topAnchor.constraint(equalTo: profilePhotoButton.topAnchor),
            bellButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            workspaceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            workspaceLabel.topAnchor.constraint(equalTo: profilePhotoButton.bottomAnchor, constant: 20),
            workspaceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            workspaceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            workspaceButton.topAnchor.constraint(equalTo: workspaceLabel.bottomAnchor, constant: 10),
            workspaceButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            workspaceButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            shevronDownButton.topAnchor.constraint(equalTo: workspaceButton.topAnchor),
            shevronDownButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            boardLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            boardLabel.topAnchor.constraint(equalTo: workspaceButton.bottomAnchor, constant: 20),
            boardLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            boardLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            boardTableView.topAnchor.constraint(equalTo: boardLabel.bottomAnchor, constant: 10),
            boardTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            boardTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            newBoardTextField.topAnchor.constraint(equalTo: boardTableView.bottomAnchor),
            newBoardTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            newBoardTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            readyButton.topAnchor.constraint(equalTo: boardTableView.bottomAnchor),
            readyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
            
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
            let workspaces = user.userWorkspaces
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
            menuChildren.append(UIAction(title: "Создать новое пространство", handler: {_ in
                
            }))
            
            let menu = UIMenu(title: "", children: menuChildren)
            workspaceButton.menu = menu
            shevronDownButton.menu = menu
        }
                
//        if let menuViewController = menu.menuViewController {
//            menuViewController.modalPresentationStyle = .popover
//            menuViewController.popoverPresentationController?.sourceView = workspaceButton
//            menuViewController.popoverPresentationController?.sourceRect = workspaceButton.bounds
//            present(menuViewController, animated: true, completion: nil)
//        }
    }
    
    @objc func didReadyButtonTapped() {
        guard let boardName = newBoardTextField.text else { return }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userWorkspaces.count
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
    
}
