//
//	OrderModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class OrderModel : NSObject, NSCoding, Mappable{

	var orderDetail : [OrderItemModel]?
	var createTime : String?
	var id : Int?
	var orderNo : String?
	var orderStatus : Int?
	var orderTotalPrice : Float?
	var userId : Int?


	class func newInstance(map: Map) -> Mappable?{
		return OrderModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		orderDetail <- map["orderDetail"]
		createTime <- map["createTime"]
		id <- map["id"]
		orderNo <- map["orderNo"]
		orderStatus <- map["orderStatus"]
		orderTotalPrice <- map["orderTotalPrice"]
		userId <- map["userId"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         orderDetail = aDecoder.decodeObject(forKey: "orderDetail") as? [OrderItemModel]
         createTime = aDecoder.decodeObject(forKey: "createTime") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         orderNo = aDecoder.decodeObject(forKey: "orderNo") as? String
         orderStatus = aDecoder.decodeObject(forKey: "orderStatus") as? Int
         orderTotalPrice = aDecoder.decodeObject(forKey: "orderTotalPrice") as? Float
         userId = aDecoder.decodeObject(forKey: "userId") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if orderDetail != nil{
			aCoder.encode(orderDetail, forKey: "orderDetail")
		}
		if createTime != nil{
			aCoder.encode(createTime, forKey: "createTime")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if orderNo != nil{
			aCoder.encode(orderNo, forKey: "orderNo")
		}
		if orderStatus != nil{
			aCoder.encode(orderStatus, forKey: "orderStatus")
		}
		if orderTotalPrice != nil{
			aCoder.encode(orderTotalPrice, forKey: "orderTotalPrice")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "userId")
		}

	}

}
