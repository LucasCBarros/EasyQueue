//
//  IntentHandler.swift
//  FilaFacilSiri
//
//  Created by João Agostinho Hergert on 28/06/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension, INSendMessageIntentHandling, INSearchForMessagesIntentHandling, INSetMessageAttributeIntentHandling {
    
    var questionService = QuestionService()
    
    // Once resolution is completed, perform validation on the intent and provide confirmation (optional).
    
    func confirm(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Verify user is authenticated and your app is ready to send a message.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .ready, userActivity: userActivity)
        completion(response)
    }
    
    func confirm(intent: INSearchForMessagesIntent, completion: @escaping (INSearchForMessagesIntentResponse) -> Void) {
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSearchForMessagesIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }

    // Handle the completed intent (required).
    
    func handle(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Implement your application logic to send a message here.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .ready, userActivity: userActivity)
        completion(response)
    }
    
    // MARK: - INSearchForMessagesIntentHandling
    
    func resolveRecipients(for intent: INSearchForMessagesIntent, with completion: @escaping ([INPersonResolutionResult]) -> Void) {
        
        let person = INPersonResolutionResult.success(with: INPerson(personHandle: INPersonHandle(value: "B", type: .unknown),
                                                                    nameComponents: nil, displayName: "Developer",
                                                                    image: nil, contactIdentifier: nil, customIdentifier: nil))
        
        completion([person])
    }
    
    func resolveRecipients(for intent: INSendMessageIntent, with completion: @escaping ([INPersonResolutionResult]) -> Void) {
        let notRequired = INPersonResolutionResult.notRequired()
        completion([notRequired])
    }
    
    func handle(intent: INSearchForMessagesIntent, completion: @escaping (INSearchForMessagesIntentResponse) -> Void) {
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSearchForMessagesIntent.self))
        
        questionService.getAllQuestions(completion: {(questions, error) in
            if error == nil {
                let questions = questions.sorted(by: { (question1, question2) -> Bool in
                    return question1.questionID > question2.questionID
                })
                if questions.count > 0 {
                    let messages = questions.map { (question) -> INMessage in
                        INMessage(
                            identifier: question.questionID,
                            content: question.questionTitle,
                            dateSent: Date(),
                            sender: INPerson(personHandle: INPersonHandle(value: "A", type: .unknown),
                                             nameComponents: nil, displayName: "\(question.username)",
                                             image: nil, contactIdentifier: nil, customIdentifier: nil),
                            recipients: [INPerson(personHandle: INPersonHandle(value: "B", type: .unknown),
                                                  nameComponents: nil, displayName: "Developer",
                                                  image: nil, contactIdentifier: nil, customIdentifier: nil)]
                        )
                    }
                
                    let response = INSearchForMessagesIntentResponse(code: .success, userActivity: userActivity)
                    response.messages = messages
                    
                    let notResponse = INSearchForMessagesIntentResponse(
                        code: INSearchForMessagesIntentResponseCode.success,
                        userActivity: userActivity)
                    notResponse.messages = messages
                    
                    completion(notResponse)

                } else {
                    let response = INSearchForMessagesIntentResponse(code: .success, userActivity: userActivity)
                    completion(response)
                }
            }
        })
    }
    
    // MARK: - INSetMessageAttributeIntentHandling
    
    func handle(intent: INSetMessageAttributeIntent, completion: @escaping (INSetMessageAttributeIntentResponse) -> Void) {
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSetMessageAttributeIntent.self))
        let response = INSetMessageAttributeIntentResponse(code: .success, userActivity: userActivity)

        completion(response)
    }
}
