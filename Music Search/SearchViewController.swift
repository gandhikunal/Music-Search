//
//  SearchViewController.swift
//  Music Search
//
//  Created by Kunal Gandhi on 12.07.18.
//  Copyright © 2018 Kunal Gandhi. All rights reserved.
//

import UIKit
import Foundation

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, URLSessionDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var tracks: [DisplayableTrack] = [DisplayableTrack]()
    let queryService = NetworkApiManager.shared
    var choosenAPI: ApiSelector?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.keyboardAppearance = UIKeyboardAppearance.default
        searchBar.becomeFirstResponder()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let querystring = searchBar.text
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        queryService.queryTrack(term: querystring!, api: choosenAPI!)
        { (result: UIResponse<[DisplayableTrack]>) in
            switch result {
            case .sucess(let result):
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.tracks = result
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }

        }
        
    }
    
    // MARK: - Table Data Source Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
      
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "track cell", for: indexPath) as! TrackViewCell
        
   
            let track = tracks[indexPath.row]
            cell.trackName.text = track.songName

        return cell
    }
    
}
