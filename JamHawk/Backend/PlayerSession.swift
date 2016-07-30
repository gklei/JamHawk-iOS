//
//  PlayerSession.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/11/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

class PlayerSession {
	// MARK: - Properties
	private let _session: NSURLSession
	private var _playerDataTask: NSURLSessionDataTask?
	
	private var _playerID: String?
	private var _playerStatus: PlayerAPIInputStatus?
	
	init(session: NSURLSession) {
		_session = session
	}
	
	// MARK: - Public
	func instantiatePlayer(callback: PlayerAPICallback) {
		let instanceInput = PlayerAPIInputInstance(token: nil, needPlayerID: true, needOptions: true, isMobile: true, preloadSync: nil)
		let statusInput = PlayerAPIInputStatus.instanceRequestStatus()
		let input = PlayerAPIInput(instance: instanceInput, status: statusInput, updates: nil, events: nil)
		guard let request = input.generateRequest() else { return }
		
		_playerDataTask?.cancel()
		_playerDataTask = _session.dataTaskWithRequest(request) { (data, response, error) in
			
			let output = PlayerAPIOutput(jsonData: data)
			dispatch_async(dispatch_get_main_queue()) {
				
				self._playerID = output?.instance?.playerID
				callback(error: error, output: output)
			}
		}
		_playerDataTask?.resume()
	}
	
	func requestNextTrack(withUpdates updates: PlayerAPIInputUpdates? = nil, callback: PlayerAPICallback, requestID: Int) {
		
		guard let id = _playerID else { return }
		
		let status = PlayerAPIInputStatus(playerID: id, requestID: requestID, needInstance: false, needMedia: true, needNext: true, needFilters: true)
		let input = PlayerAPIInput(instance: nil, status: status, updates: updates, events: nil)
		guard let request = input.generateRequest() else { return }
		
		_playerDataTask?.cancel()
		_playerDataTask = _session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
			
			let output = PlayerAPIOutput(jsonData: data)
			dispatch_async(dispatch_get_main_queue()) {
				callback(error: error, output: output)
			}
		})
		_playerDataTask?.resume()
	}
	
	func sendRequest(needNext needNext: Bool, needMedia: Bool, needFilters: Bool, updates: PlayerAPIInputUpdates, requestID: Int, callback: PlayerAPICallback) {
		
		guard let id = _playerID else { return }
		
		let status = PlayerAPIInputStatus(playerID: id, requestID: requestID, needInstance: false, needMedia: needMedia, needNext: needNext, needFilters: needFilters)
		let input = PlayerAPIInput(instance: nil, status: status, updates: updates, events: nil)
		guard let request = input.generateRequest() else { return }
		
		_playerDataTask?.cancel()
		_playerDataTask = _session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
			
			let output = PlayerAPIOutput(jsonData: data)
			dispatch_async(dispatch_get_main_queue()) {
				callback(error: error, output: output)
			}
		})
		_playerDataTask?.resume()

	}
}
