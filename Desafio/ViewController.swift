//
//  ViewController.swift
//  Desafio
//
//  Created by Kleiton Mendes on 24/01/2022.
//  Copyright © 2022 Kleiton Mendes. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var searchbar: UISearchBar?
    @IBOutlet var table: UITableView?
    
    var book = [Library]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table?.register(LibraryTableViewCell.nib(), forCellReuseIdentifier: LibraryTableViewCell.identifier)
        table?.delegate = self
        table?.dataSource = self
        searchbar?.delegate = self as? UISearchBarDelegate
    }
    
    // Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBooks()
        return true
    }
    
    func searchBooks() {
        searchbar?.resignFirstResponder()
        
        guard let text = searchbar?.text, text.isEmpty else {
            return
        }
        
        let query = text.replacingOccurrences(of: " ", with: "%20")
        
        book.removeAll()
        
        guard let url = URL(string: "https://itunes.apple.com/search?term=swift&entity=ibook") else {return}
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                                    
                                    guard let data = data, error == nil else {
                                        return 
                                    }
                                    
                                    // Convert
                                    var result: Book?
                                    do {
                                        let resultData = try JSONDecoder().decode(Library.self, from: data)
                                        self.book = [resultData]
                                    }
                                    catch {
                                        print("error")
                                    }
                                    
                                    guard let finalResult = result else {
                                        return
                                    }
                                    
                                    // Update our books array
                                    let newBooks = finalResult
                                    self.Book.append(newBooks)
                                    
                                    // Refresh our table
                                    DispatchQueue.main.async {
                                        self.table?.reloadData()
                                    }
                                    
        }).resume()
        
    }
    
    // Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return book.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LibraryTableViewCell.identifier, for: indexPath) as? LibraryTableViewCell {
            
            cell.configure(with: self.book[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

//        let url = "https://books.apple.com/us/artist/apple-inc/405307759?uo=4/\(Book[indexPath.row].itunes)/"
//        let vc = SFSafariViewController(url: URL(string: url)?)
//        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

struct Library: Codable {
    let resultCount: Int?
    let results: [Book]?
   
    private enum CodingKeys: String, CodingKey {
        case resultCount, results
    }
}

 struct Book: Codable {
     let trackName: String?
     let artistName: String?
     let artworkUrl60: String?
    
    private enum CodingKeys: String, CodingKey {
        case trackName, artistName, artworkUrl60
    }
}
