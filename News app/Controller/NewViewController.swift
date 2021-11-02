//
//  ViewController.swift
//  News app
//
//  Created by Amrit Tiwari on 03/11/2021.
//


import UIKit

class NewViewController: UIViewController {

    private var newsTableView = UITableView()
    private let newsCellIdentifier = "newsCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // retrieve status bar height
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        let viewControllerWidth: CGFloat = self.view.frame.width
        let viewControllerHeight: CGFloat = self.view.frame.height
        
        // assigning tableview frame
        self.newsTableView = UITableView(frame: CGRect(x: 0, y: statusHeight, width: viewControllerWidth, height: viewControllerHeight - statusHeight))
        
        // register cell in tableview
        self.newsTableView.register(UITableViewCell.self, forCellReuseIdentifier: self.newsCellIdentifier)
        
        self.newsTableView.dataSource = self
        self.newsTableView.delegate = self
        
        self.view.addSubview(self.newsTableView)

    }
}

extension NewViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: self.newsCellIdentifier, for: indexPath as IndexPath)
        
        cell.textLabel!.text = "\(indexPath.row)"
        
        return cell
        
    }
    
   
    
    
}

    
