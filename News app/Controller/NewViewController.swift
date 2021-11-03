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
    
    private var articles : [Articles]?
    
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
        self.newsTableView.register(NewsTVCell.self, forCellReuseIdentifier: self.newsCellIdentifier)
        
        self.newsTableView.dataSource = self
        self.newsTableView.delegate = self
        
        self.view.addSubview(self.newsTableView)

        self.getNews(1)
    }
}

extension NewViewController{
    
    private func getNews(_ pageNumber : Int){
        
        let apiKey = Constants.Keys.news
        
    //https://newsapi.org/v2/everything?q=bitcoin&page=2&apiKey=de8ee8412f144e0d914f6fdac9360a87
        
        let url = Urls.news + "&page=\(pageNumber)" + "&apiKey=" + apiKey
        
        APIManager.init(.withoutHeader, urlString: url, method: .get).handleResponse(viewController: self, loadingOnView: self.view, withLoadingColor: .app, completionHandler: { [weak self] (response : NewsModel) in
            guard let `self` = self else { return }
            
            guard let result = response.articles else {
                let message = response.message ?? Errors.Apis.serverError
                self.presentErrorDialog(message)
                return
            }
            
            self.articles = result
            self.newsTableView.reloadData()
            
            }, errorBlock: { [weak self] (error) in
                guard let `self` = self else { return }
                
                let message = error.message ?? Errors.Apis.serverError
                self.presentErrorDialog(message)
        
        }) { (error) in
            print(error)
        }
    }
}

extension NewViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: self.newsCellIdentifier) as! NewsTVCell
        
        let article = self.articles?[indexPath.row]
        
        cell.lblNewsTitle.text = article?.title
        cell.lblNewsDescription.text = article?.descriptionss?.stripOutHtml()
        cell.ivNews.setURLImage(article?.urlToImage, andPlaceHolderImage: self.placeholderSmallImage())
        
        return cell
        
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 1000
    }
}

    
