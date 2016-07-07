//
//  BackendCommunicator.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/1/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

private let kUserAccessTestToken = "apptesttoken"
private let kTestEmail = "gregory@incipia.co"
private let kTestPassword = "hello"

typealias SignInCallback = (success: Bool, message: String?) -> Void
typealias SignUpCallback = (success: Bool, message: String?) -> Void

class JamHawkSession
{
	// MARK: - Properties
	private lazy var _session: NSURLSession = {
		let config = NSURLSessionConfiguration.defaultSessionConfiguration()
		config.HTTPCookieAcceptPolicy = .Always
		config.HTTPCookieStorage = .sharedHTTPCookieStorage()
		
		let session = NSURLSession(configuration: config)
		return session
	}()
	
	private var _signInDataTask: NSURLSessionDataTask?
	private var _signOutDataTask: NSURLSessionDataTask?
	private var _signUpDataTask: NSURLSessionDataTask?
	private var _playerDataTask: NSURLSessionDataTask?
	
	// MARK: - Public
	func signIn(email email: String, password: String, callback: SignInCallback? = nil) {
		let creds = UserAccessCredentials(email: email, password: password)
		let input = UserAccessAPIInput(credentials: creds, action: .SignIn, token: kUserAccessTestToken)
		guard let request = input.apiRequest() else { return }
		
		_signInDataTask?.cancel()
		_signInDataTask = _session.dataTaskWithRequest(request) { (data, response, error) in
			guard error == nil else {
				print(error)
				return
			}
			
			guard let json = UserAccessAPIOutput(jsonData: data) else { return }
			print(json)
		}
		_signInDataTask?.resume()
	}
	
	func signOut(email email: String, password: String, callback: SignInCallback? = nil) {
		let creds = UserAccessCredentials(email: email, password: password)
		let input = UserAccessAPIInput(credentials: creds, action: .SignOut, token: kUserAccessTestToken)
		guard let request = input.apiRequest() else { return }
		
		_signOutDataTask?.cancel()
		_signOutDataTask = _session.dataTaskWithRequest(request) { (data, response, error) in
			guard error == nil else {
				print(error)
				return
			}
			
			guard let json = UserAccessAPIOutput(jsonData: data) else { return }
			print(json)
		}
		_signOutDataTask?.resume()
	}
	
	func signUp(email email: String, password: String, callback: SignUpCallback? = nil) {
		let creds = UserAccessCredentials(email: email, password: password)
		let input = UserAccessAPIInput(credentials: creds, action: .SignUp, token: kUserAccessTestToken)
		guard let request = input.apiRequest() else { return }
		
		_signUpDataTask?.cancel()
		_signUpDataTask = _session.dataTaskWithRequest(request) { (data, response, error) in
			guard error == nil else {
				print(error)
				return
			}
			
			guard let json = UserAccessAPIOutput(jsonData: data) else { return }
			print(json)
		}
		_signUpDataTask?.resume()
	}
	
	// MARK: - Testing
	func signInWithTestCreds() {
		signIn(email: kTestEmail, password: kTestPassword)
	}
	
	func signOutWithTestCreds() {
		signOut(email: kTestEmail, password: kTestPassword)
	}
	
	func instantiateTestPlayer() {
		let playerRequest = NSMutableURLRequest(URL: JamHawkAPIURLProvider.player)
		playerRequest.HTTPMethod = "POST"
		playerRequest.addValue("application/json", forHTTPHeaderField: "Accept")
		
		let statusDict: [String: AnyObject] = ["playerID" : "", "requestID": 0, "needInstance": true, "needMedia":true, "needNext": false, "needFilters": false]
		let instanceDict: [String: AnyObject] = ["needPlayerID" : true, "needOptions" : true]
		let playerParams = ["status" : statusDict, "instance" : instanceDict]
		
		do {
			let playerParamsData = try NSJSONSerialization.dataWithJSONObject(playerParams, options: [])
			guard let playerParamsString = NSString(data: playerParamsData, encoding: NSUTF8StringEncoding) else { fatalError() }

			playerRequest.HTTPBody = "clazha_player=\(playerParamsString)".dataUsingEncoding(NSUTF8StringEncoding)
			
			_playerDataTask?.cancel()
			_playerDataTask = _session.dataTaskWithRequest(playerRequest) { (data, response, error) in
				if let error = error {
					print(error)
				}
				
				if let data = data {
					let contents = NSString(data: data, encoding: NSUTF8StringEncoding)
					print(contents)
				}
			}
			_playerDataTask?.resume()
			
		} catch let error {
			print(error)
		}
	}
}