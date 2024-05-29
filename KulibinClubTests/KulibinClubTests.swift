////
////  KulibinClubTests.swift
////  KulibinClubTests
////
////  Created by Dmitry Mikhaylov on 26.05.2024.
////
//
//import XCTest
//@testable import KulibinClub
//
//final class KulibinClubTests: XCTestCase {
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
//}
//
//
//import XCTest
//import Firebase
//import FirebaseFirestore
//
///// ###`Mock-классы`: Созданы MockDocumentReference и MockDocumentSnapshot для симуляции поведения Firestore.
//
//// Mock FirestoreReference
//class MockDocumentReference: DocumentReference {
//    var data: [String: Any]?
//    var documentID: String = "testDocument"
//    
//    override func getDocument(completion: @escaping (DocumentSnapshot?, Error?) -> Void) {
//        let snapshot = MockDocumentSnapshot(data: data)
//        completion(snapshot, nil)
//    }
//    
//    override func setData(_ documentData: [String: Any], completion: ((Error?) -> Void)? = nil) {
//        self.data = documentData
//        completion?(nil)
//    }
//    
//    override func delete(completion: ((Error?) -> Void)? = nil) {
//        self.data = nil
//        completion?(nil)
//    }
//}
//
//// Mock DocumentSnapshot
//class MockDocumentSnapshot: DocumentSnapshot {
//    private let mockData: [String: Any]?
//    
//    init(data: [String: Any]?) {
//        self.mockData = data
//        super.init()
//    }
//    
//    override var data: [String: Any]? {
//        return mockData
//    }
//}
///// ### `MockFirestoreEndpoint`: Используется для тестирования методов FirestoreEndpoint.
//
//// Mock FirestoreEndpoint
//struct MockFirestoreEndpoint: FirestoreEndpoint {
//    var path: FirestoreReference
//    var method: FirestoreMethod
//}
///// ### Модели: `MockModel` - пример модели, соответствующей протоколу FirestoreIdentifiable.
//// Example FirestoreIdentifiable model
//struct MockModel: FirestoreIdentifiable {
//    var id: String? = "testID"
//    var name: String
//    
//    init(id: String? = nil, name: String) {
//        self.id = id
//        self.name = name
//    }
//}
//
//final class FirestoreServiceTests: XCTestCase {
//    
//    func testCreateDocument() async throws {
//        let model = MockModel(name: "Test")
//        let documentRef = MockDocumentReference(from: JSONDecoder())
//        let endpoint = MockFirestoreEndpoint(path: documentRef, method: .post(model))
//        
//        try await FirestoreService.request(endpoint)
//        
//        XCTAssertEqual(documentRef.data?["name"] as? String, "Test")
//    }
//    
//    func testReadDocument() async throws {
//        let data: [String: Any] = ["id": "testID", "name": "Test"]
//        let documentRef = MockDocumentReference(from: JSONDecoder())
//        documentRef.data = data
//        let endpoint = MockFirestoreEndpoint(path: documentRef, method: .get)
//        
//        let model: MockModel = try await FirestoreService.request(endpoint)
//        
//        XCTAssertEqual(model.name, "Test")
//        XCTAssertEqual(model.id, "testID")
//    }
//    
//    func testUpdateDocument() async throws {
//        var model = MockModel(id: "testID", name: "Updated Test")
//        let documentRef = MockDocumentReference(from: JSONDecoder())
//        let endpoint = MockFirestoreEndpoint(path: documentRef, method: .put(model))
//        
//        try await FirestoreService.request(endpoint)
//        
//        XCTAssertEqual(documentRef.data?["name"] as? String, "Updated Test")
//    }
//    
//    func testDeleteDocument() async throws {
//        let documentRef = MockDocumentReference(from: JSONDecoder())
//        let endpoint = MockFirestoreEndpoint(path: documentRef, method: .delete)
//        
//        try await FirestoreService.request(endpoint)
//        
//        XCTAssertNil(documentRef.data)
//    }
//}
