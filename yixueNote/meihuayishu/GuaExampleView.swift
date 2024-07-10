import SwiftUI

struct PaipanHistoryView: View {
	let dummyData = [
		GuaExample(selectedDate: Date(), selectedLunarDate: "农历日期1", zhuGuaXu: 12, dongYao: 1, question: "关于事业发展的问题", feedback: "家庭和谐的困扰"),
		GuaExample(selectedDate: Date(), selectedLunarDate: "农历日期2", zhuGuaXu: 44, dongYao: 2, question: "感情状况的咨询", feedback: "家庭和谐的困扰"),
		GuaExample(selectedDate: Date(), selectedLunarDate: "农历日期3", zhuGuaXu: 33, dongYao: 3, question: "家庭和谐的困扰", feedback: "家庭和谐的困扰"),
	]
	
	var body: some View {
		NavigationView {
			List {
				ForEach(dummyData) { example in
					NavigationLink(destination: PaipanDetailView(selectedDate: example.selectedDate, selectedLunarDate: example.selectedLunarDate, zhuGuaXu: example.zhuGuaXu, dongYao: example.dongYao)) {
						GuaExampleView(
							id: example.id,
							selectedDate: example.selectedDate,
							selectedLunarDate: example.selectedLunarDate,
							zhuGuaXu: example.zhuGuaXu,
							dongYao: example.dongYao,
							question: example.question,
							feedback: example.feedback
						)
					}
				}
			}
		}
	}
}

struct GuaExample: Identifiable {
	var id = UUID()
	var selectedDate: Date
	var selectedLunarDate: String
	var zhuGuaXu: Int
	var dongYao: Int
	var question: String
	var feedback: String
}



struct GuaExampleView: View {
	var id : UUID
	var selectedDate: Date
	var selectedLunarDate: String
	var zhuGuaXu: Int
	var dongYao: Int
	var question: String
	var feedback: String
	
	private var zhuGuaName: String
	private var bianGuaName : String
	
	init(id: UUID, selectedDate: Date, selectedLunarDate: String, zhuGuaXu: Int, dongYao: Int, question: String, feedback: String) {
		self.id = id
		self.selectedDate = selectedDate
		self.selectedLunarDate = selectedLunarDate
		self.zhuGuaXu = zhuGuaXu
		self.dongYao = dongYao
		self.question = question
		self.feedback = feedback
		
		if let guaNameCStr = getGuaName(Int32(zhuGuaXu)) {
			zhuGuaName = String(cString: guaNameCStr)
		} else {
			print("Failed to get valid C string")
			zhuGuaName = ""
		}
		
		var tempGua = [Bool](repeating: false, count: 6)
		if let yinYangYaoCStr = getGuaYinYangYao(Int32(zhuGuaXu)) {
			let binaryString = String(cString: yinYangYaoCStr)
			for (index, char) in binaryString.enumerated() {
				tempGua[index] = char == "1" ? true : false
			}
		} else {
			print("Failed to get valid C string")
			tempGua = [Bool](repeating: true, count: 6)
		}
		// 根据动爻计算变卦
		tempGua[dongYao] = !tempGua[dongYao]
		
		// 计算卦名
		let binaryString = tempGua.map { $0 ? "1" : "0" }.joined()
		if let guaXu = Int(binaryString, radix: 2) {
			if let guaNameCStr = getGuaName(Int32(guaXu)) {
				bianGuaName = String(cString: guaNameCStr)
			} else {
				print("Failed to get valid C string")
				bianGuaName = ""
			}
		} else {
			print("Failed to convert binary string to integer")
			bianGuaName = ""
		}
	}
	
	var body: some View {
		HStack(){
			VStack(alignment: .leading) {
				Text("\(zhuGuaName) 之 \(bianGuaName)")
					.font(.headline)
					.lineLimit(1)
					.padding(.bottom, 4)
				
				Text("\(selectedLunarDate)")
					.font(.caption)
					.foregroundColor(.gray)
					.lineLimit(1)
				
				Text("\(question)")
					.font(.subheadline)
					.foregroundColor(.gray)
					.lineLimit(1)
					.truncationMode(.tail)
			} 
		}
	}
}

// 记录卦例的信息
struct PaipanRecord: Codable, Identifiable {
	var id = UUID()
	var selectedDate: Date
	var selectedLunarDate: String
	var zhuGuaXu: Int
	var dongYao: Int
	var question: String
	var feedback: String
}

//实现存储管理
class HistoryManager {
	static let shared = HistoryManager()
	private let key = "paipan_history"
	
	func saveRecord(_ record: PaipanRecord) {
		var records = loadRecords()
		records.append(record)
		
		let encoder = JSONEncoder()
		if let encoded = try? encoder.encode(records) {
			UserDefaults.standard.set(encoded, forKey: key)
		}
	}
	
	func loadRecords() -> [PaipanRecord] {
		if let data = UserDefaults.standard.data(forKey: key) {
			let decoder = JSONDecoder()
			if let decoded = try? decoder.decode([PaipanRecord].self, from: data) {
				return decoded
			}
		}
		return []
	}
}
