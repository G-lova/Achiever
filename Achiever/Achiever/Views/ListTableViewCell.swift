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
    
    private var stackView: UIStackView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        stackView = UIStackView(arrangedSubviews: [clockImageView, timerLabel])
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
        stackView.setCustomSpacing(0, after: clockImageView)
        contentView.addSubview(stackView)
        
    }
    
    func setupTableView(taskName: String, taskDeadline: Date?, isFinished: Bool) {
        let attributedString = NSAttributedString(string: "\(taskName)", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        taskNameLabel.text = taskName
        if isFinished {
            taskNameLabel.attributedText = attributedString
            taskNameLabel.textColor = .gray
        }
        if let taskDeadline = taskDeadline {
            stackView.isHidden = false
            clockImageView.isHidden = false
            timerLabel.text = "\(taskDeadline)"
        } else {
            stackView.isHidden = true
        }
        
    }
}
