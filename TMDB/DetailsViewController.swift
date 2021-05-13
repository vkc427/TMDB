//
//  DetailsViewController.swift
//  TMDB
//
//  Created by Karthik Vadlamudi on 5/10/21.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var lblMovieName: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var txtMovieDesc: UITextView!
    var imgString: String?
    var movieString: String?
    var releaseDate: String?
    var txtDesc: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.lblMovieName.text = movieString
        self.lblReleaseDate.text = releaseDate
        self.txtMovieDesc.text = txtDesc
        loadImg()
    }
    
    func loadImg() {
        guard let aImage = imgString else {
            self.imgPoster.isHidden = true
            return
        }
        self.imgPoster.downloaded(from: "\(TMDBUrl.kAPI_Image)\(aImage)")
    }

}
