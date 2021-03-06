//
//  ViewController.swift
//  News app
//
//  Created by Amrit Tiwari on 03/11/2021.
//


import UIKit


class NewsViewController: UIViewController {
    
    private var newsTableView = UITableView()
    private let newsCellIdentifier = "NewsTVCell"
    private let newsLoadingCellIdentifier = "NewsLoadingTVCell"
    
    private var articleResult : NewsModel?
    
    private var isDatafectching = false //this is use to news currently fetching state
    
    private let refreshControl = UIRefreshControl()
    
    private let errorView = ErrorView.init(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.addTableView()
        self.getNews(1, isShowLoadingView: true, isDragPullToRefresh: false, isFromPagination: false)
        
        self.pullToRefreshAdd()
    }
    
    
    private func addTableView(){
        
        // retrieve status bar height
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        let viewControllerWidth: CGFloat = self.view.frame.width
        let viewControllerHeight: CGFloat = self.view.frame.height
        
        // assigning tableview frame
        self.newsTableView = UITableView(frame: CGRect(x: 0, y: statusHeight, width: viewControllerWidth, height: viewControllerHeight - statusHeight))
        
        // register cell in tableview
        self.newsTableView.register(NewsTVCell.self, forCellReuseIdentifier: self.newsCellIdentifier)
        
        self.newsTableView.register(NewsLoadingTVCell.self, forCellReuseIdentifier: self.newsLoadingCellIdentifier)
        
        self.newsTableView.dataSource = self
        self.newsTableView.delegate = self
        
        self.view.addSubview(self.newsTableView)
    }
    
    private func addErrroView(_ errorMessage : String){
        
        self.errorView.frame = self.view.frame
        self.errorView.center = self.view.center
        
        self.view.addSubview(self.errorView)
        
        self.errorView.lblErrorTitle.text = errorMessage
        
        self.errorView.btnRetry.addTarget(self, action: #selector(self.btnRetryTouched), for: .touchUpInside)
        
    }
    
    @objc private func btnRetryTouched(){
        
        self.errorView.removeFromSuperview()
        self.getNews(1, isShowLoadingView: true, isDragPullToRefresh: false, isFromPagination: false)
        
    }
    
    private func pullToRefreshAdd(){
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: #selector(self.dragRefresh(_:)), for: .valueChanged)
        self.newsTableView.addSubview(self.refreshControl)
    }
    
    
    @objc func dragRefresh(_ sender: AnyObject) {
        
        self.getNews(1, isShowLoadingView: true, isDragPullToRefresh: true, isFromPagination: false)
        
    }
}

extension NewsViewController{
    
    private func getNews(_ pageNumber : Int, isShowLoadingView loadView : Bool, isDragPullToRefresh pullToRefresh: Bool, isFromPagination isPagination: Bool){
        
        let apiKey = Constants.Keys.news
        
        let url = Urls.news + "&page=\(pageNumber)" + "&apiKey=" + apiKey
        
        print("Url = " + url)
        
        ServiceManager.init(url, withParameter: nil, method: .get, isKillAllSession: false).fetchArrayResponse(viewController: self, loadingOnView: self.view, isShowProgressHud: true, isShowNoNetBanner: true, isShowAlertBanner: true) {[weak self] (data) in
            guard let `self` = self else { return }
            
            do{
                let response = try JSONDecoder().decode(NewsModel.self, from: data)
                
                if pullToRefresh{
                    self.refreshControl.endRefreshing()
                }
                
                self.isDatafectching = false
                
                
                if pageNumber == 1{
                    self.articleResult = response
                }else{
                    // add the new news on the old news array
                    if let newResponse = response.articles{
                        self.articleResult?.articles?.append(contentsOf: newResponse)
                    }
                }
                
                // increase the page number for pagination news
                self.articleResult?.nextPage = pageNumber + 1
                
                self.newsTableView.reloadData()
            }catch let jsonErr {
                print("Failed to decode:", jsonErr)
                
            }
        } errorBlock: { [weak self] (dataError) in
            guard let `self` = self else { return }
            
            if pullToRefresh{
                self.refreshControl.endRefreshing()
            }
            
            self.isDatafectching = false
            
            if !isPagination{
                self.addErrroView("Error occur")
            }
        } failureBlock:{ [weak self] (error) in
            guard let `self` = self else { return }
            
            if pullToRefresh{
                self.refreshControl.endRefreshing()
            }
            
            self.isDatafectching = false
            
            if !isPagination{
                self.addErrroView(error)
            }
        }
    }
    
    
    private func paginationFetchData(){
        let pageNumber = self.articleResult?.nextPage ?? 0
        
        self.getNews(pageNumber, isShowLoadingView: false, isDragPullToRefresh: false, isFromPagination: true)
    }
}

extension NewsViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let articleResult = self.articleResult else { return 0}
        
        if self.isDatafectching {
            return 1
        }
        
        let currentPage = articleResult.currentPage
        let lastPage = articleResult.nextPage
        
        if (currentPage < lastPage){
            return 2
        }
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1{
            return 1
        }
        
        return self.articleResult?.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: self.newsCellIdentifier) as! NewsTVCell
            
            let article = self.articleResult?.articles?[indexPath.row]
            
            cell.lblNewsTitle.text = article?.title
            cell.lblNewsDescription.text = article?.descriptionss?.stripOutHtml()
            cell.ivNews.setURLImage(article?.urlToImage, andPlaceHolderImage: self.placeholderSmallImage())
            
            return cell
            
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.newsLoadingCellIdentifier) as! NewsLoadingTVCell
        
        cell.activityIndicator.startAnimating()
        cell.separatorInset = UIEdgeInsets(top: 0, left: 10000, bottom: 0, right: 0)
        
        if self.isDatafectching == false{
            self.isDatafectching = true
            self.paginationFetchData()
        }
        
        cell.tag = 1000
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if indexPath.section == 1{
            return 50
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 1000
    }
}
