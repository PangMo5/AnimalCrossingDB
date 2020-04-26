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
import SwiftyUserDefaults
import SystemConfiguration

public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        /* Only Working for WIFI
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired

        return isReachable && !needsConnection
        */

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}

final class StorageManager {
    
    enum StaticResponse {
        case error
        case someData
        case success
    }
    
    static let shared = StorageManager()
    
    fileprivate let storage = Storage.storage()
    
    @SwiftyUserDefault(keyPath: \.hemisphere)
    fileprivate var hemisphereDefault: Hemisphere
    
    let fileManager = FileManager.default
    lazy var cacheURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    
    var localVersions = Versions(fish: 0, insect: 0, art: 0, fishImage: 0, insectImage: 0, artImage: 0)
    
    var fishImageList = [Int: UIImage]()
    var insectImageList = [Int: UIImage]()
    var artImageList = [Int: [UIImage]]()
    
    let fishListSubject = CurrentValueSubject<[Fish], Never>([])
    let insectListSubject = CurrentValueSubject<[Insect], Never>([])
    let artListSubject = CurrentValueSubject<[Art], Never>([])
    
    init() {
    }
    
    func fetchStaticData(completion: @escaping ((StaticResponse) -> Void)) {
        guard Reachability.isConnectedToNetwork() else {
            self.fetchStaticData(data: nil, completion: completion)
            return
        }
        Auth.auth().signInAnonymously { user, error in
            guard error == nil else { return }
            let pathReference = self.storage.reference(withPath: "version.json")
            pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                self.fetchStaticData(data: data, completion: completion)
            }
        }
    }
    
    fileprivate func fetchStaticData(data: Data?, completion: @escaping ((StaticResponse) -> Void)) {
        do {
            let versions: Versions
            
            if let data = data {
                versions = try JSONDecoder().decode(Versions.self, from: data)
            } else {
                versions = Versions(fish: 0, insect: 0, art: 0, fishImage: 0, insectImage: 0, artImage: 0)
            }
            
            let versionURL = self.cacheURL.appendingPathComponent("staticDataVersions.json")
            
            if let data = try? Data(contentsOf: versionURL),
                let localVersions = try? JSONDecoder().decode(Versions.self, from: data) {
                self.localVersions = localVersions
            }
            
            let dispatchGroup = DispatchGroup()
            self.fetchFishList(versions: versions, dispatchGroup: dispatchGroup)
            self.fetchFishImage(versions: versions, dispatchGroup: dispatchGroup)
            self.fetchInsectList(versions: versions, dispatchGroup: dispatchGroup)
            self.fetchInsectImage(versions: versions, dispatchGroup: dispatchGroup)
            self.fetchArtList(versions: versions, dispatchGroup: dispatchGroup)
            self.fetchArtImage(versions: versions, dispatchGroup: dispatchGroup)
            
            dispatchGroup.notify(queue: .global(qos: .background)) {
                try? self.localVersions.toJSONString()?.write(to: versionURL, atomically: true, encoding: .utf8)
                DispatchQueue.main.async {
                    return completion(.success)
                }
            }
        } catch {
            print(error.localizedDescription)
            return completion(.error)
        }
    }
    
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
    
    private func fetchInsectImage(versions: Versions, dispatchGroup: DispatchGroup) {
        let imageURL = cacheURL.appendingPathComponent("insect")
        let tempURL = cacheURL.appendingPathComponent("temp")
        if localVersions.insectImage >= versions.insectImage,
            let contents = try? self.fileManager.contentsOfDirectory(at: imageURL, includingPropertiesForKeys: nil),
            !contents.isEmpty {
            self.insectImageList = contents.toImageDict()
        } else {
            dispatchGroup.enter()
            try? self.fileManager.removeItem(at: tempURL)
            let pathReference = self.storage.reference(withPath: "insect.zip")
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
                    self.insectImageList = contents.toImageDict()
                    self.localVersions.insectImage = versions.insectImage
                    dispatchGroup.leave()
                } catch {
                    print(error.localizedDescription)
                    dispatchGroup.leave()
                }
            }
        }
    }
    
    private func fetchArtImage(versions: Versions, dispatchGroup: DispatchGroup) {
        let imageURL = cacheURL.appendingPathComponent("art")
        let tempURL = cacheURL.appendingPathComponent("temp")
        if localVersions.artImage >= versions.artImage,
            let contents = try? self.fileManager.contentsOfDirectory(at: imageURL, includingPropertiesForKeys: nil),
            !contents.isEmpty {
            self.artImageList = contents.toImagesDictForArt()
        } else {
            dispatchGroup.enter()
            try? self.fileManager.removeItem(at: tempURL)
            let pathReference = self.storage.reference(withPath: "art.zip")
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
                    self.artImageList = contents.toImagesDictForArt()
                    self.localVersions.artImage = versions.artImage
                    dispatchGroup.leave()
                } catch {
                    print(error.localizedDescription)
                    dispatchGroup.leave()
                }
            }
        }
    }
    
    private func fetchFishList(versions: Versions, dispatchGroup: DispatchGroup) {
        let fishURL = cacheURL.appendingPathComponent("fish_\(hemisphereDefault.rawValue)_v2.json")
        if localVersions.fish >= versions.fish,
           let fishData = try? Data(contentsOf: fishURL),
            let fishList = try? JSONDecoder().decode([Fish].self, from: fishData) {
            fishListSubject.value = fishList
        } else {
            dispatchGroup.enter()
            let pathReference = self.storage.reference(withPath: "fish_\(hemisphereDefault.rawValue)_v2.json")
            pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                guard let data = data else {
                    dispatchGroup.leave()
                    return
                }
                do {
                    let fishList = try JSONDecoder().decode([Fish].self, from: data)
                    self.fishListSubject.value = fishList
                    try data.write(to: fishURL)
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
        let insectURL = cacheURL.appendingPathComponent("insect_\(hemisphereDefault.rawValue).json")
        if localVersions.insect >= versions.insect,
           let insectData = try? Data(contentsOf: insectURL),
            let insectList = try? JSONDecoder().decode([Insect].self, from: insectData) {
            insectListSubject.value = insectList
        } else {
            dispatchGroup.enter()
            let pathReference = self.storage.reference(withPath: "insect_\(hemisphereDefault.rawValue).json")
            pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                guard let data = data else {
                    dispatchGroup.leave()
                    return
                }
                do {
                    let insectList = try JSONDecoder().decode([Insect].self, from: data)
                    self.insectListSubject.value = insectList
                    try data.write(to: insectURL)
                    self.localVersions.insect = versions.insect
                    dispatchGroup.leave()
                } catch {
                    print(error.localizedDescription)
                    dispatchGroup.leave()
                }
            }
        }
    }
    
    private func fetchArtList(versions: Versions, dispatchGroup: DispatchGroup) {
        let artURL = cacheURL.appendingPathComponent("art.json")
        if localVersions.art >= versions.art,
           let artData = try? Data(contentsOf: artURL),
            let artList = try? JSONDecoder().decode([Art].self, from: artData) {
            artListSubject.value = artList
        } else {
            dispatchGroup.enter()
            let pathReference = self.storage.reference(withPath: "art.json")
            pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                guard let data = data else {
                    dispatchGroup.leave()
                    return
                }
                do {
                    let artList = try JSONDecoder().decode([Art].self, from: data)
                    self.artListSubject.value = artList
                    try data.write(to: artURL)
                    self.localVersions.art = versions.art
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
    
    func toImagesDictForArt() -> [Int: [UIImage]] {
        var dict = [Int: [UIImage]]()
        forEach { url in
            guard let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else { return }
            let name = url.deletingPathExtension().lastPathComponent
            if name.contains("-"),
                let id = name.split(separator: "-").first.map(String.init)?.int {
                var images = dict[id] ?? []
                images.append(image)
                dict[id] = images
            } else if let id = name.int {
                var images = dict[id] ?? []
                images.insert(image, at: 0)
                dict[id] = images
            }
        }
        return dict
    }
}
