//
//  Fish.swift
//  AnimalCrossingDB
//
//  Created by Shirou on 2020/03/31.
//  Copyright © 2020 Shirou. All rights reserved.
//

import Foundation

struct Fish: Collectible, Codable, Identifiable {
    
    enum Area: String, Codable {
        case pier = "Pier"
        case rainingSea = "Sea (Raining)"
        case sea = "Sea"
        case pond = "Pond"
        case riverMouth = "River (Mouth)"
        case riverClifftop = "River (Clifftop)"
        case river = "River"
        case riverClifftopPond = "River (Clifftop) Pond"
        
        var localized: String {
            switch self {
            case .pier:
                return "부두"
            case .rainingSea:
                return "바다(비)"
            case .sea:
                return "바다"
            case .pond:
                return "연못"
            case .riverMouth:
                return "삼각주"
            case .riverClifftop:
                return "절벽"
            case .river:
                return "강"
            case .riverClifftopPond:
                return "절벽, 연못"
            }
        }
    }
    
    enum Size: String, Codable {
        case thin = "좁음"
        case xSmall = "초소형"
        case small = "소형"
        case mediumFin = "중형\n(+지느러미)"
        case medium = "중형"
        case mediumLarge = "중대형"
        case large = "대형"
        case xLarge = "특대형"
        case xLargeHasFin = "특대형\n(+지느러미)"
        
        var localized: String {
            switch self {
            case .thin:
                return "좁음"
            case .xSmall:
                return "초소형"
            case .small:
                return "소형"
            case .mediumFin:
                return "중형 + 지느러미"
            case .medium:
                return "중형"
            case .mediumLarge:
                return "중대형"
            case .large:
                return "대형"
            case .xLarge:
                return "특대형"
            case .xLargeHasFin:
                return "특대형 + 지느러미"
            }
        }
    }
    
    
    var id: Int?
    var name: String?
    var englishName: String?
    var price: Int?
    var area: Area?
    var size: Size?
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

extension Fish {
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "명"
        case englishName = "영문명"
        case price = "가격"
        case area = "출현"
        case size = "크기__1"
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
