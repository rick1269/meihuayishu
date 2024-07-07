import SwiftUI

class DateUtils {
	static func dateToString(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy年 MM月 dd日 HH:mm"
		return formatter.string(from: date)
	}

	static func lunarDate(from date: Date) -> String {
		// 获取日期组件
		let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
		guard let year = components.year, let month = components.month, let day = components.day, let hour = components.hour, let minute = components.minute else {
			return "Invalid date"
		}
//		print("year: \(year), month: \(month), day: \(day), hour: \(hour), minute: \(minute)")
		
		// 调用C++函数获取农历日期
		guard let lunarDateCStr = getLunarDate(Int32(year), Int32(month), Int32(day), Int32(hour), Int32(minute)) else {
			return "Conversion failed"
		} 
		defer {
			free(UnsafeMutablePointer(mutating: lunarDateCStr))
		}
		let lunarDateStr = String(cString: lunarDateCStr)
		
//		print(" lunarDate : \(lunarDateStr)")
		return lunarDateStr
	}
}




