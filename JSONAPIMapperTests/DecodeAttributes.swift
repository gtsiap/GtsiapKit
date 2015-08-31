//
//  DecodeAttributes.swift
//  JSONAPIMapperTests
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import XCTest

@testable import JSONAPIMapper

class DecodeAttributes: XCTestCase {
    
    private static var JSON: [String : AnyObject] =  [String : AnyObject]()
    private static var post: Post!
    
    override class func setUp() {
    
        let jsonDataPath = NSBundle(forClass: DecodeAttributes.self).URLForResource("json", withExtension: ".txt")
        let jsonData = NSData(contentsOfURL: jsonDataPath!)
        let jsonObject = try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.AllowFragments)
        
        DecodeAttributes.JSON = jsonObject as! [String : AnyObject]
    }
    
    func test1Post() {        
        let posts = Mapper<Post>().fromJSON(DecodeAttributes.JSON)
        let post = posts[0]
        
        XCTAssertEqual(posts.count, 1)
        XCTAssertEqual(post.title, "JSON API paints my bikeshed!")
        XCTAssertNotNil(post.author)
        
        
        DecodeAttributes.post = post
    }

    func test2Author() {
        let author = DecodeAttributes.post.author
        
        XCTAssertNotNil(author?.firstName)
        XCTAssertEqual(author?.firstName, "Dan")
        
        XCTAssertNotNil(author?.lastName)
        XCTAssertEqual(author?.lastName, "Gebhardt")
        
        XCTAssertNotNil(author?.twitter)
        XCTAssertEqual(author?.twitter, "dgeb")
    }
    
    func test3Comments() {
        let comments = DecodeAttributes.post.comments
        XCTAssertEqual(comments?.count, 2)
        
        XCTAssertNotNil(comments?[0].body)
        XCTAssertEqual(comments?[0].body, "First!")
        
        XCTAssertNotNil(comments?[1].body)
        XCTAssertEqual(comments?[1].body, "I like XML better")

    }
}
