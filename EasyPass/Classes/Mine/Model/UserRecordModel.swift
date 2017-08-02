//
//	UserRecordModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class UserRecordModel : NSObject, NSCoding, Mappable{

	var createTime : String?
	var finishCourseHour : Int?
	var id : Int?
	var mofifyTime : String?
	var score : Int?
	var studyDayNum : Int?
	var userId : Int?


	class func newInstance(map: Map) -> Mappable?{
		return UserRecordModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		createTime <- map["createTime"]
		finishCourseHour <- map["finishCourseHour"]
		id <- map["id"]
		mofifyTime <- map["mofifyTime"]
		score <- map["score"]
		studyDayNum <- map["studyDayNum"]
		userId <- map["userId"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         createTime = aDecoder.decodeObject(forKey: "createTime") as? String
         finishCourseHour = aDecoder.decodeObject(forKey: "finishCourseHour") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         mofifyTime = aDecoder.decodeObject(forKey: "mofifyTime") as? String
         score = aDecoder.decodeObject(forKey: "score") as? Int
         studyDayNum = aDecoder.decodeObject(forKey: "studyDayNum") as? Int
         userId = aDecoder.decodeObject(forKey: "userId") as? Int

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
		if finishCourseHour != nil{
			aCoder.encode(finishCourseHour, forKey: "finishCourseHour")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if mofifyTime != nil{
			aCoder.encode(mofifyTime, forKey: "mofifyTime")
		}
		if score != nil{
			aCoder.encode(score, forKey: "score")
		}
		if studyDayNum != nil{
			aCoder.encode(studyDayNum, forKey: "studyDayNum")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "userId")
		}

	}

}