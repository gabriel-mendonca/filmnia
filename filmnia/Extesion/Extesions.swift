//
//  File.swift
//  filmnia
//
//  Created by Lucas Rodrigues Dias on 25/04/20.
//  Copyright © 2020 lucrodrigs. All rights reserved.
//

import Foundation
import UIKit

typealias CollectionSection = EnumerateSection.Section

class EnumerateSection {
    
    enum Section: Int, CaseIterable {
        case popular = 0
        case upComing
        case nowPlaying
        
        var titleSectionsMovies: String {
            switch self {
            case .popular:
                return " Popular Movies"
            case .upComing:
                return " Upoming Movies"
            case .nowPlaying:
                return " Now Playing Movies"
            }
        }
        
        var titleSectionsTelevision: String {
            switch self {
            case .popular:
                return " Popular Series"
            case .upComing:
                return " Top Rated Series"
            case .nowPlaying:
                return " On The Air "
            }
        }
        
        var height: CGFloat {
            switch self {
            case .popular:
                return 278
            default:
                return 187
            }
        }
        
        var sizeCollectionCell: CGSize {
            switch self {
            case .popular:
                return CGSize(width: 187, height: height)
            default:
                return CGSize(width: 168*3/4, height: height)
            }
        }
        
    }
    
    enum FormatStyle: String {
        case longDateDetail = "dd 'de' MMMM 'de' yyyy"
        case monthAndYearName = "MMMM yyyy"
    }
    
    enum ContentSection {
        case moviesPopular(ResultsMovies)
        case moviesUpComing(ResultsMovies)
        case moviesNowPlaying(ResultsMovies)
        case televisionPopular(ResultsTelevision)
        case televisionTopRated(ResultsTelevision)
        case televisionOnTheAir(ResultsTelevision)
    }
    
}

enum MediaType: String, Codable {
    case tv
    case movie
}
