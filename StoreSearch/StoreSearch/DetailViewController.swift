//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Islam Abd El Hakim on 24/12/2021.
//

import UIKit

class DetailViewController: UIViewController {
    var searchResult:SearchResult!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var artWorkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var genereLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    var downloadTask:URLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        popUpView.layer.cornerRadius = 10
        view.tintColor = UIColor(red: 20/255, green: 160/255,blue: 160/255, alpha: 1)
        let gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(close))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        if searchResult != nil{
        updateUI()
        }
        // Do any additional setup after loading the view.
    }
    deinit {
      print("deinit \(self)")
      downloadTask?.cancel()
    }
   
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateUI()
    {
        nameLabel.text = searchResult.name
        if searchResult.artist.isEmpty
        {
            artistNameLabel.text="unknown"
        }
        else
        {
            artistNameLabel.text = searchResult.artist
        }
        kindLabel.text = searchResult.type
        genereLabel.text = searchResult.genere

        // Show price
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = searchResult.currency

        let priceText: String
        if searchResult.price == 0 {
          priceText = "Free"
        } else if let text = formatter.string(
          from: searchResult.price as NSNumber) {
          priceText = text
        } else {
          priceText = ""
        }

        priceButton.setTitle(priceText, for: .normal)

        // Get image
        if let largeURL = URL(string: searchResult.imageLarge) {
          downloadTask = artWorkImageView.loadImage(url: largeURL)
        }
    }
    

}
extension DetailViewController:
          UIViewControllerTransitioningDelegate {
  func presentationController(
     forPresented presented: UIViewController,
     presenting: UIViewController?, source: UIViewController) ->
     UIPresentationController? {
    return DimmingPresentationController(
             presentedViewController: presented,presenting: presenting)
}
    func animationController(forPresented presented:
         UIViewController, presenting: UIViewController,
         source: UIViewController) ->
         UIViewControllerAnimatedTransitioning? {
      return BounceAnimationController()
    }
}
extension DetailViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(
       _ gestureRecognizer: UIGestureRecognizer,
       shouldReceive touch: UITouch) -> Bool {
    return (touch.view === self.view)
}
    func animationController(forDismissed dismissed:
      UIViewController) -> UIViewControllerAnimatedTransitioning? {
      return SlideOutAnimationController()
    }
}
