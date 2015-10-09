//
//  Decode.swift
//  JSONAPIMapperTests
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import XCTest

@testable import JSONAPIMapper

class Decode: XCTestCase {

    private static var JSON: [String : AnyObject] =  [String : AnyObject]()
    private static var post: Post!

    override class func setUp() {
        let jsonDataPath = NSBundle(forClass: Decode.self).URLForResource("json", withExtension: ".txt")
        let jsonData = NSData(contentsOfURL: jsonDataPath!)
        let jsonObject = try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.AllowFragments)

        Decode.JSON = jsonObject as! [String : AnyObject]
    }

    func test1Post() {
        let posts = try! Mapper<Post>().fromJSON(Decode.JSON)
        let post = posts[0]

        XCTAssertEqual(posts.count, 1)
        XCTAssertEqual(post.title, "JSON API paints my bikeshed!")
        XCTAssertNotNil(post.author)
        XCTAssertEqual(post.id, 1)

        Decode.post = post
    }

    func test2Author() {
        let author = Decode.post.author

        XCTAssertNotNil(author?.firstName)
        XCTAssertEqual(author?.firstName, "Dan")

        XCTAssertNotNil(author?.lastName)
        XCTAssertEqual(author?.lastName, "Gebhardt")

        XCTAssertNotNil(author?.twitter)
        XCTAssertEqual(author?.twitter, "dgeb")

        XCTAssertEqual(author?.id, 9)
    }

    func test3Comments() {
        let comments = Decode.post.comments
        XCTAssertEqual(comments?.count, 2)

        XCTAssertNotNil(comments?[0].body)
        XCTAssertEqual(comments?[0].body, "First!")
        XCTAssertEqual(comments?[0].id, 5)

        XCTAssertNotNil(comments?[1].body)
        XCTAssertEqual(comments?[1].body, "I like XML better")
        XCTAssertEqual(comments?[1].id, 12)
    }
}
