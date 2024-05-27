//
//  ViewModels.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 26.05.2024.
//

import Foundation
import FirebaseFirestore

final class CourseViewModel: ObservableObject {
    @Published var courses = [Course]()
    private var db = Firestore.firestore()

    func fetchCourses() {
        db.collection("courses").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.courses = documents.compactMap { queryDocumentSnapshot -> Course? in
                return try? queryDocumentSnapshot.data(as: Course.self)
            }
        }
    }
}

final class EventViewModel: ObservableObject {
    @Published var events = [Event]()
    private var db = Firestore.firestore()

    func fetchEvents() {
        db.collection("events").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.events = documents.compactMap { queryDocumentSnapshot -> Event? in
                return try? queryDocumentSnapshot.data(as: Event.self)
            }
        }
    }
}

class FAQViewModel: ObservableObject {
    @Published var faqs = [FAQ]()
    private var db = Firestore.firestore()

    func fetchFAQs() {
        db.collection("faqs").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.faqs = documents.compactMap { queryDocumentSnapshot -> FAQ? in
                return try? queryDocumentSnapshot.data(as: FAQ.self)
            }
        }
    }
}

class NewsViewModel: ObservableObject {
    @Published var newsList = [News]()
    private var db = Firestore.firestore()

    func fetchNews() {
        db.collection("news").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.newsList = documents.compactMap { queryDocumentSnapshot -> News? in
                return try? queryDocumentSnapshot.data(as: News.self)
            }
        }
    }
}

class ProductViewModel: ObservableObject {
    @Published var products = [Product]()
    private var db = Firestore.firestore()

    func fetchProducts() {
        db.collection("products").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.products = documents.compactMap { queryDocumentSnapshot -> Product? in
                return try? queryDocumentSnapshot.data(as: Product.self)
            }
        }
    }
}
