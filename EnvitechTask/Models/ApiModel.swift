//
//  ApiModel.swift
//  EnvitechTask
//
//  Created by yaniv shtein on 02/01/2022.
//

import Foundation

class Api:Decodable{
    var MonitorType:[MonitorTypes]
    let Legends:[Legend]
    let Monitor:[Monitors]
    
}

class MonitorTypes:Decodable{
    var Id:Int
    var Name:String
    var LegendId:Int
    var description:String
}

class Legend:Decodable{
    var Id:Int
    var tags:[tag]
}

class tag:Decodable{
    var Label:String
    var Color:String
}
class Monitors:Decodable{
    var Id:Int
    var Name:String
    var Desc:String
    var MonitorTypeId:Int
}
