//
//  DetailViewController.swift
//  vistasjerarquicas
//
//  Created by Raul Suarez Dabo on 27/02/16.
//  Copyright © 2016 es.com.suarez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var authorsLabel: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    
    var detailItem: Book?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.titleLabel.text = detailItem!.getTitle()
        self.authorsLabel.text = detailItem!.getAuthorsToString()
        if (detailItem?.getCover() != nil) {
            let coverUrl = NSURL(string: detailItem!.getCover())
            let sesion = NSURLSession.sharedSession();
            let getCover = {(datos: NSData?, resp: NSURLResponse?, error: NSError?) -> Void in
                dispatch_sync(dispatch_get_main_queue(), {
                    self.image.image = UIImage(data: datos!)
                })
            }
            let dt = sesion.dataTaskWithURL(coverUrl!, completionHandler: getCover)
            dt.resume()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

