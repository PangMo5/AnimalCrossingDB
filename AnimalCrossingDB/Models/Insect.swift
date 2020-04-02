//
//  Insect.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/04/02.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation
import UIKit

struct Insect: Collectible, Codable {
    
    enum Area: String, Codable {
        case head = "가려운 주민 머리"
        case river = "강"
        case riverPond = "강/연못"
        case stub = "그루터기"
        case flowerTop = "꽃위"
        case flowerTopWhite = "꽃위(흰꽃)"
        case flowerAround = "꽃주변"
        case matingFlowerAround = "꽃주변(교배꽃)"
        case wood = "나무기둥"
        case woodUnderCamouflage = "나무밑(도구로 위장)"
        case woodShake = "나무흔들기"
        case snowball = "눈덩이"
        case field = "들판"
        case rottenRadishOnTheGround = "바닥에 둔 썩은무"
        case garbageOnTheGround = "바닥에 둔 쓰레기"
        case rockUnder = "바위 밑"
        case rockRain = "바위(비)"
        case lightAround = "빛주변"
        case anywhere = "아무데나"
        case palmPillar = "야자기둥"
        case beach = "해변"
        case beachRock = "해변바위"
        case bowelsOfTheEarth = "땅속"
    }
    
    var id: Int?
    var name: String?
    var englishName: String?
    var price: Int?
    var area: Area?
    var availableTime: String?
    
    @IntBoolTransform
    var hour0: Bool
    @IntBoolTransform
    var hour1: Bool
    @IntBoolTransform
    var hour2: Bool
    @IntBoolTransform
    var hour3: Bool
    @IntBoolTransform
    var hour4: Bool
    @IntBoolTransform
    var hour5: Bool
    @IntBoolTransform
    var hour6: Bool
    @IntBoolTransform
    var hour7: Bool
    @IntBoolTransform
    var hour8: Bool
    @IntBoolTransform
    var hour9: Bool
    @IntBoolTransform
    var hour10: Bool
    @IntBoolTransform
    var hour11: Bool
    @IntBoolTransform
    var hour12: Bool
    @IntBoolTransform
    var hour13: Bool
    @IntBoolTransform
    var hour14: Bool
    @IntBoolTransform
    var hour15: Bool
    @IntBoolTransform
    var hour16: Bool
    @IntBoolTransform
    var hour17: Bool
    @IntBoolTransform
    var hour18: Bool
    @IntBoolTransform
    var hour19: Bool
    @IntBoolTransform
    var hour20: Bool
    @IntBoolTransform
    var hour21: Bool
    @IntBoolTransform
    var hour22: Bool
    @IntBoolTransform
    var hour23: Bool
    
    @IntBoolTransform
    var month1: Bool
    @IntBoolTransform
    var month2: Bool
    @IntBoolTransform
    var month3: Bool
    @IntBoolTransform
    var month4: Bool
    @IntBoolTransform
    var month5: Bool
    @IntBoolTransform
    var month6: Bool
    @IntBoolTransform
    var month7: Bool
    @IntBoolTransform
    var month8: Bool
    @IntBoolTransform
    var month9: Bool
    @IntBoolTransform
    var month10: Bool
    @IntBoolTransform
    var month11: Bool
    @IntBoolTransform
    var month12: Bool
}

extension Insect {
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "명"
        case englishName = "영문명"
        case price = "가격"
        case area = "출현장소"
        case availableTime = "출현시간"
        case hour0 = "00시"
        case hour1 = "01시"
        case hour2 = "02시"
        case hour3 = "03시"
        case hour4 = "04시"
        case hour5 = "05시"
        case hour6 = "06시"
        case hour7 = "07시"
        case hour8 = "08시"
        case hour9 = "09시"
        case hour10 = "10시"
        case hour11 = "11시"
        case hour12 = "12시"
        case hour13 = "13시"
        case hour14 = "14시"
        case hour15 = "15시"
        case hour16 = "16시"
        case hour17 = "17시"
        case hour18 = "18시"
        case hour19 = "19시"
        case hour20 = "20시"
        case hour21 = "21시"
        case hour22 = "22시"
        case hour23 = "23시"
        case month1 = "1月"
        case month2 = "2月"
        case month3 = "3月"
        case month4 = "4月"
        case month5 = "5月"
        case month6 = "6月"
        case month7 = "7月"
        case month8 = "8月"
        case month9 = "9月"
        case month10 = "10月"
        case month11 = "11月"
        case month12 = "12月"
    }
}

extension Insect {
    
    var image: UIImage {
        StorageManager.shared.insectImageList[id ?? 0] ?? UIImage(systemName: "ant.fill")!
    }
}

extension Insect {
    
    static var sampleInsect: Insect = .init(id: 1, name: "이름", englishName: "english name", price: 10000, area: .anywhere, availableTime: "All Days", hour0: true, hour1: true, hour2: true, hour3: true, hour4: true, hour5: true, hour6: true, hour7: true, hour8: true, hour9: true, hour10: true, hour11: true, hour12: true, hour13: true, hour14: true, hour15: true, hour16: true, hour17: true, hour18: true, hour19: true, hour20: true, hour21: true, hour22: true, hour23: true, month1: true, month2: true, month3: true, month4: true, month5: true, month6: true, month7: true, month8: true, month9: true, month10: true, month11: true, month12: true)
}
