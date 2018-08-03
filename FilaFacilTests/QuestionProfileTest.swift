//
//  QuestionProfileTest.swift
//  FilaFacilUITests
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 01/08/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import XCTest
@testable import FilaFacil

class QuestionProfileTest: XCTestCase {
    
    var question1: QuestionProfile?
    var question2: QuestionProfile?
    var question3: QuestionProfile?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.question1 = QuestionProfile(questionTitle: "Teste",
                                         questionID: "Teste01",
                                         userID: "User1",
                                         username: "User",
                                         requestedTeacher: "Dev",
                                         userPhoto: "n")
        
        self.question2 = QuestionProfile(questionTitle: "Teste",
                                         questionID: "Teste01",
                                         userID: "User1",
                                         username: "User",
                                         requestedTeacher: "Dev",
                                         userPhoto: "n")
        
        self.question3 = QuestionProfile(questionTitle: "Teste3",
                                         questionID: "Teste03",
                                         userID: "User1",
                                         username: "User",
                                         requestedTeacher: "Dev",
                                         userPhoto: "n")
        
    }
    
    override func tearDown() {
        self.question1 = nil
        self.question2 = nil
        self.question3 = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEquals() {
        
        if let quest1 = question1,
            let quest2 = question2 {
            
            XCTAssertFalse(quest1 != quest2)
            
            XCTAssertEqual(quest1, quest2, "Error in equal.")
        }
        
    }
    
}
