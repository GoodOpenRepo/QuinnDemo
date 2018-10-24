//
//  CustomCombinationModels.swift
//  AutoChooseWatermark
//
//  Created by Quinn on 2018/10/24.
//  Copyright © 2018 Quinn. All rights reserved.
//

import UIKit

class CustomCombinationModel:Codable{
    var timeInfo:WatermarkTimeInfoModel?
    var loaction:WatermarkLoactionInfoModel?
    var coord:WatermarkCoordInfoModel?
    var altitude:WatermarkAltitudeInfoModel?
    var weather:WatermarkWeatherInfoModel?
    var title:String?
}

class WatermarkTimeInfoModel:Codable{
    var open:Bool = false
    var style = 0
}
class WatermarkLoactionInfoModel:Codable{
    var open:Bool = false
    var defaultContent:String = "未知"
}

class WatermarkCoordInfoModel:Codable{
    var open:Bool = false
    var style = 0
}
class WatermarkAltitudeInfoModel:Codable{
    var open:Bool = false
}
class WatermarkWeatherInfoModel:Codable{
    var open:Bool = false
}



class CustomCombinationDataManager {
    var customCombinationModel:CustomCombinationModel?

    static let shared = CustomCombinationDataManager()
    private init(){
        moveCustomCombinationJson()
    }
    func saveCustomCombinationModelData(){
        saveCustomCombinationModel(model: customCombinationModel)
    }
    private func saveCustomCombinationModel(model:CustomCombinationModel?){
        
        guard let _model = model else {
            return
        }
        do{
            let data = try JSONEncoder.init().encode(_model)
            
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileName = "CustomCombinationModel" + ".json"
            let url = path.appendingPathComponent(fileName)
            if FileManager.default.fileExists(atPath: url.path){
                try? FileManager.default.removeItem(at: url)
            }
            do {
                try data.write(to: url)
                
            }catch{
                
            }
            
        }catch{
            
        }

    }
    private func moveCustomCombinationJson(){
        
        guard let path = Bundle.main.path(forResource: "CustomCombinationModel", ofType: "json") else{
            return
        }
        
        let url = URL.init(fileURLWithPath: path, isDirectory: true)
        let des_path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "CustomCombinationModel" + ".json"
        let des_url = des_path.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: des_url.path){
            try? FileManager.default.removeItem(at: des_url)
        }
        do{
            try FileManager.default.copyItem(at: url, to: des_url)
        }catch{
            print(error)
        }
    }
    func getCustomCombinationModel()->CustomCombinationModel?{

        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "CustomCombinationModel" + ".json"
        let url = path.appendingPathComponent(fileName)
        
        guard let data = try? Data.init(contentsOf: url) else{
            return nil
        }
        
        do{
            let model = try JSONDecoder.init().decode(CustomCombinationModel.self, from: data)
            customCombinationModel = model
            return model
        }catch{
            return nil
        }
    }
}
