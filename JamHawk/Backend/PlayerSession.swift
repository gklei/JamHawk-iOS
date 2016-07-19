//
//  PlayerSession.swift
//  JamHawk
//
//  Created by Gregory Klein on 7/11/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation

protocol PlayerAPIService {
	func instantiatePlayer(callback: PlayerAPICallback)
	func requestNextTrack(callback: PlayerAPICallback)
}

class PlayerSession: PlayerAPIService {
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
	
	func requestNextTrack(callback: PlayerAPICallback) {
		guard let id = _playerID else { return }
		let statusInput = PlayerAPIInputStatus.requestNextTrackStatus(id)
		let input = PlayerAPIInput(instance: nil, status: statusInput, updates: nil, events: nil)
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
