//
//  Encode.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 9/1/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//


import XCTest

@testable import JSONAPIMapper

class Encode: XCTestCase {
    
    func retrieveJSONObject(jsonFilename: String) -> NSDictionary {
        let jsonDataPath = NSBundle(forClass: Decode.self).URLForResource(jsonFilename, withExtension: ".json")
        let jsonData = NSData(contentsOfURL: jsonDataPath!)
        
        return try! NSJSONSerialization.JSONObjectWithData(
            jsonData!,
            options: NSJSONReadingOptions.AllowFragments
        ) as! NSDictionary
    }
    
    func test1ObjectWithRelationships() {
        let post = Post()
        post.title = "Some title"
        
        let author = Person()
        author.id = 9
        
        let comment1 = Comment()
        comment1.id = 1
        
        let comment2 = Comment()
        comment2.id = 2
        
        post.author = author
        post.comments = [comment1, comment2]

        let createResourceJSONObject = try! Mapper<Post>().createResourceDictionary(post)
        XCTAssertEqual(retrieveJSONObject("create_resource"), createResourceJSONObject as NSDictionary)
        
        post.title = "To TDD or Not"
        post.id = 1
        
        
        let updateResourceJSONObject = try! Mapper<Post>().updateResourceDictionary(post)
        XCTAssertEqual(retrieveJSONObject("update_resource"), updateResourceJSONObject)
        
        var updateRelationshipJSONObject = try! Mapper<Post>().updateRelationshipDictionary(
            post,
            relationship: "author",
            relationshipType: author.dynamicType
        )
        
        XCTAssertEqual(retrieveJSONObject("update_relationship"), updateRelationshipJSONObject as NSDictionary)
        
        updateRelationshipJSONObject = try! Mapper<Post>().updateRelationshipDictionary(
            post,
            relationship: "comments",
            relationshipType: comment1.dynamicType
        )
        
        XCTAssertEqual(retrieveJSONObject("update_relationship2"), updateRelationshipJSONObject as NSDictionary)
    }
    
}
