//
//  AddItemViewController.swift
//  vistasjerarquicas
//
//  Created by Raul Suarez Dabo on 28/02/16.
//  Copyright © 2016 es.com.suarez. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UISearchBarDelegate {

    
    @IBOutlet weak var search: UISearchBar!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    
    var book: Book?
    
    let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        search.delegate = self
        
        self.title = "Add new book by ISBN"
        self.book = Book()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if Reachability.isConnectedToNetwork() == true {
            self.view.endEditing(true)
            
            let url = NSURL(string: self.urls + searchBar.text!)
            
            let sesion = NSURLSession.sharedSession();
            let bloque = {(datos: NSData?, resp: NSURLResponse?, error: NSError?) -> Void in
                do {
                    let dictionary = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableContainers)
                    dispatch_sync(dispatch_get_main_queue(), {
                        let isbn =  self.search.text!
                        self.book!.setTitle(dictionary["ISBN:\(isbn)"]!!["title"] as! NSString as String)
                        self.titleLabel.text = "Title: \(self.book!.getTitle())"
                        let authors = dictionary["ISBN:\(isbn)"]!!["authors"] as! NSArray as Array
                        for item in authors {
                            let name = item["name"] as! NSString as String
                            self.book!.addAuthor(name)
                        }
                        self.authorLabel.text = "Author/s: \(self.book!.getAuthorsToString())"
                        if ((dictionary["ISBN:\(isbn)"]!!["cover"]! != nil) && (dictionary["ISBN:\(isbn)"]!!["cover"]!!["small"]! != nil)) {
                            let cover = dictionary["ISBN:\(isbn)"]!!["cover"]!!["small"] as! NSString as String
                            
                            self.book!.setCover(cover)
                            
                            let coverUrl = NSURL(string: cover)
                            let sesion = NSURLSession.sharedSession();
                            let getCover = {(datos: NSData?, resp: NSURLResponse?, error: NSError?) -> Void in
                                dispatch_sync(dispatch_get_main_queue(), {
                                    self.image.image = UIImage(data: datos!)
                                })
                            }
                            let dt = sesion.dataTaskWithURL(coverUrl!, completionHandler: getCover)
                            dt.resume()
                        }
                    })
                    
                } catch _ as NSError {
                    self.showAlert("Unexpected error", message: "Sorry :( but it looks that we get some kind of error from the API")
                }
                
            }
            
            let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
            dt.resume()
            
        }
        else {
            self.showAlert("No internet conection", message: "Sorry :( it's impossible to make this request without internet conection")
        }
    }
    
    @IBAction func saveAction(sender: AnyObject) {
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let nextView = segue.destinationViewController as! MasterViewController
        nextView.books?.append(self.book!)
    }

}
