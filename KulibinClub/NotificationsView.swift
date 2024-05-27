//
//  NotificationsView.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//

import Firebase
import SwiftUI

struct Notification: Identifiable, Codable {
    var id: String
    var title: String
    var body: String
    var date: Date
}

class NotificationService: ObservableObject {
    
    @Published var notifications: [Notification] = [] {
        didSet { saveNotifications() }
    }

    init() {
        loadNotifications()
        loadNotificationsFromFirestore()
    }

    func addNotification(_ notification: Notification) {
        notifications.append(notification)
    }

    func removeNotification(atOffsets offsets: IndexSet) {
        offsets.forEach { index in
            let notification = notifications[index]
            removeNotificationFromFirestore(notification)
        }
        notifications.remove(atOffsets: offsets)
    }

    private func saveNotifications() {
        if let encoded = try? JSONEncoder().encode(notifications) {
            UserDefaults.standard.set(encoded, forKey: "notifications")
        }
    }

    private func loadNotifications() {
        if let savedNotifications = UserDefaults.standard.object(forKey: "notifications") as? Data, let decodedNotifications = try? JSONDecoder().decode([Notification].self, from: savedNotifications) {
            notifications = decodedNotifications
        }
    }

    private func loadNotificationsFromFirestore() {
        let db = Firestore.firestore()
        db.collection("notifications").getDocuments { snapshot, error in
            if let error = error {
                debugPrint("Ошибка загрузки уведомлений: \(error.localizedDescription)"); return
            }
            guard let documents = snapshot?.documents else { return }

            self.notifications = documents.compactMap { document -> Notification? in
                try? document.data(as: Notification.self)
            }
        }
    }

    private func removeNotificationFromFirestore(_ notification: Notification) {
        let db = Firestore.firestore()
        db.collection("notifications").document(notification.id).delete { error in
            if let error = error {
                debugPrint("Ошибка удаления уведомления: \(error.localizedDescription)")
            } else { debugPrint("Уведомление успешно удалено") }
        }
    }
}

struct NotificationView: View {
    @ObservedObject var notificationService: NotificationService

    var body: some View {
        List {
            ForEach(notificationService.notifications) { notification in
                VStack(alignment: .leading) {
                    Text(notification.title)
                        .font(.headline)
                    Text(notification.body)
                        .font(.subheadline)
                    Text("\(notification.date)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .onDelete(perform: notificationService.removeNotification)
        }
        .navigationTitle("Уведомления")
        .toolbar {
            EditButton()
        }
    }
}
