//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Islam Abd El Hakim on 14/12/2021.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artIWorkmageView: UIImageView!
    var downloadTask:URLSessionDownloadTask?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 0, green: 250, blue: 85, alpha: 0.7)
        selectedBackgroundView = selectedView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(for result:SearchResult)
    {
        nameLabel.text = result.name
        if result.artist.isEmpty {
          artistNameLabel.text = "Unknown"
        } else {
          artistNameLabel.text = String(format: "%@ (%@)",result.artist, result.type)
        }
        // using image downloader extension for downloading the image and loading it to imageView in the cell
        artIWorkmageView.image=UIImage(named: "Placeholder")
        if let smallURL = URL(string: result.imageSmall)
        {
            downloadTask = artIWorkmageView.loadImage(url: smallURL)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
        print ("*** Cell is being reused ***")
    }

}
