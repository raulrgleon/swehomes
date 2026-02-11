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

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale(identifier: "en_US")

        let deals = Array(MockData.properties.prefix(3))
        let sampleDeal = deals.first
        let priceText = sampleDeal.map { formatter.string(from: NSNumber(value: $0.price)) ?? "" } ?? ""
        let titleText = sampleDeal?.title ?? "Great property"

        let morningContent = UNMutableNotificationContent()
        morningContent.title = "🔥 Hot Deals!"
        morningContent.body = "Check out today's best deals. \(titleText) from \(priceText)"
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
        afternoonContent.body = "New properties just added. Open the app to see today's deals."
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
