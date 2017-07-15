//
//	ClassHourModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class ClassHourModel : NSObject, NSCoding, Mappable{

	var classHourName : String?//课时名称
	var content : String?//课时内容
	var courseId : Int?//课程id
	var createTime : String?//创建时间
	var id : Int?
	var lessionPeriod : String?//课时章节
	var modifyTime : String?//修改时间
	var price : Int?//课时价格
	var shoppingCartPrice : Double?//购物车总价格
	var shoppingCartQuantity : Int?//购物车数量
	var video : String?//课时视频
	var videoHttpUrl : String?//课时视频外部链接地址


	class func newInstance(map: Map) -> Mappable?{
		return ClassHourModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		classHourName <- map["classHourName"]
		content <- map["content"]
		courseId <- map["courseId"]
		createTime <- map["createTime"]
		id <- map["id"]
		lessionPeriod <- map["lessionPeriod"]
		modifyTime <- map["modifyTime"]
		price <- map["price"]
		shoppingCartPrice <- map["shoppingCartPrice"]
		shoppingCartQuantity <- map["shoppingCartQuantity"]
		video <- map["video"]
		videoHttpUrl <- map["videoHttpUrl"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         classHourName = aDecoder.decodeObject(forKey: "classHourName") as? String
         content = aDecoder.decodeObject(forKey: "content") as? String
         courseId = aDecoder.decodeObject(forKey: "courseId") as? Int
         createTime = aDecoder.decodeObject(forKey: "createTime") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         lessionPeriod = aDecoder.decodeObject(forKey: "lessionPeriod") as? String
         modifyTime = aDecoder.decodeObject(forKey: "modifyTime") as? String
         price = aDecoder.decodeObject(forKey: "price") as? Int
         shoppingCartPrice = aDecoder.decodeObject(forKey: "shoppingCartPrice") as? Double
         shoppingCartQuantity = aDecoder.decodeObject(forKey: "shoppingCartQuantity") as? Int
         video = aDecoder.decodeObject(forKey: "video") as? String
         videoHttpUrl = aDecoder.decodeObject(forKey: "videoHttpUrl") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if classHourName != nil{
			aCoder.encode(classHourName, forKey: "classHourName")
		}
		if content != nil{
			aCoder.encode(content, forKey: "content")
		}
		if courseId != nil{
			aCoder.encode(courseId, forKey: "courseId")
		}
		if createTime != nil{
			aCoder.encode(createTime, forKey: "createTime")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if lessionPeriod != nil{
			aCoder.encode(lessionPeriod, forKey: "lessionPeriod")
		}
		if modifyTime != nil{
			aCoder.encode(modifyTime, forKey: "modifyTime")
		}
		if price != nil{
			aCoder.encode(price, forKey: "price")
		}
		if shoppingCartPrice != nil{
			aCoder.encode(shoppingCartPrice, forKey: "shoppingCartPrice")
		}
		if shoppingCartQuantity != nil{
			aCoder.encode(shoppingCartQuantity, forKey: "shoppingCartQuantity")
		}
		if video != nil{
			aCoder.encode(video, forKey: "video")
		}
		if videoHttpUrl != nil{
			aCoder.encode(videoHttpUrl, forKey: "videoHttpUrl")
		}

	}

}
