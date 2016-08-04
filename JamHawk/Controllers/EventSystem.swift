//
//  EventSystem.swift
//  JamHawk
//
//  Created by Leif Meyer on 8/3/16.
//  Copyright © 2016 Incipia. All rights reserved.
//

import Foundation


typealias EventSystemNotificationModel = [String : PlayerAPIInputEventName]

final class EventSystem: SystemController<EventSystemNotificationModel> {
    private var _map: EventSystemNotificationModel?
    private(set) var queue = [PlayerAPIInputEvent]()
    
    override func update(withModel model: EventSystemNotificationModel?) {
        guard let model = model else { return }
        _map = model
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
        for notificationName in model.keys {
            notificationCenter.addObserver(self, selector: #selector(EventSystem.eventNotification), name: notificationName, object: nil)
        }
        
        post(notification: .modelDidUpdate)
    }
    @objc func eventNotification(notification: NSNotification) {
        if let eventName = _map?[notification.name] {
            queue.append(PlayerAPIInputEvent(name: eventName, timestamp: Int(NSDate().timeIntervalSince1970), mid: nil, description: nil))
            post(notification: .didQueueEvent)
        }
    }
    func emptyQueue() -> [PlayerAPIInputEvent]? {
        post(notification: .willEmptyEventQueue)
        let events = queue
        queue.removeAll()
        return events.isEmpty ? nil : events
    }
}

extension EventSystem: Notifier {
    enum Notification: String {
        case modelDidUpdate
        case didQueueEvent
        case willEmptyEventQueue
    }
}