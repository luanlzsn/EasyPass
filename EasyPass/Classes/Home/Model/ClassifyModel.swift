//
//	ClassifyModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class ClassifyModel : NSObject, NSCoding, Mappable{

	var createTime : String?
	var id : Int?
	var img : String?
	var modifyTime : String?
	var name : String?
	var sort : Int?


	class func newInstance(map: Map) -> Mappable?{
		return ClassifyModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		createTime <- map["createTime"]
		id <- map["id"]
		img <- map["img"]
		modifyTime <- map["modifyTime"]
		name <- map["name"]
		sort <- map["sort"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         createTime = aDecoder.decodeObject(forKey: "createTime") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         img = aDecoder.decodeObject(forKey: "img") as? String
         modifyTime = aDecoder.decodeObject(forKey: "modifyTime") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         sort = aDecoder.decodeObject(forKey: "sort") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if createTime != nil{
			aCoder.encode(createTime, forKey: "createTime")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if img != nil{
			aCoder.encode(img, forKey: "img")
		}
		if modifyTime != nil{
			aCoder.encode(modifyTime, forKey: "modifyTime")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if sort != nil{
			aCoder.encode(sort, forKey: "sort")
		}

	}

}