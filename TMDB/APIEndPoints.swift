//
//  APIEndPoints.swift
//  TMDB
//
//  Created by Karthik Vadlamudi on 5/7/21.
//

import Foundation
struct TMDBUrl {
    static let kSearchBaseURL = "https://api.themoviedb.org/3/"
    static let kAPI_Search = "search/movie?"
    static let kAPI_Image = "https://image.tmdb.org/t/p/w500/"
    static let kAPI_key = "api_key=51647f73623af168a95039acb718783f"
}

struct Messages {
    static let ErrorMessage = "Application unable to complete your request. Please try again later."
    static let LastPage = "Application has reached end of search results."
}
