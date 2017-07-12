//
//	BannerModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class BannerModel : NSObject, NSCoding, Mappable{

	var content : String?
	var id : Int?
	var img : String?
	var sort : Int?
	var status : Int?
	var title : String?


	class func newInstance(map: Map) -> Mappable?{
		return BannerModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		content <- map["content"]
		id <- map["id"]
		img <- map["img"]
		sort <- map["sort"]
		status <- map["status"]
		title <- map["title"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         content = aDecoder.decodeObject(forKey: "content") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         img = aDecoder.decodeObject(forKey: "img") as? String
         sort = aDecoder.decodeObject(forKey: "sort") as? Int
         status = aDecoder.decodeObject(forKey: "status") as? Int
         title = aDecoder.decodeObject(forKey: "title") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if content != nil{
			aCoder.encode(content, forKey: "content")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if img != nil{
			aCoder.encode(img, forKey: "img")
		}
		if sort != nil{
			aCoder.encode(sort, forKey: "sort")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}

	}

}