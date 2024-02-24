//
//  TabBarController.swift
//  Achiever
//
//  Created by User on 24.02.2024.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let boardViewController = UINavigationController(rootViewController: BoardViewController())
        let calendarViewController = UINavigationController(rootViewController: CalendarViewController())
        
        let image = UIImage(systemName: "chart.bar.doc.horizontal")
        image?.imageFlippedForRightToLeftLayoutDirection()
        boardViewController.tabBarItem.image = image
        calendarViewController.tabBarItem.image = UIImage(systemName: "calendar")
        
        
        
        viewControllers = [boardViewController, calendarViewController]
        
    }
    


}
