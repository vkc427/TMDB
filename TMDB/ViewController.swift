//
//  ViewController.swift
//  TMDB
//
//  Created by Karthik Vadlamudi on 5/7/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    lazy var dataManager = TMDBService(queue: DispatchQueue(label: "DataManager.queue", qos: .utility))
    var resultsData: [AnyObject] = []
    var isLoading = false
    var currentPage:Int = 1
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnGO: UIButton!
    @IBOutlet weak var bgView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = UIColor.gray.cgColor
        self.btnGO.addTarget(self, action: #selector(btnGOTapped(sender:)), for: .touchUpInside)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.resultsData.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
            let movie = self.resultsData[indexPath.row]
            let kempty = "-"
            if let rating = movie["vote_average"] as? Double {
                cell.lblRating.text = String(format: "%.2f", rating)
            } else {
                cell.lblRating.text = kempty
            }
            
            cell.lblMovieName.text = movie["original_title"] as? String ?? kempty
            cell.lblReleaseDate.text = movie["release_date"] as? String ?? kempty

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:"ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
            cell.activityIndicator.startAnimating()
            return cell
        }

    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = self.resultsData[indexPath.row]
        let kempty = "-"
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController {
            vc.movieString = movie["original_title"] as? String ?? kempty
            vc.releaseDate = movie["release_date"] as? String ?? kempty
            vc.txtDesc = movie["overview"] as? String ?? kempty
            vc.imgString = movie["poster_path"] as? String ?? kempty
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func btnGOTapped(sender: UIButton) {
        getSearchResults()
    }
    
    func getSearchResults(){
        guard let searchText = searchBar.text else {
            return
        }
        dataManager.searchRequest(term: searchText, page: currentPage) { json, error  in
            guard let data = json?["results"] as? [AnyObject] else {
                //need to show alert
                self.showAlert(message: Messages.ErrorMessage)
                return
            }
            self.resultsData = data
            self.tableView.reloadData()
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error!!!", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (contentHeight - offsetY < scrollView.frame.height) && !isLoading {
            //temp condition to make sure page doesnt go out of bounds.
            if currentPage <= 100 {
                currentPage = currentPage + 1
                loadMoreData()
            } else {
                self.showAlert(message: Messages.LastPage)
            }
           
        }
        
    }
    func loadMoreData() {
        //Need to fix this loading a bit
        if !self.isLoading, let searchTxt = searchBar.text, !searchTxt.isEmpty {
            self.isLoading = true
            self.getSearchResults()
            DispatchQueue.global().async {
                sleep(2)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
    
            
}




