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
import ZIPFoundation

final class StorageManager {
    
    static let shared = StorageManager()
    
    fileprivate let storage = Storage.storage()
    
    let fileManager = FileManager.default
    lazy var cacheURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    
    var localVersions = Versions(fish: 0, insect: 0, fishImage: 0, insectImage: 0)
    
    var fishImageList = [Int: UIImage]()
    var insectImageList = [Int: UIImage]()
    
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
                
                let versionURL = self.cacheURL.appendingPathComponent("staticDataVersions.json")
                
                if let data = try? Data(contentsOf: versionURL),
                    let localVersions = try? JSONDecoder().decode(Versions.self, from: data) {
                        self.localVersions = localVersions
                }

                let dispatchGroup = DispatchGroup()
                self.fetchFishList(versions: versions, dispatchGroup: dispatchGroup)
                self.fetchFishImage(versions: versions, dispatchGroup: dispatchGroup)
                self.fetchInsectList(versions: versions, dispatchGroup: dispatchGroup)
                
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
//    let fileManager = FileManager()
//    let currentWorkingPath = fileManager.currentDirectoryPath
//    var sourceURL = URL(fileURLWithPath: currentWorkingPath)
//    sourceURL.appendPathComponent("archive.zip")
//    var destinationURL = URL(fileURLWithPath: currentWorkingPath)
//    destinationURL.appendPathComponent("directory")
//    do {
//        try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
//        try fileManager.unzipItem(at: sourceURL, to: destinationURL)
//    } catch {
//        print("Extraction of ZIP archive failed with error:\(error)")
//    }
    private func fetchFishImage(versions: Versions, dispatchGroup: DispatchGroup) {
        let imageURL = cacheURL.appendingPathComponent("fish")
        let tempURL = cacheURL.appendingPathComponent("temp")
        if localVersions.fishImage >= versions.fishImage,
            let contents = try? self.fileManager.contentsOfDirectory(at: imageURL, includingPropertiesForKeys: nil),
            !contents.isEmpty {
            self.fishImageList = contents.toImageDict()
        } else {
            dispatchGroup.enter()
            try? self.fileManager.removeItem(at: tempURL)
            let pathReference = self.storage.reference(withPath: "fish.zip")
            pathReference.write(toFile: tempURL) { url, error in
                guard let url = url else {
                    dispatchGroup.leave()
                    return
                }
                do {
                    try? self.fileManager.removeItem(at: imageURL)
                    try? self.fileManager.removeItem(at: self.cacheURL.appendingPathComponent("__MACOSX"))
                    try self.fileManager.unzipItem(at: url, to: self.cacheURL)
                    let contents = try self.fileManager.contentsOfDirectory(at: imageURL, includingPropertiesForKeys: nil)
                    self.fishImageList = contents.toImageDict()
                    self.localVersions.fishImage = versions.fishImage
                    dispatchGroup.leave()
                } catch {
                    print(error.localizedDescription)
                    dispatchGroup.leave()
                }
            }
        }
    }
    
    private func fetchFishList(versions: Versions, dispatchGroup: DispatchGroup) {
        let fishURL = cacheURL.appendingPathComponent("fish.json")
        if localVersions.fish >= versions.fish,
           let fishData = try? Data(contentsOf: fishURL),
            let fishList = try? JSONDecoder().decode([Fish].self, from: fishData) {
            fishListSubject.send(fishList)
        } else {
            dispatchGroup.enter()
            let pathReference = self.storage.reference(withPath: "fish.json")
            pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                guard let data = data else {
                    dispatchGroup.leave()
                    return
                }
                do {
                    let fishList = try JSONDecoder().decode([Fish].self, from: data)
                    self.fishListSubject.send(fishList)
                    try fishList.toJSONString()?.write(to: fishURL, atomically: true, encoding: .utf8)
                    self.localVersions.fish = versions.fish
                    dispatchGroup.leave()
                } catch {
                    print(error.localizedDescription)
                    dispatchGroup.leave()
                }
            }
        }
    }
    
    private func fetchInsectList(versions: Versions, dispatchGroup: DispatchGroup) {
        let insectURL = cacheURL.appendingPathComponent("insect.json")
        if localVersions.insect >= versions.insect,
           let insectData = try? Data(contentsOf: insectURL),
            let insectList = try? JSONDecoder().decode([Insect].self, from: insectData) {
            insectListSubject.send(insectList)
        } else {
            dispatchGroup.enter()
            let pathReference = self.storage.reference(withPath: "insect.json")
            pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                guard let data = data else {
                    dispatchGroup.leave()
                    return
                }
                do {
                    let insectList = try JSONDecoder().decode([Insect].self, from: data)
                    self.insectListSubject.send(insectList)
                    try insectList.toJSONString()?.write(to: insectURL, atomically: true, encoding: .utf8)
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

extension Array where Element == URL {
    
    func toImageDict() -> [Int: UIImage] {
        compactMap { url -> (Int, UIImage)? in
            guard let data = try? Data(contentsOf: url),
                let id = url.deletingPathExtension().lastPathComponent.int,
                let image = UIImage(data: data) else { return nil }
            return (id, image)
        }.reduce(into: [:]) { $0[$1.0] = $1.1 }
    }
}
