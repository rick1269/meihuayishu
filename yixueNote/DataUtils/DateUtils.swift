import SwiftUI

struct LunarDateSwift {
	var cYear: Int // 公历年
	var cMonth: Int // 公历月
	var cDay: Int // 公历日
	var cHour: Int // 公历时
	var cMinute: Int // 公历分
	
	var lYear: Int // 阴历年
	var lMonth: Int // 阴历月
	var lDay: Int // 阴历日
	
	var gzYear: String // 干支年
	var gzMonth: String // 干支月
	var gzDay: String // 干支日
	
	var animal: String // 生肖
	var iMonthCn: String // 阴历月中文
	var iDayCn: String // 阴历日中文
	
	var isLeap: Int // 是否是闰月
	var leap: Int // 闰月是哪个月
	
	var isTerm: Int // 是否是节气
	var term: String // 节气中文
	
	var nWeek: Int // 星期几
	var cWeek: String // 星期几中文
	
	var isToday: Int // 是否是今天
}


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




