//
//  MainTabBarController.swift
//  Todo List
//
//  Created by gongzhen on 7/29/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    let tabPressedImages = ["Tabs-Groups-Pressed", "Tabs-Finished-Pressed", "Tabs-Finished-Pressed"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = ColorUtils.systemGreen()
        for (index, tabBarItem) in (self.tabBar.items!).enumerate() {
            (tabBarItem ).selectedImage = UIImage(named: tabPressedImages[index])?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
