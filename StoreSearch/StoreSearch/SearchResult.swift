//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Islam Abd El Hakim on 14/12/2021.
//Creat our Data Model
// model our class to parse&recieve Json Data
import Foundation
class ResultArray:Codable
{
    var resultCount = 0
    var results = [SearchResult]()
    
}
class SearchResult:Codable,CustomStringConvertible
{
   
    
    var artistName:String? = ""
    var trackName:String? = ""
    var kind :String? = ""
    var trackPrice: Double? = 0.0
    var currency = ""
    var imageSmall = ""
    var imageLarge = ""
    
    var trackViewUrl: String?
    var collectionName: String?
    var collectionViewUrl: String?
    var collectionPrice: Double?
    var itemPrice: Double?
    var itemGenre: String?
    var bookGenre: [String]?
   
    enum CodingKeys: String, CodingKey {
      case imageSmall = "artworkUrl60"
      case imageLarge = "artworkUrl100"
      case itemGenre = "primaryGenreName"
      case bookGenre = "genres"
      case itemPrice = "price"
      case kind, artistName, currency
      case trackName, trackPrice, trackViewUrl
      case collectionName, collectionViewUrl, collectionPrice
    }
    var name:String
    {
        return trackName ?? collectionName ?? ""
    }
    var price:Double
    {
        return trackPrice ?? itemPrice ?? collectionPrice ?? 0.0
    }
    var genere:String
    {
        if let genere = itemGenre
        {return genere}
        else if let generes = bookGenre
        {
            return generes.joined(separator: ",")
        }
        return ""
    }
    var type:String {
      let kind = self.kind ?? "audiobook"
      switch kind {
      case "album": return "Album"
      case "audiobook": return "Audio Book"
      case "book": return "Book"
      case "ebook": return "E-Book"
      case "feature-movie": return "Movie"
      case "music-video": return "Music Video"
      case "podcast": return "Podcast"
      case "software": return "App"
      case "song": return "Song"
      case "tv-episode": return "TV Episode"
      default: break
      }
      return "Unknown"
    }
    var artist: String {
        return artistName ?? ""
    }
   // we use CustomStringConvertible protocol to use its description property for showing obj contents
    var description: String
    {
        return "Kind:\(kind ?? "None"),image:\(CodingKeys.imageSmall),Name:\(trackName) , ArtistName:\(artistName ?? "None")"
        
    }
    // overriding sort func  return true if result1 comes before result2   // sort results from a to z.
    static func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
      return lhs.name.localizedStandardCompare(rhs.name) ==  .orderedAscending
    }
   
    
}
