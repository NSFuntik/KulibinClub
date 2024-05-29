//
//  FirestoreService.swift
//  KulibinClub
//
//  Created by Dmitry Mikhaylov on 28.05.2024.
//
import Firebase
import FirebaseFirestore
import Foundation
/// A protocol defining a Firestore endpoint with path, method, and Firestore instance.
public protocol FirestoreEndpoint {
    /// `path`: The Firestore reference, which can either be `DocumentReference` or `CollectionReference`.
    var path: FirestoreReference { get }
    /// `method`: The CRUD operation type
    var method: FirestoreMethod { get }
    /// `firestore`: Firestore instance
    var firestore: Firestore { get }
}

public extension FirestoreEndpoint {
    // MARK: - Firestore computed instance

    var firestore: Firestore {
        Firestore.firestore()
    }
}

/// `FirestoreMethod`: The CRUD operation types
public enum FirestoreMethod {
    case get
    case post(any FirestoreIdentifiable)
    case put(any FirestoreIdentifiable)
    case delete
}

/// A protocol representing a Firestore reference.
public protocol FirestoreReference { }
extension DocumentReference: FirestoreReference { }
extension CollectionReference: FirestoreReference { }
/// A protocol for objects that can be identified in Firestore.
public protocol FirestoreIdentifiable: Hashable, Codable, Identifiable {
    var id: String? { get set }
}

/// A typealias used for dictionary representation.
public typealias Dictionary = [String: Any]
extension Encodable {
    /// Converts an encodable object to a dictionary.
    func asDictionary() -> Dictionary {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary else {
            return [:]
        }
        return dictionary
    }
}


/// A protocol defining methods to interact with Firestore.
public protocol FirestoreServiceProtocol {
    static func request<T>(_ endpoint: FirestoreEndpoint) async throws -> T where T: FirestoreIdentifiable
    static func request<T>(_ endpoint: FirestoreEndpoint) async throws -> [T] where T: FirestoreIdentifiable
    static func request(_ endpoint: FirestoreEndpoint) async throws -> Void
}
/// A class implementing the FirestoreServiceProtocol for interacting with Firestore.
public final class FirestoreService: FirestoreServiceProtocol {
    private init() {}
    
    public static func request<T>(_ endpoint: FirestoreEndpoint) async throws -> T where T: FirestoreIdentifiable {
        guard let ref = endpoint.path as? DocumentReference else {
            throw FirestoreServiceError.documentNotFound
        }
        switch endpoint.method {
        case .get:
            guard let documentSnapshot = try? await ref.getDocument() else {
                throw FirestoreServiceError.invalidPath
            }
            guard let documentData = documentSnapshot.data() else {
                throw FirestoreServiceError.parseError
            }
            let singleResponse = try FirestoreParser.parse(documentData, type: T.self)
            return singleResponse
        default:
            throw FirestoreServiceError.invalidRequest
        }
    }

    public static func request<T>(_ endpoint: FirestoreEndpoint) async throws -> [T] where T: FirestoreIdentifiable {
        guard let ref = endpoint.path as? CollectionReference else {
            throw FirestoreServiceError.collectionNotFound
        }
        switch endpoint.method {
        case .get:
            let querySnapshot = try await ref.getDocuments()
            var response: [T] = []
            for document in querySnapshot.documents {
                let data = try FirestoreParser.parse(document.data(), type: T.self)
                response.append(data)
            }
            return response
        case .post, .put, .delete:
            throw FirestoreServiceError.operationNotSupported
        }
    }

    public static func request(_ endpoint: FirestoreEndpoint) async throws {
        guard let ref = endpoint.path as? DocumentReference else {
            throw FirestoreServiceError.documentNotFound
        }
        switch endpoint.method {
        case .get:
            throw FirestoreServiceError.invalidRequest
        case var .post(model):
            model.id = ref.documentID
            try await ref.setData(model.asDictionary())
        case let .put(model):
            try await ref.setData(model.asDictionary())
        case .delete:
            try await ref.delete()
        }
    }
}

/// A struct providing parsing functionalities for Firestore data.
struct FirestoreParser {
    static func parse<T: Decodable>(_ documentData: Dictionary, type: T.Type) throws -> T {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: documentData, options: [])
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: jsonData)
        } catch {
            throw FirestoreServiceError.parseError
        }
    }
}

/// An enum defining possible errors in Firestore service.
public enum FirestoreServiceError: Error {
    case invalidPath
    case invalidType
    case collectionNotFound
    case documentNotFound
    case unknownError
    case parseError
    case invalidRequest
    case operationNotSupported
    case invalidQuery
    case operationNotAllowed
}
