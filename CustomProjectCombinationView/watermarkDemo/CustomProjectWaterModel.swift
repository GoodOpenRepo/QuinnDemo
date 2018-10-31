import UIKit
class CustomProjectWaterModel:Codable{
    var name : CustomProjectName?
    var area : CustomProjectArea?
    var content:CustomProjectContent?
    var people:CustomProjectPeolpe?
    var supervision:CustomProjectSupervision?
    var currentTime:CustomProjectCurrentTime?
    var location:CustomProjectLocation?
    var constructionUnit:CustomProjectConstructionUnit?
    var supervisionUnit:CustomProjectSupervisionUnit?
    var buildUnit:CustomProjectBuildUnit?
    var otherInfo:String?
}

protocol CustomProjectProtocol:class {
    var open:Bool{get set}
    var content:String{get set}

}
protocol CustomProjectStyleProtocol:class{
    var style:Int{get set}
}


//工程名称
class CustomProjectName:Codable,CustomProjectProtocol{
    var open:Bool = false
    var content:String = ""
}
//工程区域
class CustomProjectArea:Codable,CustomProjectProtocol{
    var open:Bool = false
    var content:String = ""
}
//工程内容
class CustomProjectContent:Codable,CustomProjectProtocol{
    var open:Bool = false
    var content:String = ""
}
//工程人员
class CustomProjectPeolpe:Codable,CustomProjectProtocol{
    var open:Bool = false
    var content:String = ""
}
//监理
class CustomProjectSupervision:Codable,CustomProjectProtocol{
    var open:Bool = false
    var content:String = ""
}
//拍摄时间
class CustomProjectCurrentTime:Codable,CustomProjectProtocol,CustomProjectStyleProtocol{
    var open:Bool = false
    var style = 0
    var content:String = ""
}
//地点
class CustomProjectLocation:Codable,CustomProjectProtocol,CustomProjectStyleProtocol{
    var open:Bool = false
    var style = 0
    var content:String = ""
}
//施工单位
class CustomProjectConstructionUnit:Codable,CustomProjectProtocol{
    var open:Bool = false
    var content:String = ""
}
//监理单位
class CustomProjectSupervisionUnit:Codable,CustomProjectProtocol{
    var open:Bool = false
    var content:String = ""
}

//建设单位
class CustomProjectBuildUnit:Codable,CustomProjectProtocol{
    var open:Bool = false
    var content:String = ""
}




class CustomProjectCombinationDataManager {
    var customProjectWaterModel:CustomProjectWaterModel?
    
    static let shared = CustomProjectCombinationDataManager()
    private init(){
        moveCustomProjectCombinationJson()
    }
    func saveCustomCombinationModelData(){
        saveCustomProjectCombinationModel(model: customProjectWaterModel)
    }
    private func saveCustomProjectCombinationModel(model:CustomProjectWaterModel?){
        
        guard let _model = model else {
            return
        }
        do{
            let data = try JSONEncoder.init().encode(_model)
            let str = String.init(data: data, encoding: .utf8)
            print("\n\n",str)
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileName = "CustomProjectCombinationModel" + ".json"
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
    private func moveCustomProjectCombinationJson(){
        
        guard let path = Bundle.main.path(forResource: "CustomProjectCombinationModel", ofType: "json") else{
            return
        }
        
        let url = URL.init(fileURLWithPath: path, isDirectory: true)
        let des_path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "CustomProjectCombinationModel" + ".json"
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
    func getCustomProjectCombinationModel()->CustomProjectWaterModel?{
        
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "CustomProjectCombinationModel" + ".json"
        let url = path.appendingPathComponent(fileName)
        
        guard let data = try? Data.init(contentsOf: url) else{
            return nil
        }
        let str = String.init(data: data, encoding: .utf8)
        print("\n\n",str)
        do{
            let model = try JSONDecoder.init().decode(CustomProjectWaterModel.self, from: data)
            customProjectWaterModel = model
            return model
        }catch{
            return nil
        }
    }
}
