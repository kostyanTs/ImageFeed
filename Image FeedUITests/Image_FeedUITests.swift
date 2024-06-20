//
//  Image_FeedUITests.swift
//  Image FeedUITests
//
//  Created by Konstantin on 20.06.2024.
//

import XCTest


final class Image_FeedUITests: XCTestCase {
    
    private let login = ""
    private let password = ""
    private let lastName = ""
    private let firstName = ""
    private let nickname = ""
    
    private let app = XCUIApplication() // переменная приложения

    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        // тестируем сценарий авторизации
        // тестируем сценарий авторизации
        sleep(3)
        
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews[ "UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText(login)
        app.buttons["Done"].tap()
        sleep(2)
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText(password)
        app.buttons["Done"].tap()
        webView.swipeUp()
        
        sleep(2)
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
        sleep(3)
        let tablesQuery = app.tables
        sleep(5)
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp(velocity: .slow)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        
        sleep(3)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 5))
        
        cellToLike.buttons["Like Button"].tap()
        sleep(3)
        cellToLike.buttons["Like Button"].tap()
        
        sleep(3)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["navBackButton"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
        func testProfile() throws {
            sleep(3)
            app.tabBars.buttons.element(boundBy: 1).tap()
           
            XCTAssertTrue(app.staticTexts["\(self.firstName) \(self.lastName)"].exists)
            XCTAssertTrue(app.staticTexts[self.nickname].exists)
            
            app.buttons["LogoutButtton"].tap()
            
            app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        }
    }
}
