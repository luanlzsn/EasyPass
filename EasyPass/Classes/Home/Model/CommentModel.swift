//
//	CommentModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class CommentModel : NSObject, NSCoding, Mappable{

	var content : String?//评论内容
	var courseId : Int?//课程id
	var createTime : String?//评论时间
	var headImg : String?//用户头像
	var id : Int?
	var nickName : String?//用户昵称
	var status : Int?//状态（0：正常1：待审核2：审核被拒）
	var userId : Int?//用户id


	class func newInstance(map: Map) -> Mappable?{
		return CommentModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		content <- map["content"]
		courseId <- map["courseId"]
		createTime <- map["createTime"]
		headImg <- map["headImg"]
		id <- map["id"]
		nickName <- map["nickName"]
		status <- map["status"]
		userId <- map["userId"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         content = aDecoder.decodeObject(forKey: "content") as? String
         courseId = aDecoder.decodeObject(forKey: "courseId") as? Int
         createTime = aDecoder.decodeObject(forKey: "createTime") as? String
         headImg = aDecoder.decodeObject(forKey: "headImg") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         nickName = aDecoder.decodeObject(forKey: "nickName") as? String
         status = aDecoder.decodeObject(forKey: "status") as? Int
         userId = aDecoder.decodeObject(forKey: "userId") as? Int

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
		if courseId != nil{
			aCoder.encode(courseId, forKey: "courseId")
		}
		if createTime != nil{
			aCoder.encode(createTime, forKey: "createTime")
		}
		if headImg != nil{
			aCoder.encode(headImg, forKey: "headImg")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if nickName != nil{
			aCoder.encode(nickName, forKey: "nickName")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "userId")
		}

	}

}
