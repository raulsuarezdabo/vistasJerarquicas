//
//  Book.swift
//  vistasjerarquicas
//
//  Created by Raul Suarez Dabo on 28/02/16.
//  Copyright © 2016 es.com.suarez. All rights reserved.
//

import Foundation

struct Book {
    var title: String?
    var authors: Array <String>
    var cover: String?
    
    init() {
        self.title = nil
        self.authors = Array()
        self.cover = nil
    }
    
    mutating func setTitle(title: String) {
        self.title = title
    }
    
    func getTitle() -> String {
        return self.title!
    }
    
    mutating func addAuthor(author: String) {
        self.authors.append(author)
    }
    
    func getAuthors() -> Array<String> {
        return self.authors
    }
    
    func getAuthorsToString() -> String {
        var authorsText: String = ""
        for author in self.getAuthors() {
            var i: Int = 0
            if (i == 0) {
                authorsText = authorsText + "\(author)"
                
            }
            else {
                authorsText = authorsText + ",\(author)"
            }
            i++
        }
        
        return authorsText
    }
    
    mutating func setCover(cover: String) {
        self.cover = cover
    }
    
    func getCover() -> String {
        return self.cover!
    }
    
}