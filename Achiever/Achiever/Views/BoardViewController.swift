//
//  BoardViewController.swift
//  Achiever
//
//  Created by User on 23.02.2024.
//

import UIKit
import CoreData


class BoardViewController: UICollectionViewController {
    
    let currentBoard = AuthService.shared.currentBoard
    var fetchedResultsController: NSFetchedResultsController<Board>!
    var boards: [Board] = []
    var boardLists: [List] = []

    private let reuseIdentifier = "BoardCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        loadDataFromCoreData()
    }
    
    func setupViews() {
        setupCollectionView()
        setupNavigationBar()
        
        setupConstraints()
    }
    
    func setupCollectionView() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
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
        let filterButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(filterButtonTapped))
        self.navigationItem.backBarButtonItem = menuButton
        self.navigationItem.rightBarButtonItems = [filterButton, searchButton]
        
        let boardButton = UIButton()
        boardButton.setTitle("\(currentBoard.boardName)", for: .normal)
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
            menuChildren.append(UIAction(title: "Создать новый проект", handler: {_ in
                
            }))
            
            let menu = UIMenu(title: "", children: menuChildren)
            boardButton.menu = menu
            shevronButton.menu = menu
        }
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 10)
        ])
    }
    
    func loadDataFromCoreData() {
        Board.loadDataFromCoreData() { [weak self] fetchedResultController in
            self?.fetchedResultsController = fetchedResultController
            self?.getBoardLists()
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func getBoardLists() {
        guard let boards = fetchedResultsController.fetchedObjects else { return }
        self.boards = boards
        for board in boards where board == self.currentBoard {
            guard let lists = board.boardLists else { return }
            for list in lists {
                self.boardLists.append(list as! List)
            }
        }
    }
    
    // MARK: - Button Actions
    
    @objc func menuButtonTapped() {
        // Show new screen from left to right
    }
    
    @objc func filterButtonTapped() {
        // Show filter menu from right to left
    }
    
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
    

}
