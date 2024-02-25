//
//  BoardViewController.swift
//  Achiever
//
//  Created by User on 23.02.2024.
//

import UIKit
import CoreData


class BoardViewController: UICollectionViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    var fetchedResultsController: NSFetchedResultsController<User>!
    let currentUser = AuthService.shared.currentUser
    var currentBoard = AuthService.shared.currentBoard
    var userWorkspaces: [Workspace] = []
    var boards: [Board] = []
    var boardLists: [List] = []

    private let reuseIdentifier = "BoardCell"
    
    private var alertTextField: UITextField?
    
    private var workspacePickerView: UIPickerView!
    
    private let boardButton: UIButton = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        loadDataFromCoreData()
    }
    
    func setupViews() {
        setupCollectionView()
        setupNavigationBar()
        setupPickerView()
        
        setupConstraints()
    }
    
    func setupCollectionView() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .estimated(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(view.frame.size.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: boardLists.count)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "ViewBackgroundColor")
        // Register cell classes
        collectionView.register(BoardCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView = collectionView
    }
    
    func setupNavigationBar() {
        
        // Set up navigation bar
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(menuButtonTapped))
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
//        let filterButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(filterButtonTapped))
        self.navigationItem.backBarButtonItem = menuButton
//        self.navigationItem.rightBarButtonItems = [filterButton, searchButton]
        self.navigationItem.rightBarButtonItems = [searchButton]
        
        let boardButton = UIButton()
        if let currentBoard = currentBoard {
            boardButton.setTitle("\(currentBoard.boardName)", for: .normal)
        } else {
            let workspaceViewController = WorkspaceViewController()
            
            addChild(workspaceViewController)
            view.addSubview(workspaceViewController.view)
            workspaceViewController.didMove(toParent: self)
        }
        let shevronButton = UIButton()
        shevronButton.setImage(UIImage(systemName: "shevron.down"), for: .normal)
        
