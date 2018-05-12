//
//  FilaFacilUITests.swift
//  FilaFacilUITests
//
//  Created by Lucas Barros on 09/03/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import XCTest

class FilaFacilUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation
            // - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testLoginTeacher() {
//
//        let loginButtonButton = app.buttons["Login Button"]
//        loginButtonButton.tap()
//
//        let okButton = app.alerts["Login Error"].buttons["Ok"]
//        okButton.tap()
//
//        app/*@START_MENU_TOKEN@*/.buttons["Login"]/*[[".segmentedControls.buttons[\"Login\"]",".buttons[\"Login\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//
//        let eMailTextField = app.textFields["E-mail"]
//        eMailTextField.tap()
//        eMailTextField.typeText("teacher@t.com")
//
//        let toolbarsQuery = app.toolbars
//        toolbarsQuery.buttons["Toolbar Next Button"].tap()
//        app.secureTextFields["Password"].typeText("qqqqqq")
//        toolbarsQuery.buttons["Toolbar Done Button"].tap()
//        app.buttons["Login Button"].tap()
//
//
//        let tabBarsQuery = app.tabBars
//        tabBarsQuery.buttons["Questions"].tap()
//    }
//
//    func test_LogoutTeacher() {
//
//        app.tabBars.buttons["Questions"].tap()
//        app.buttons["icons8 settings 50"].tap()
//        app.buttons["Logout"].tap()
//    }
    
    // Testa login do aluno
    func testLoginStudent() {
        
        // Tenta logar com campo vazio
        let loginButtonButton = app.buttons["Login Button"]
        loginButtonButton.tap()
        
        // Fecha mensagem de erro
        let okButton = app.alerts["Login Error"].buttons["Ok"]
        okButton.tap()
        
        app/*@START_MENU_TOKEN@*/.buttons["Login"]/*[[".segmentedControls.buttons[\"Login\"]",".buttons[\"Login\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        // Preenche campo de e-mail
        let eMailTextField = app.textFields["E-mail"]
        eMailTextField.tap()
        eMailTextField.typeText("lucas@l.com")
        
        let toolbarsQuery = app.toolbars
        toolbarsQuery.buttons["Toolbar Next Button"].tap()
        
        // Preenche campo de senha
        app.secureTextFields["Password"].typeText("qqqqqq")
        toolbarsQuery.buttons["Toolbar Done Button"].tap()
        
        // Clica botao login
        app.buttons["Login Button"].tap()
        
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Questions"].tap()
    }
    
    // Testa aluno entrando na fila e voltando para tableview
    func testEnterLine() {
        
        // Abre tab de perguntas
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Questions"].tap()
        
        // Preenche campo de pergunta
        let questionTextField = app.textFields["What's your question?"]
        questionTextField.tap()
        
        // Escreve "Hello"
        questionTextField.typeText("Hello")
        app.toolbars.buttons["Toolbar Done Button"].tap()
        
        // Clica em entrar na fila
        app.buttons["Enter Line"].tap()
        tabBarsQuery.buttons["Line"].tap()
        
    }
    
    // Testa aluno saindo da fila e voltando  para tableview
    func test_LeaveLine() {
        
        // Abre tab de pergunta
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Questions"].tap()
        
        // Clica em sair da fila
        app.buttons["Leave Line"].tap()
        tabBarsQuery.buttons["Line"].tap()
        
    }
    
    // Testa se é possivel fazer logout
    func test_LogoutStudent() {
        
        // Abre tab de pergunta
        app.tabBars.buttons["Questions"].tap()
        
        // Clica batao de configuracoes
        app.buttons["icons8 settings 50"].tap()
        
        // Clica no botao de logout
        app.buttons["Logout"].tap()
    }
}
