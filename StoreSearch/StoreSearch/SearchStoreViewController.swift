//
//  SearchStoreViewController.swift
//  StoreSearch
//
//  Created by Islam Abd El Hakim on 14/12/2021.
//

import UIKit

class SearchStoreViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var searchResults = [SearchResult]()
    var hassearched = false
    var isLoading = false
    var dataTask : URLSessionDataTask?
    struct TableView
    {
        struct CellIdentifiers
        {
           static let searchResultCell = "SearchResultCell"
           static let nothingFoundCell = "NothingFoundCell"
           static let loadingCell = "LoadingCell"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Registering nib file for use in code search cell
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
        // Register nothingFoundCell
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        searchBar.becomeFirstResponder()
        //Register loadingCell
        cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
        //segmentedControl beautify UI
        let segmentColor = UIColor(red: 10/255, green: 80/255, blue:
   80/255, alpha: 1)
        let selectedTextAttributes =
    [NSAttributedString.Key.foregroundColor: UIColor.white]
        let normalTextAttributes =
    [NSAttributedString.Key.foregroundColor: segmentColor]
        segmentedControl.selectedSegmentTintColor = segmentColor
    segmentedControl.setTitleTextAttributes(normalTextAttributes,
    for: .normal)
    segmentedControl.setTitleTextAttributes(selectedTextAttributes,
    for: .selected)
    segmentedControl.setTitleTextAttributes(selectedTextAttributes,
    for: .highlighted)
    }
    
    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        performSearch()
    }
    // MARK:- Helper Methods 1- Builds a URL strings
    func iTunesURL(searchText:String,category:Int)->URL
    {
        let kind:String
        switch category
        {
        case 1 : kind = "musicTrack"
        case 2 : kind = "software"
        case 3 : kind = "ebook"
        default : kind = ""
        }
        // to handel + |< > signs  and skip all special charchters in the searchText u have to encode it
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)!
        let urlString = "https://itunes.apple.com/search?"+"term=\(encodedText)"+"&limit=200"+"&entity=\(kind)"
        let url = URL(string: urlString)// turns the string into URL object
        return url!
    }
// Mark : - Perform Store Request To itunesServe and get json file as string
   
//MARK:- Parse Json Data
    func parse(data:Data) ->[SearchResult]
    {
        do{
        let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from: data)
            return result.results
        }
        catch
        {
            print("JSON Error:'\(error)'")
            return []
        }
        
    }
//Handling Errors
    func showNetworkError() {
      let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the iTunes Store." +  " Please try again.", preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .default, handler: nil)
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
     
    }

}
// search bar delegate protocol methods
extension SearchStoreViewController : UISearchBarDelegate
{
    //search operation using url session
    func performSearch()
    {
        if !searchBar.text!.isEmpty
        {
        searchBar.resignFirstResponder()// This tells the UISearchBar that it should no longer listen for keyboard input. As a result, the keyboard will hide itself until you tap on the search bar again.
        dataTask?.cancel() // cancell the current request if another request inatiated
        isLoading = true
        tableView.reloadData()
        hassearched = true
        searchResults=[]
     // urlseesion api
            let url = iTunesURL(searchText: searchBar.text!,category: segmentedControl.selectedSegmentIndex)
            let session = URLSession.shared
             dataTask = session.dataTask(with: url, completionHandler: { data,response,error in
                print("On main thread? " + (Thread.current.isMainThread ?
                "Yes" : "No"))
/*As it turns out, when a data task gets cancelled, its completion handler is still invoked but with an Error object that has error code -999. That’s what caused the error alert to pop up.*/
            if let error = error as NSError?, error.code == -999 {
                   return  // Search was cancelled
                } else if let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200 {
                    if let data = data {
                    self.searchResults = self.parse(data: data)
                      self.searchResults.sort(by: <)
                      DispatchQueue.main.async {
                        self.isLoading = false
                        self.tableView.reloadData()
                      }}
                    return
                } else {
                  print("Failure! \(response!)")
                }
                DispatchQueue.main.async {
                  self.hassearched = false
                  self.isLoading = false
                  self.tableView.reloadData()
                  self.showNetworkError()
                }
                
            })
            dataTask?.resume()
        }
    }
    //1-when search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
    //Make the search bar attached to the top of screen - make search bar more beautifull
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
extension SearchStoreViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading
        {return 1}
        if !hassearched
        {return 0}
        if searchResults.count == 0
        {return 1}
        else {
        return searchResults.count

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      
        if isLoading
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        }
        if searchResults.count == 0
        {
            return tableView.dequeueReusableCell(
                withIdentifier: TableView.CellIdentifiers.nothingFoundCell,
                for: indexPath)
        }else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            let searchResult = searchResults[indexPath.row]
            cell.configure(for: searchResult)
            return cell
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
    //select row only if there is a actual search results
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 || isLoading
        {
            return nil
        }
        else
        {
            return indexPath
        }
    }
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue,
                             sender: Any?) {
     if segue.identifier == "showDetail" {
       let detailViewController = segue.destination
                                  as! DetailViewController
       let indexPath = sender as! IndexPath
       let searchResult = searchResults[indexPath.row]
       detailViewController.searchResult = searchResult
     }
    }
    
}

