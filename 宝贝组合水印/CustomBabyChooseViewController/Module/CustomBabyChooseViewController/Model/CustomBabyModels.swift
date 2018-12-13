//
//  CustomBabyModels.swift
//  CustomBabyChooseViewController
//
//  Created by Quinn on 2018/10/26.
//  Copyright © 2018 Quinn. All rights reserved.
//

import Foundation

class BabyDataManager:Codable{
    static let shared = BabyDataManager()
    private init(){}
    var watermarkBabyModels = WatermarkBabyModels()
    let placeHolderIndex = 1000
    
    
    func updateModel(newModel:WatermarkBabyModel){
        var index = -1
        watermarkBabyModels.models.forEach({ (model) in
            if model.index == newModel.index{
                index = model.index
            }
        })
        if index >= 0{
            watermarkBabyModels.models[index] = newModel
        }else{
            watermarkBabyModels.models.append(newModel)
        }
        saveWatermarkBabyModel(model: watermarkBabyModels)
    }
    
    func removeModel(index:Int){
        if index < watermarkBabyModels.models.count {
            watermarkBabyModels.models.remove(at: index)
            saveWatermarkBabyModel(model: watermarkBabyModels)
        }
    }
    func removePlaceHolderModel(){
        for (i,model) in watermarkBabyModels.models.enumerated(){
            if model.index == placeHolderIndex{
                removeModel(index: i)
            }
        }
    }
    func addPlaceHolderModel(){
        let model = WatermarkBabyModel.init(_name: "", _birth: "", _index: placeHolderIndex)
        watermarkBabyModels.models.append(model)
    }
    func saveWatermarkBabyModel(model:WatermarkBabyModels?){
        guard let _model = model else {
            return
        }
        watermarkBabyModels = _model
        do{
            let data = try JSONEncoder.init().encode(_model)
            let json = String.init(data: data, encoding: .utf8)
            print("\n\n",json,"\n\n")
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileName = "WatermarkBabyModels" + ".json"
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
    @discardableResult
    func getWatermarkBabyModel()->WatermarkBabyModels?{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "WatermarkBabyModels" + ".json"
        let url = path.appendingPathComponent(fileName)
        print(url)
        guard let data = try? Data.init(contentsOf: url) else{
            return nil
        }
        do{
            let model = try JSONDecoder.init().decode(WatermarkBabyModels.self, from: data)
            watermarkBabyModels = model
            return model
        }catch{
            return nil
        }
    }
}
class WatermarkBabyModel:Codable{
    
    var name:String
    var birth:String
    var index:Int
    
    init(_name:String,_birth:String,_index:Int) {
        name = _name
        birth = _birth
        index = _index
    }
}
class WatermarkBabyModels: Codable {
    var models:[WatermarkBabyModel] = [WatermarkBabyModel]()
}
