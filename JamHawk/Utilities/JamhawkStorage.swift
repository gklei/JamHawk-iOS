//
//  JamhawkStorage.swift
//  JamHawk
//
//  Created by Gregory Klein on 8/18/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct JamhawkStorage {
	
	private static var lastUsedEmail: String? {
		get {
			return Defaults[.loginEmail]
		}
		set {
			Defaults[.loginEmail] = newValue
		}
	}
	
	private static var lastUsedPassword: String? {
		get {
			return Defaults[.loginPassword]
		}
		set {
			Defaults[.loginPassword] = newValue
		}
	}
	
	static var lastUsedCredentials: (email: String, password: String)? {
		get {
			guard let email = lastUsedEmail, password = lastUsedPassword else { return nil }
			return (email: email, password: password)
		}
		set {
			lastUsedEmail = newValue?.email
			lastUsedPassword = newValue?.password
		}
	}
	
	static var userHasSeenCoachingTips: Bool {
		get {
			return Defaults[.hasSeenCoachingTips]
		}
		set {
			Defaults[.hasSeenCoachingTips] = newValue
		}
	}
}

extension DefaultsKeys {
	static let loginEmail = DefaultsKey<String?>("com.Jamhawk.loginEmailKey")
	static let loginPassword = DefaultsKey<String?>("com.Jamhawk.loginPasswordKey")
	static let hasSeenCoachingTips = DefaultsKey<Bool>("com.Jamhawk.hasOnboardedKey")
}