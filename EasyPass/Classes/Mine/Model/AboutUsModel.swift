//
//	AboutUsModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class AboutUsModel : NSObject, NSCoding, Mappable{

	var descriptionField : String?
	var email : String?
	var id : Int?
	var logoImg : String?
	var modifyTime : String?
	var name : String?
	var qrCodeImg : String?
	var telephone : String?
	var wechatPublicNumber : String?


	class func newInstance(map: Map) -> Mappable?{
		return AboutUsModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		descriptionField <- map["description"]
		email <- map["email"]
		id <- map["id"]
		logoImg <- map["logoImg"]
		modifyTime <- map["modifyTime"]
		name <- map["name"]
		qrCodeImg <- map["qrCodeImg"]
		telephone <- map["telephone"]
		wechatPublicNumber <- map["wechatPublicNumber"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         descriptionField = aDecoder.decodeObject(forKey: "description") as? String
         email = aDecoder.decodeObject(forKey: "email") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         logoImg = aDecoder.decodeObject(forKey: "logoImg") as? String
         modifyTime = aDecoder.decodeObject(forKey: "modifyTime") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         qrCodeImg = aDecoder.decodeObject(forKey: "qrCodeImg") as? String
         telephone = aDecoder.decodeObject(forKey: "telephone") as? String
         wechatPublicNumber = aDecoder.decodeObject(forKey: "wechatPublicNumber") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if logoImg != nil{
			aCoder.encode(logoImg, forKey: "logoImg")
		}
		if modifyTime != nil{
			aCoder.encode(modifyTime, forKey: "modifyTime")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if qrCodeImg != nil{
			aCoder.encode(qrCodeImg, forKey: "qrCodeImg")
		}
		if telephone != nil{
			aCoder.encode(telephone, forKey: "telephone")
		}
		if wechatPublicNumber != nil{
			aCoder.encode(wechatPublicNumber, forKey: "wechatPublicNumber")
		}

	}

}