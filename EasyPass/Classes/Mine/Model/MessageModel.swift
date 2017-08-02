//
//	MessageModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class MessageModel : NSObject, NSCoding, Mappable{

	var createTime : String?
	var id : Int?
	var modifyTime : String?
	var msgDetail : String?
	var msgHeader : String?
	var msgType : Int?
	var pushStatus : Int?


	class func newInstance(map: Map) -> Mappable?{
		return MessageModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		createTime <- map["createTime"]
		id <- map["id"]
		modifyTime <- map["modifyTime"]
		msgDetail <- map["msgDetail"]
		msgHeader <- map["msgHeader"]
		msgType <- map["msgType"]
		pushStatus <- map["pushStatus"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         createTime = aDecoder.decodeObject(forKey: "createTime") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         modifyTime = aDecoder.decodeObject(forKey: "modifyTime") as? String
         msgDetail = aDecoder.decodeObject(forKey: "msgDetail") as? String
         msgHeader = aDecoder.decodeObject(forKey: "msgHeader") as? String
         msgType = aDecoder.decodeObject(forKey: "msgType") as? Int
         pushStatus = aDecoder.decodeObject(forKey: "pushStatus") as? Int

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
		if modifyTime != nil{
			aCoder.encode(modifyTime, forKey: "modifyTime")
		}
		if msgDetail != nil{
			aCoder.encode(msgDetail, forKey: "msgDetail")
		}
		if msgHeader != nil{
			aCoder.encode(msgHeader, forKey: "msgHeader")
		}
		if msgType != nil{
			aCoder.encode(msgType, forKey: "msgType")
		}
		if pushStatus != nil{
			aCoder.encode(pushStatus, forKey: "pushStatus")
		}

	}

}