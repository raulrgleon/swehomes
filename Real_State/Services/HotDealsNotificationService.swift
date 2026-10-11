//
//  HotDealsNotificationService.swift
//  Real_State
//
//  Notificaciones locales para Hot Deals cuando la app no está en uso.
//

import Foundation
import UserNotifications

final class HotDealsNotificationService {
    static let shared = HotDealsNotificationService()

    private let hotDealsCategoryId = "HOT_DEALS"

    /// Solicita permiso y programa notificaciones de Hot Deals
    func setupHotDealsNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else { return }
            DispatchQueue.main.async {
                self.scheduleHotDealsNotifications()
            }
        }
    }

    /// Programa notificaciones diarias de Hot Deals
    private func scheduleHotDealsNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["hot-deals-morning", "hot-deals-afternoon"])

        let bestDeal = PropertyRepository.shared.fetchProperties()
            .filter { $0.status == .available && $0.listingType == .sale && $0.price > 0 }
            .min { $0.price < $1.price }

        let morningContent = UNMutableNotificationContent()
        morningContent.title = "🔥 Hot Deals!"
        if let deal = bestDeal {
            morningContent.body = "Check out today's best deals. \(deal.city), \(deal.state) from \(deal.priceFormatted)"
        } else {
            morningContent.body = "Check out today's best deals on SWE Homes."
        }
        morningContent.sound = .default
        morningContent.categoryIdentifier = hotDealsCategoryId

        var morningDate = DateComponents()
        morningDate.hour = 10
        morningDate.minute = 0
        let morningTrigger = UNCalendarNotificationTrigger(dateMatching: morningDate, repeats: true)
        let morningRequest = UNNotificationRequest(identifier: "hot-deals-morning", content: morningContent, trigger: morningTrigger)
        center.add(morningRequest)

        let afternoonContent = UNMutableNotificationContent()
        afternoonContent.title = "🔥 Don't miss these Hot Deals!"
        afternoonContent.body = "Owner-financed homes and land. Open the app to see today's deals."
        afternoonContent.sound = .default
        afternoonContent.categoryIdentifier = hotDealsCategoryId

        var afternoonDate = DateComponents()
        afternoonDate.hour = 14
        afternoonDate.minute = 30
        let afternoonTrigger = UNCalendarNotificationTrigger(dateMatching: afternoonDate, repeats: true)
        let afternoonRequest = UNNotificationRequest(identifier: "hot-deals-afternoon", content: afternoonContent, trigger: afternoonTrigger)
        center.add(afternoonRequest)
    }

    /// Verifica si las notificaciones están habilitadas
    func checkAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }

    /// Programa una notificación de prueba con ID fijo (para poder cancelar)
    func scheduleTestNotification(id: String, in seconds: TimeInterval) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else { return }
            DispatchQueue.main.async {
                let center = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                content.title = "🔥 Hot Deals!"
                content.body = "Check out today's best deals. New properties just added!"
                content.sound = .default
                content.categoryIdentifier = self.hotDealsCategoryId

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(1, seconds), repeats: false)
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                center.add(request)
            }
        }
    }

    /// Cancela una notificación programada por ID
    func cancelTestNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }

    static let testIds = (oneMin: "hot-deals-test-1min", fiveMin: "hot-deals-test-5min", oneHour: "hot-deals-test-1hour", sixHours: "hot-deals-test-6hours")
}
