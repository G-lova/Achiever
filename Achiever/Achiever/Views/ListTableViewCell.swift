//
//  ListTableViewCell.swift
//  Achiever
//
//  Created by User on 23.02.2024.
//

import UIKit

class ListTableViewCell: UITableViewCell  {
    
    private var taskNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "PrimaryTextLabelColor")
        return label
    }()
    
    private var clockImageView = UIImageView(image: UIImage(systemName: "clock"))
    
    private var timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "PrimaryTextLabelColor")
        return label
    }()
    
    private var textImageView = UIImageView(image: UIImage(systemName: "text"))
    
    private var checkboxImageView = UIImageView(image: UIImage(systemName: "checkbox"))
    
    private var stackView: UIStackView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        stackView = UIStackView(arrangedSubviews: [clockImageView, timerLabel, textImageView, checkboxImageView])
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        tableView = nil
//    }
 
    func setupViews() {
        contentView.addSubview(taskNameLabel)
        setupStack()
    }
    
    func setupStack() {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.setCustomSpacing(0, after: textImageView)
        contentView.addSubview(stackView)
        
    }
    
    func setupTableView(taskName: String) {
        taskNameLabel.text = taskName
        
    }
}
