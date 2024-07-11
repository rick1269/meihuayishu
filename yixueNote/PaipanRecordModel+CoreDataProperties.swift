//
//  PaipanRecordModel+CoreDataProperties.swift
//  yixueNote
//
//  Created by rick qiu on 2024/7/11.
//
//

import Foundation
import CoreData


extension PaipanRecordModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PaipanRecordModel> {
        return NSFetchRequest<PaipanRecordModel>(entityName: "PaipanRecordModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var selectedDate: Date?
    @NSManaged public var selectedLunarDate: String?
    @NSManaged public var zhuGuaXu: Int32
    @NSManaged public var dongYao: Int32
    @NSManaged public var question: String?
    @NSManaged public var feedback: String?

}

extension PaipanRecordModel : Identifiable {

}
