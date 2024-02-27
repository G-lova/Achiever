//
//  BoardViewController.swift
//  Achiever
//
//  Created by User on 23.02.2024.
//

import UIKit
import CoreData


class BoardViewController: UICollectionViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    var userFetchedResultsController: NSFetchedResultsController<User>!
    var workspaceFetchedResultsController: NSFetchedResultsController<Workspace>!
    var boardFetchedResultsController: NSFetchedResultsController<Board>!
    var listFetchedResultsController: NSFetchedResultsController<List>!
    
    var userWorkspaces: [Workspace?] = []

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
        guard let boards = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(Board.getAllBoards()) else { return }
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: boards.count)
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
        guard let boards = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(Board.getAllBoards()) else {
            let workspaceViewController = WorkspaceViewController()
            
            addChild(workspaceViewController)
            view.addSubview(workspaceViewController.view)
            workspaceViewController.didMove(toParent: self)
            return
        }
        for board in boards where "\(board.boardID)" == AuthService.shared.currentBoard {
            boardButton.setTitle("\(board.boardName)", for: .normal)
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
        
        for board in boards where "\(board.boardID)" != AuthService.shared.currentBoard {
            menuChildren.append(UIAction(title: board.boardName, handler: {_ in
                AuthService.shared.currentBoard = "\(board.boardID)"
                boardButton.setTitle(board.boardName, for: .normal)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }))
            menuChildren.append(UIAction(title: "--------------------", handler: {_ in
                
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
            boardButton.showsMenuAsPrimaryAction = true
            shevronButton.showsMenuAsPrimaryAction = true
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
        // get users
        User.loadDataFromCoreData() { [weak self] fetchedResultsController in
            self?.userFetchedResultsController = fetchedResultsController
        }
        // get workspaces
        Workspace.loadDataFromCoreData() { [weak self] fetchedResultsController in
            self?.workspaceFetchedResultsController = fetchedResultsController
        }
        // get boards
        Board.loadDataFromCoreData() { [weak self] fetchedResultsController in
            self?.boardFetchedResultsController = fetchedResultsController
        }
        // get lists
        List.loadDataFromCoreData() { [weak self] fetchedResultsController in
            self?.listFetchedResultsController = fetchedResultsController
        }
        getUserWorkspaces()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func getUserWorkspaces() {
        guard let users = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(User.getAllUsers()) else { return }
        for user in users where "\(user.userID)" == AuthService.shared.currentUser {
            guard let workspaces = user.userWorkspaces else { return }
            for workspace in workspaces {
                self.userWorkspaces.append(workspace as? Workspace)
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
                guard let workspaces = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(Workspace.getAllWorkspaces()),
                      let users = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(User.getAllUsers())
                else { return }
                for user in users where "\(user.userID)" == AuthService.shared.currentUser {
                    for workspace in workspaces where "\(workspace.workspaceID)" == AuthService.shared.currentWorkspace {
                        let newBoard = Board.addNewBoard(boardName: text, boardOwner: user, boardWorkspace: workspace) as! Board
                        AuthService.shared.currentBoard = "\(newBoard.boardID)"
                        self.boardButton.setTitle(newBoard.boardName, for: .normal)
                    }
                }
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
        guard let boards = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(Board.getAllBoards()) else { return }
        for board in boards where "\(board.boardID)" == AuthService.shared.currentBoard {
            
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (alertTextField) in
                    alertTextField.text = board.boardName
                    self.alertTextField = alertTextField
                
            })
        
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    guard let text = self.alertTextField?.text else { return }
                    board.boardName = text
                    CoreDataStack.shared.saveContext()
                    AuthService.shared.currentBoard = "\(board.boardID)"
                    self.boardButton.setTitle(board.boardName, for: .normal)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
            }
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
        }
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
            
            guard let boards = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(Board.getAllBoards()) else { return }
            for board in boards where "\(board.boardID)" == AuthService.shared.currentBoard {
                CoreDataStack.shared.deleteContext(object: board as Board)
                
                AuthService.shared.currentBoard = nil
                
                let workspaceViewController = WorkspaceViewController()
                
                self.addChild(workspaceViewController)
                self.view.addSubview(workspaceViewController.view)
                workspaceViewController.didMove(toParent: self)
            }
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
        return listFetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BoardCollectionViewCell
        
        if let list = listFetchedResultsController?.object(at: indexPath)  {
            cell.setupCollectionView(list: list, controller: self)
        }
        return cell
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.userWorkspaces.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.userWorkspaces[row]?.workspaceName
                
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedWorkspace = self.userWorkspaces[row]
        boardButton.setTitle(selectedWorkspace?.workspaceName, for: .normal)
        if let existedBoards = try? CoreDataStack.shared.persistentContainer.viewContext.fetch(Board.getAllBoards()) {
            for board in existedBoards where "\(board.boardID)" == AuthService.shared.currentBoard {
                board.boardWorkspace = selectedWorkspace!
                CoreDataStack.shared.saveContext()
                AuthService.shared.currentBoard = "\(board.boardID)"
            }
        }
    }

}
