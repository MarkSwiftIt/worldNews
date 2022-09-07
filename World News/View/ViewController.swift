//
//  ViewController.swift
//  World News
//
//  Created by Mark Goncharov on 19.07.2022.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    
    private let tableView: UITableView = {
        let t = UITableView()
        t.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return t
    }()

    private var articles = [Articles]()
    private var viewModels = [NewsTableViewCellViewModel]()

    private let searchVC = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "World News"
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchTopNews()
        createSearchBar()
    }
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            
            tableView.frame = view.bounds
        }
        
    
//MARK: - Network
    
    private func fetchTopNews() {
        
        NetworkService.shared.getTopNews { [ weak self ] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title,
                                               subtitle: $0.description ?? "No description",
                                               imageURL: URL(string: $0.urlToImage ?? ""))
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }

    private func createSearchBar() {
        
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        NetworkService.shared.search(with: text){ [ weak self ] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title,
                                               subtitle: $0.description ?? "No description",
                                               imageURL: URL(string: $0.urlToImage ?? ""))
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.searchVC.dismiss(animated: true, completion: nil)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }

    
//MARK: - TableView DataSource, Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier,
                                                    for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }

}

