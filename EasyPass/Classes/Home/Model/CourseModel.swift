//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class CourseModel : NSObject, NSCoding, Mappable{

	var classHour : Int?//课时
	var classifyId : Int?//所属专业分类
	var collectFlag : Bool?//(ture:已收藏flase：没收藏)
	var collectNum : Int?//收藏人气
	var courseDetail : String?//课程详情
	var courseName : String?//课程名称
	var createTime : String?//创建时间
	var credit : Int?//学分
	var difficulty : Int?//难度（五颗星表示）
	var forCrowd : String?//适合人群
	var grade : Int?//年级
	var id : Int?
	var modifyTime : String?//修改时间
	var offset : Float?//折扣（0-100）
	var onTax : Float?//税额
	var photo : String?//课程封面图片
	var price : Float?//价格
    var priceIos : Float?//ios价格
	var shoppingCartPrice : Float?//购物车总价格
	var shoppingCartQuantity : Int?//购物车数量
	var studyGoal : String?//学习目标
	var tag : Int?//标签（0：视频课程 1：预约课程 2：学习小组）
	var teacher : String?//课程老师
	var teacherDesc : String?//老师描述
	var term : Int?//学期
	var video : String?//课程视频
	var videoHttpUrl : String?//视频外链
    var appleProductId : String?//苹果商店ID
    var buyFlag : Bool?//(ture:已购买flase：未购买)
    var courseHourBuyFlag : Bool?//(ture:已购买课时flase：未购买课时)
    var coverImg : String?//视频预览图

	class func newInstance(map: Map) -> Mappable?{
		return CourseModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		classHour <- map["classHour"]
		classifyId <- map["classifyId"]
		collectFlag <- map["collectFlag"]
		collectNum <- map["collectNum"]
		courseDetail <- map["courseDetail"]
		courseName <- map["courseName"]
		createTime <- map["createTime"]
		credit <- map["credit"]
		difficulty <- map["difficulty"]
		forCrowd <- map["forCrowd"]
		grade <- map["grade"]
		id <- map["id"]
		modifyTime <- map["modifyTime"]
		offset <- map["offset"]
		onTax <- map["onTax"]
		photo <- map["photo"]
		price <- map["price"]
        priceIos <- map["priceIos"]
		shoppingCartPrice <- map["shoppingCartPrice"]
		shoppingCartQuantity <- map["shoppingCartQuantity"]
		studyGoal <- map["studyGoal"]
		tag <- map["tag"]
		teacher <- map["teacher"]
		teacherDesc <- map["teacherDesc"]
		term <- map["term"]
		video <- map["video"]
		videoHttpUrl <- map["videoHttpUrl"]
        appleProductId <- map["appleProductId"]
        buyFlag <- map["buyFlag"]
        courseHourBuyFlag <- map["courseHourBuyFlag"]
        coverImg <- map["coverImg"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         classHour = aDecoder.decodeObject(forKey: "classHour") as? Int
         classifyId = aDecoder.decodeObject(forKey: "classifyId") as? Int
         collectFlag = aDecoder.decodeObject(forKey: "collectFlag") as? Bool
         collectNum = aDecoder.decodeObject(forKey: "collectNum") as? Int
         courseDetail = aDecoder.decodeObject(forKey: "courseDetail") as? String
         courseName = aDecoder.decodeObject(forKey: "courseName") as? String
         createTime = aDecoder.decodeObject(forKey: "createTime") as? String
         credit = aDecoder.decodeObject(forKey: "credit") as? Int
         difficulty = aDecoder.decodeObject(forKey: "difficulty") as? Int
         forCrowd = aDecoder.decodeObject(forKey: "forCrowd") as? String
         grade = aDecoder.decodeObject(forKey: "grade") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         modifyTime = aDecoder.decodeObject(forKey: "modifyTime") as? String
         offset = aDecoder.decodeObject(forKey: "offset") as? Float
         onTax = aDecoder.decodeObject(forKey: "onTax") as? Float
         photo = aDecoder.decodeObject(forKey: "photo") as? String
         price = aDecoder.decodeObject(forKey: "price") as? Float
         priceIos = aDecoder.decodeObject(forKey: "priceIos") as? Float
         shoppingCartPrice = aDecoder.decodeObject(forKey: "shoppingCartPrice") as? Float
         shoppingCartQuantity = aDecoder.decodeObject(forKey: "shoppingCartQuantity") as? Int
         studyGoal = aDecoder.decodeObject(forKey: "studyGoal") as? String
         tag = aDecoder.decodeObject(forKey: "tag") as? Int
         teacher = aDecoder.decodeObject(forKey: "teacher") as? String
         teacherDesc = aDecoder.decodeObject(forKey: "teacherDesc") as? String
         term = aDecoder.decodeObject(forKey: "term") as? Int
         video = aDecoder.decodeObject(forKey: "video") as? String
         videoHttpUrl = aDecoder.decodeObject(forKey: "videoHttpUrl") as? String
         appleProductId = aDecoder.decodeObject(forKey: "appleProductId") as? String
         buyFlag = aDecoder.decodeObject(forKey: "buyFlag") as? Bool
         courseHourBuyFlag = aDecoder.decodeObject(forKey: "courseHourBuyFlag") as? Bool
         coverImg = aDecoder.decodeObject(forKey: "coverImg") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if classHour != nil{
			aCoder.encode(classHour, forKey: "classHour")
		}
		if classifyId != nil{
			aCoder.encode(classifyId, forKey: "classifyId")
		}
		if collectFlag != nil{
			aCoder.encode(collectFlag, forKey: "collectFlag")
		}
		if collectNum != nil{
			aCoder.encode(collectNum, forKey: "collectNum")
		}
		if courseDetail != nil{
			aCoder.encode(courseDetail, forKey: "courseDetail")
		}
		if courseName != nil{
			aCoder.encode(courseName, forKey: "courseName")
		}
		if createTime != nil{
			aCoder.encode(createTime, forKey: "createTime")
		}
		if credit != nil{
			aCoder.encode(credit, forKey: "credit")
		}
		if difficulty != nil{
			aCoder.encode(difficulty, forKey: "difficulty")
		}
		if forCrowd != nil{
			aCoder.encode(forCrowd, forKey: "forCrowd")
		}
		if grade != nil{
			aCoder.encode(grade, forKey: "grade")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if modifyTime != nil{
			aCoder.encode(modifyTime, forKey: "modifyTime")
		}
		if offset != nil{
			aCoder.encode(offset, forKey: "offset")
		}
		if onTax != nil{
			aCoder.encode(onTax, forKey: "onTax")
		}
		if photo != nil{
			aCoder.encode(photo, forKey: "photo")
		}
		if price != nil{
			aCoder.encode(price, forKey: "price")
		}
        if priceIos != nil {
            aCoder.encode(priceIos, forKey: "priceIos")
        }
		if shoppingCartPrice != nil{
			aCoder.encode(shoppingCartPrice, forKey: "shoppingCartPrice")
		}
		if shoppingCartQuantity != nil{
			aCoder.encode(shoppingCartQuantity, forKey: "shoppingCartQuantity")
		}
		if studyGoal != nil{
			aCoder.encode(studyGoal, forKey: "studyGoal")
		}
		if tag != nil{
			aCoder.encode(tag, forKey: "tag")
		}
		if teacher != nil{
			aCoder.encode(teacher, forKey: "teacher")
		}
		if teacherDesc != nil{
			aCoder.encode(teacherDesc, forKey: "teacherDesc")
		}
		if term != nil{
			aCoder.encode(term, forKey: "term")
		}
		if video != nil{
			aCoder.encode(video, forKey: "video")
		}
		if videoHttpUrl != nil{
			aCoder.encode(videoHttpUrl, forKey: "videoHttpUrl")
		}
        if appleProductId != nil {
            aCoder.encode(appleProductId, forKey: "appleProductId")
        }
        if buyFlag != nil{
            aCoder.encode(buyFlag, forKey: "buyFlag")
        }
        if courseHourBuyFlag != nil {
            aCoder.encode(courseHourBuyFlag, forKey: "courseHourBuyFlag")
        }
        if coverImg != nil {
            aCoder.encode(coverImg, forKey: "coverImg")
        }

	}

}
