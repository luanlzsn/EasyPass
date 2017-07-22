//
//	ShopCartModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class ShopCartModel : NSObject, NSCoding, Mappable{

	var classHourName : String?
	var courseHourId : Int?
	var courseHourPrice : Float?
	var courseId : Int?
	var courseName : String?
	var courseOnTax : Float?
	var coursePrice : Float?
	var grade : Int?
	var gradeName : String?
	var id : Int?
	var lessonPeriod : String?
	var photo : String?
	var quantity : Int?
	var tag : Int?
	var tagName : String?
	var teacher : String?


	class func newInstance(map: Map) -> Mappable?{
		return ShopCartModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		classHourName <- map["classHourName"]
		courseHourId <- map["courseHourId"]
		courseHourPrice <- map["courseHourPrice"]
		courseId <- map["courseId"]
		courseName <- map["courseName"]
		courseOnTax <- map["courseOnTax"]
		coursePrice <- map["coursePrice"]
		grade <- map["grade"]
		gradeName <- map["gradeName"]
		id <- map["id"]
		lessonPeriod <- map["lessonPeriod"]
		photo <- map["photo"]
		quantity <- map["quantity"]
		tag <- map["tag"]
		tagName <- map["tagName"]
		teacher <- map["teacher"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         classHourName = aDecoder.decodeObject(forKey: "classHourName") as? String
         courseHourId = aDecoder.decodeObject(forKey: "courseHourId") as? Int
         courseHourPrice = aDecoder.decodeObject(forKey: "courseHourPrice") as? Float
         courseId = aDecoder.decodeObject(forKey: "courseId") as? Int
         courseName = aDecoder.decodeObject(forKey: "courseName") as? String
         courseOnTax = aDecoder.decodeObject(forKey: "courseOnTax") as? Float
         coursePrice = aDecoder.decodeObject(forKey: "coursePrice") as? Float
         grade = aDecoder.decodeObject(forKey: "grade") as? Int
         gradeName = aDecoder.decodeObject(forKey: "gradeName") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         lessonPeriod = aDecoder.decodeObject(forKey: "lessonPeriod") as? String
         photo = aDecoder.decodeObject(forKey: "photo") as? String
         quantity = aDecoder.decodeObject(forKey: "quantity") as? Int
         tag = aDecoder.decodeObject(forKey: "tag") as? Int
         tagName = aDecoder.decodeObject(forKey: "tagName") as? String
         teacher = aDecoder.decodeObject(forKey: "teacher") as? String

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
		if courseHourId != nil{
			aCoder.encode(courseHourId, forKey: "courseHourId")
		}
		if courseHourPrice != nil{
			aCoder.encode(courseHourPrice, forKey: "courseHourPrice")
		}
		if courseId != nil{
			aCoder.encode(courseId, forKey: "courseId")
		}
		if courseName != nil{
			aCoder.encode(courseName, forKey: "courseName")
		}
		if courseOnTax != nil{
			aCoder.encode(courseOnTax, forKey: "courseOnTax")
		}
		if coursePrice != nil{
			aCoder.encode(coursePrice, forKey: "coursePrice")
		}
		if grade != nil{
			aCoder.encode(grade, forKey: "grade")
		}
		if gradeName != nil{
			aCoder.encode(gradeName, forKey: "gradeName")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if lessonPeriod != nil{
			aCoder.encode(lessonPeriod, forKey: "lessonPeriod")
		}
		if photo != nil{
			aCoder.encode(photo, forKey: "photo")
		}
		if quantity != nil{
			aCoder.encode(quantity, forKey: "quantity")
		}
		if tag != nil{
			aCoder.encode(tag, forKey: "tag")
		}
		if tagName != nil{
			aCoder.encode(tagName, forKey: "tagName")
		}
		if teacher != nil{
			aCoder.encode(teacher, forKey: "teacher")
		}

	}

}
