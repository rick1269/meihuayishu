import Foundation

class DateUtils {
	static func dateToString(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy年 MM月 dd日 HH:mm"
		return formatter.string(from: date)
	}

	static func lunarDate(from date: Date) -> String {
		// 农历日期转换的占位符，可以根据实际需求实现
		return "二〇二四年五月廿四 亥时"
	}
}


