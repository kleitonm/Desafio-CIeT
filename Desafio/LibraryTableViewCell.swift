//
//  LibraryTableViewCell.swift
//  Desafio
//
//  Created by Kleiton Mendes on 24/01/2022.
//  Copyright © 2022 Kleiton Mendes. All rights reserved.
//

import UIKit

class LibraryTableViewCell: UITableViewCell {
    
    
    @IBOutlet var bookPosterImageView: UIImageView?
    @IBOutlet var bookTitleLabel: UILabel?
    @IBOutlet var bookAuthorLabel: UILabel?
    
    var trackName: String?
    var artistName: String?
    var artworkUrl60: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "LibraryTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "LibraryTableViewCell",
                     bundle: nil)
    }
    
    func configure(with model: Book) {
        self.bookTitleLabel?.text = model.trackName // campo de título do modelo
        self.bookAuthorLabel?.text = model.artistName // campo de autor do modelo
        _ = model.artworkUrl60// campo de poster do modelo
        if let url = model.artworkUrl60, let finalUrl = URL(string: url), let data = try? Data(contentsOf: finalUrl) {
            self.bookPosterImageView?.image = UIImage(data: data)
        }
    }
    }
    