//        let mindMapIcon = UIButton()
//        mindMapIcon.setImage(UIImage(systemName: "doc.text.magnifyingglass"), for: .normal)
//        let ganttIcon = UIButton()
//        ganttIcon.setImage(UIImage(systemName: "chart.bar"), for: .normal)
//
        let stackView = UIStackView(arrangedSubviews: [boardButton, shevronButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        self.navigationItem.titleView = stackView
        
        // Setup menu
        var menuChildren: [UIMenuElement] = []
        
        for board in self.boards where board != currentBoard {
            menuChildren.append(UIAction(title: "\(board.boardName)", handler: {_ in
                AuthService.shared.currentBoard = board
                boardButton.setTitle("\(board.boardName)", for: .normal)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }))
            menuChildren.append(UIAction(title: "-------------------", handler: {_ in
                print()
            }))
            menuChildren.append(UIAction(title: "Создать проект", handler: {_ in
                self.addBoard()
            }))
            menuChildren.append(UIAction(title: "Редактировать проект", handler: {_ in
                self.updateBoard()
            }))
            menuChildren.append(UIAction(title: "Переместить проект", handler: {_ in
                self.replaceBoard()
            }))
            menuChildren.append(UIAction(title: "Удалить проект", handler: {_ in
                self.deleteBoard()
            }))
            
            let menu = UIMenu(title: "", children: menuChildren)
            boardButton.menu = menu
            shevronButton.menu = menu
        }
    }
    
    func setupPickerView() {
        workspacePickerView.dataSource = self
        workspacePickerView.delegate = self
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            boardButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            boardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            boardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            chevronDownButton.bottomAnchor.constraint(equalTo: boardButton.bottomAnchor),
            chevronDownButton.trailingAnchor.constraint(equalTo: boardButton.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: boardButton.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 5)
        ])
    }
    
    func loadDataFromCoreData() {
        User.loadDataFromCoreData() { [weak self] fetchedResultsController in
            self?.fetchedResultsController = fetchedResultsController
            self?.getUserWorkspaces()
            self?.getWorkspaceBoards()
            self?.getBoardLists()
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func getUserWorkspaces() {
        guard let users = fetchedResultsController.fetchedObjects else { return }
        for user in users where user == self.currentUser {
            guard let workspaces = user.userWorkspaces else { return }
            for workspace in workspaces {
                self.userWorkspaces.append(workspace as! Workspace)
            }
        }
    }
    
    func getWorkspaceBoards() {
        for workspace in userWorkspaces where workspace == currentBoard?.boardWorkspace {
            guard let boards = workspace.workspaceBoards else { return }
            for board in boards {
                self.boards.append(board as! Board)
            }
        }
    }
    
    func getBoardLists() {
        for board in boards where board == self.currentBoard {
            guard let lists = board.boardLists else { return }
            for list in lists {
                self.boardLists.append(list as! List)
            }
        }
    }
    
    func addBoard() {
        let alert = UIAlertController(title: "Введите название проекта", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (alertTextField) in
            self.alertTextField = alertTextField
        })
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let text = self.alertTextField?.text {
                guard let currentBoard = self.currentBoard, let user = self.currentUser else { return }
                let board = Board.addNewBoard(boardName: text, boardOwner: user, boardWorkspace: currentBoard.boardWorkspace) as! Board
                self.boardButton.setTitle(board.boardName, for: .normal)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
    }
    
    func updateBoard() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (alertTextField) in
            guard let board = self.currentBoard else { return }
            alertTextField.text = board.boardName
            self.alertTextField = alertTextField
        })
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            guard let text = self.alertTextField?.text else { return }
            let existedBoards = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(Board.getAllBoards())
            if let existedBoards = existedBoards {
                for board in existedBoards where board == self.currentBoard {
                    board.boardName = text
                    CoreDataStack.shared.saveContext()
                    AuthService.shared.currentBoard = board
                    self.boardButton.setTitle(board.boardName, for: .normal)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
    }
    
    func replaceBoard() {
        let alert = UIAlertController(title: "Выберите пространство", message: "", preferredStyle: .actionSheet)
        
        let workspacePickerContainer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        workspacePickerContainer.addSubview(workspacePickerView)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.view.addSubview(workspacePickerContainer)
        present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    func deleteBoard() {
        let alert = UIAlertController(title: "Вы уверены, что хотите удалить проект?", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            guard let board = self.currentBoard else { return }
            CoreDataStack.shared.deleteContext(object: board as Board)
            
            AuthService.shared.currentBoard = nil
            
            let workspaceViewController = WorkspaceViewController()
            
            self.addChild(workspaceViewController)
            self.view.addSubview(workspaceViewController.view)
            workspaceViewController.didMove(toParent: self)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
    }
    
    // MARK: - Button Actions
    
    @objc func menuButtonTapped() {
        
        let animation = CATransition()
        animation.duration = 0.5
        animation.type = .push
        animation.subtype = .fromRight
        
        navigationController?.view.layer.add(animation, forKey: nil)
        navigationController?.pushViewController(WorkspaceViewController(), animated: false)
    }
    
//    @objc func filterButtonTapped() {
//        // Show filter menu from right to left
//    }
    
    @objc func searchButtonTapped() {
        // Show search screen from right to left
    }
    
    @objc func boardButtonTapped() {
        // Show menu
    }
    

    // MARK: UICollectionViewDataSource, UICollectionViewDelegate

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boardLists.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BoardCollectionViewCell
        
        let list = boardLists[indexPath.row]
        cell.setupCollectionView(list: list, controller: self)
    
        return cell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userWorkspaces.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userWorkspaces[row].workspaceName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedWorkspace = userWorkspaces[row]
        boardButton.setTitle(selectedWorkspace.workspaceName, for: .normal)
        let existedBoards = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(Board.getAllBoards())
        if let existedBoards = existedBoards {
            for board in existedBoards where board == currentBoard {
                board.boardWorkspace = selectedWorkspace
                CoreDataStack.shared.saveContext()
                AuthService.shared.currentBoard = board
            }
        }
    }

}
