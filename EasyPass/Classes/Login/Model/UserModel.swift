//
//	UserModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class UserModel : NSObject, NSCoding, Mappable{

	var createTime : String?
	var email : String?
	var headImg : String?
	var id : Int?
	var loginType : Int?
	var majorName : String?
	var modifyTime : String?
	var nickName : String?
	var password : String?
	var phone : String?
	var sexStr : String?
	var status : Int?
	var thirdIdWechat : String?
	var token : String?
	var userName : String?
	var wechatRad : Int?


	class func newInstance(map: Map) -> Mappable?{
		return UserModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		createTime <- map["createTime"]
		email <- map["email"]
		headImg <- map["headImg"]
		id <- map["id"]
		loginType <- map["loginType"]
		majorName <- map["majorName"]
		modifyTime <- map["modifyTime"]
		nickName <- map["nickName"]
		password <- map["password"]
		phone <- map["phone"]
		sexStr <- map["sexStr"]
		status <- map["status"]
		thirdIdWechat <- map["thirdIdWechat"]
		token <- map["token"]
		userName <- map["userName"]
		wechatRad <- map["wechatRad"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         createTime = aDecoder.decodeObject(forKey: "createTime") as? String
         email = aDecoder.decodeObject(forKey: "email") as? String
         headImg = aDecoder.decodeObject(forKey: "headImg") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         loginType = aDecoder.decodeObject(forKey: "loginType") as? Int
         majorName = aDecoder.decodeObject(forKey: "majorName") as? String
         modifyTime = aDecoder.decodeObject(forKey: "modifyTime") as? String
         nickName = aDecoder.decodeObject(forKey: "nickName") as? String
         password = aDecoder.decodeObject(forKey: "password") as? String
         phone = aDecoder.decodeObject(forKey: "phone") as? String
         sexStr = aDecoder.decodeObject(forKey: "sexStr") as? String
         status = aDecoder.decodeObject(forKey: "status") as? Int
         thirdIdWechat = aDecoder.decodeObject(forKey: "thirdIdWechat") as? String
         token = aDecoder.decodeObject(forKey: "token") as? String
         userName = aDecoder.decodeObject(forKey: "userName") as? String
         wechatRad = aDecoder.decodeObject(forKey: "wechatRad") as? Int

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
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if headImg != nil{
			aCoder.encode(headImg, forKey: "headImg")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if loginType != nil{
			aCoder.encode(loginType, forKey: "loginType")
		}
		if majorName != nil{
			aCoder.encode(majorName, forKey: "majorName")
		}
		if modifyTime != nil{
			aCoder.encode(modifyTime, forKey: "modifyTime")
		}
		if nickName != nil{
			aCoder.encode(nickName, forKey: "nickName")
		}
		if password != nil{
			aCoder.encode(password, forKey: "password")
		}
		if phone != nil{
			aCoder.encode(phone, forKey: "phone")
		}
		if sexStr != nil{
			aCoder.encode(sexStr, forKey: "sexStr")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if thirdIdWechat != nil{
			aCoder.encode(thirdIdWechat, forKey: "thirdIdWechat")
		}
		if token != nil{
			aCoder.encode(token, forKey: "token")
		}
		if userName != nil{
			aCoder.encode(userName, forKey: "userName")
		}
		if wechatRad != nil{
			aCoder.encode(wechatRad, forKey: "wechatRad")
		}

	}

}