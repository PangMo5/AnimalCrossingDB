//
//  StorageManager.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/03/31.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    fileprivate let storage = Storage.storage()
    
    let fileManager = FileManager.default
    var localVersions = Versions(fish: 0, insect: 0)
    
    let fishListSubject = CurrentValueSubject<[Fish], Never>([])
    let insectListSubject = CurrentValueSubject<[Insect], Never>([])
    
    init() {
    }
    
    func fetchStaticData(completion: @escaping ((Bool) -> Void)) {
        let pathReference = self.storage.reference(withPath: "version.json")
        pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            guard let data = data else { return }
            do {
                let versions = try JSONDecoder().decode(Versions.self, from: data)

                let cacheURL = self.fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                let versionURL = cacheURL.appendingPathComponent("staticDataVersions.json")
                let fishURL = cacheURL.appendingPathComponent("fish.json")
                let insectURL = cacheURL.appendingPathComponent("insect.json")
                
                if let data = try? Data(contentsOf: versionURL),
                    let localVersions = try? JSONDecoder().decode(Versions.self, from: data) {
                        self.localVersions = localVersions
                }

                let dispatchGroup = DispatchGroup()
                self.fetchFishList(versions: versions, fishListURL: fishURL, dispatchGroup: dispatchGroup)
                self.fetchInsectList(versions: versions, insectListURL: insectURL, dispatchGroup: dispatchGroup)
                
                dispatchGroup.notify(queue: .global(qos: .background)) {
                    try? self.localVersions.toJSONString()?.write(to: versionURL, atomically: true, encoding: .utf8)
                    DispatchQueue.main.async {
                        return completion(true)
                    }
                }
            } catch {
                print(error.localizedDescription)
                return completion(false)
            }
        }
    }
    
    private func fetchFishList(versions: Versions, fishListURL: URL, dispatchGroup: DispatchGroup) {
        if localVersions.fish >= versions.fish,
           let fishData = try? Data(contentsOf: fishListURL),
            let fishList = try? JSONDecoder().decode([Fish].self, from: fishData) {
            fishListSubject.send(fishList)
        } else {
            dispatchGroup.enter()
            let pathReference = self.storage.reference(withPath: "fish.json")
            pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                guard let data = data else { return }
                do {
                    let fishList = try JSONDecoder().decode([Fish].self, from: data)
                    self.fishListSubject.send(fishList)
                    try fishList.toJSONString()?.write(to: fishListURL, atomically: true, encoding: .utf8)
                    self.localVersions.fish = versions.fish
                    dispatchGroup.leave()
                } catch {
                    print(error.localizedDescription)
                    dispatchGroup.leave()
                }
            }
        }
    }
    
    private func fetchInsectList(versions: Versions, insectListURL: URL, dispatchGroup: DispatchGroup) {
        if localVersions.insect >= versions.insect,
           let insectData = try? Data(contentsOf: insectListURL),
            let insectList = try? JSONDecoder().decode([Insect].self, from: insectData) {
            insectListSubject.send(insectList)
        } else {
            dispatchGroup.enter()
            let pathReference = self.storage.reference(withPath: "insect.json")
            pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                guard let data = data else { return }
                do {
                    let insectList = try JSONDecoder().decode([Insect].self, from: data)
                    self.insectListSubject.send(insectList)
                    try insectList.toJSONString()?.write(to: insectListURL, atomically: true, encoding: .utf8)
                    self.localVersions.insect = versions.insect
                    dispatchGroup.leave()
                } catch {
                    print(error.localizedDescription)
                    dispatchGroup.leave()
                }
            }
        }
    }
}

extension String {

    func jsonDecode<D: Decodable>(type: D.Type, decoder: JSONDecoder = JSONDecoder()) throws -> D {
        guard let data = data(using: .utf8) else { throw NSError(domain: "UnknownError", code: -1) }
        return try decoder.decode(type, from: data)
    }
}

extension Encodable {
    func toJSONString(encoder: JSONEncoder = JSONEncoder()) -> String? {
        let data = try? encoder.encode(self)
        return data?.string(encoding: .utf8)
    }

    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
