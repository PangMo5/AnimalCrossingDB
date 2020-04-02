//
//  PushManager.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/02.
//  Copyright © 2020 Shirou. All rights reserved.
//

//import Foundation
//import UserNotifications
//import SwifterSwift
//import SwiftyUserDefaults
//
//final class PushManager {
//
//    static let shared = PushManager()
//
//    @SwiftyUserDefault(keyPath: \.enabledBookmarkPush)
//    fileprivate var enabledBookmarkPushDefault: Bool
//
//    @SwiftyUserDefault(keyPath: \.favoriteFishIDs)
//    fileprivate var favoriteFishIDsDefault: [Int]
//
//    @SwiftyUserDefault(keyPath: \.favoriteInsectIDs)
//    fileprivate var favoriteInsectIDsDefault: [Int]
//
//    fileprivate func scheulePush(id: Int, isFish: Bool) {
//        guard enabledBookmarkPushDefault else { return }
//        removePush(id: id, isFish: isFish)
//        if isFish {
//            guard let fish = (StorageManager.shared.fishListSubject.value.first { $0.id == id }) else { return }
//            schedulePush(collectible: fish)
//        } else {
//            guard let insect = (StorageManager.shared.insectListSubject.value.first { $0.id == id }) else { return }
//            schedulePush(collectible: insect)
//        }
//    }
//
//    fileprivate func removePush(id: Int, isFish: Bool) {
//        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
//            requests.forEach {
//                if $0.identifier.contains("\(isFish ? "fish" : "insect")_\(id)_") {
//                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [$0.identifier])
//                }
//            }
//        }
//    }
//
//    fileprivate func schedulePush<C: Collectible>(collectible: C) {
//        guard let id = collectible.id,
//            (collectible.hourList.map { $0.int }.reduce(0, +)) < 24 else { return }
//        UNUserNotificationCenter.current().requestAuthorization(
//            options: [.alert,.sound])
//        {
//            (granted, error) in
//        }
//
//        let notification = UNMutableNotificationContent()
//        notification.title = collectible.name ?? ""
//        notification.body = collectible.availableTime ?? ""
//
//        let hourList = collectible.hourList.enumerated().withPreviousAndNext.compactMap { previous, current, _ -> Int? in
//            (previous?.element == false && current.element) ? current.offset : nil
//        }
//
//        hourList.enumerated().forEach { hour in
//            var dateComponents = DateComponents()
//
//            dateComponents.hour = hour.element
//            dateComponents.minute = 0
//
//            let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//
//            (0...60).forEach {
//                let request = UNNotificationRequest(identifier: "\(collectible is Fish ? "fish" : "insect")_\(id)_\(hour.offset)_\($0)", content: notification, trigger: notificationTrigger)
//                UNUserNotificationCenter.current().add(request) { error in
//                    print(error?.localizedDescription)
//                }
//            }
//        }
//    }
//
//    func scheuleAllPush() {
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        favoriteFishIDsDefault.forEach {
//            scheulePush(id: $0, isFish: true)
//        }
//        favoriteInsectIDsDefault.forEach {
//            scheulePush(id: $0, isFish: false)
//        }
//    }
//
//    func removeAllPendingPush() {
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//    }
//}
//
//extension Sequence {
//    var withPreviousAndNext: [(Element?, Element, Element?)] {
//        let optionalSelf = self.map(Optional.some)
//        let next = optionalSelf.dropFirst() + [nil]
//        let prev = [nil] + optionalSelf.dropLast()
//        return zip(self, zip(prev, next)).map {
//            ($1.0, $0, $1.1)
//        }
//    }
//}
