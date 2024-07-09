import SwiftUI

struct PaipanDetailView: View {
	@Environment(\.presentationMode) var presentationMode
	
	var selectedDate: Date
	var selectedLunarDate: String
	var zhuGuaXu: Int
	var dongYao: Int
	 
	@State private var question: String = ""
	@State private var feedback: String = ""
	@State private var screenWidth: CGFloat = ScreenSize.screenWidth
	@State private var screenHeight: CGFloat = ScreenSize.screenHeight
	@State private var showUnfoldButton = false

	
	var body: some View {
		ScrollView {
			VStack(spacing: screenHeight * 0.004) {
				Text("指定排盘")
					.font(.title)
					.frame(maxWidth: .infinity, alignment: .center)
				
				DateDisplayView(title: "公历", date: DateUtils.dateToString(selectedDate))
				
				DateDisplayView(title: "农历", date: selectedLunarDate)
				
				GanZhiView(selectedDate: selectedDate)
				
				HexagramSectionView(zhuGuaXu: zhuGuaXu, dongYao: dongYao, screenWidth: screenWidth, screenHeight: screenHeight)
				
				QuestionTextInputView(placeholder: "占问 所问之事", text: $question)
				
				FeedbackTextInputView(placeholder: "反馈 断语，分析", text: $feedback)
				
				Spacer()
				
				HStack {
					Spacer()
					if showUnfoldButton {
						// Save button
						Button(action: {
							let record = PaipanRecord(date: selectedDate,
													  zhuGuaName: "",
													  huGuaName: "",  // 替换为实际数据
													  bianGuaName: "",  // 替换为实际数据
													  question: question,
													  feedback: feedback)
							
							HistoryManager.shared.saveRecord(record)
						}) {
							Text("保存")
								.padding()
								.foregroundColor(.white)
								.background(Color.green)
								.cornerRadius(20)
								.shadow(radius: 5)
								.transition(.move(edge: .trailing))
						}

						
						// Share button
						Button(action: {
							// Implement share functionality
							print("Sharing")
						}) {
							Text("分享")
								.padding()
								.foregroundColor(.white)
								.background(Color.blue)
								.cornerRadius(20)
								.shadow(radius: 5)
								.transition(.move(edge: .trailing))
						}
					}
					
					// Plus button to toggle showUnfoldButton
					Button(action: {
						withAnimation {
							showUnfoldButton.toggle()
						}
					}) {
						Image(systemName: showUnfoldButton ? "minus" : "plus")
							.resizable()
							.frame(width: 50, height: 50)
							.foregroundColor(showUnfoldButton ? .white : .green)
							.background(Color.white)
							.clipShape(Circle())
							.shadow(radius: 5)
					}
				}
				.padding()
			}
			.padding()
		}
		.onTapGesture {
			UIApplication.shared.endEditing()
		}
		.onAppear() {
			screenWidth = ScreenSize.screenWidth
			screenHeight = ScreenSize.screenHeight
		}
	}
}

struct ScreenSize {
	static let screenWidth = UIScreen.main.bounds.size.width
	static let screenHeight = UIScreen.main.bounds.size.height
}


struct DateDisplayView: View {
	var title: String
	var date: String
	
	var body: some View {
		HStack {
			Text(title)
			Spacer()
			Text(date)
				.frame(maxWidth: .infinity, alignment: .center)
		}
		.padding()
	}
}

// Model for GanZhi data
class GanZhiModel: ObservableObject {
	
	@Published var nianGanZhi: String = "甲子"
	@Published var yueGanZhi: String = "甲子"
	@Published var riGanZhi: String = "甲子"
	@Published var shiGanZhi: String = "甲子"
	@Published var riKongWang: String = "[戌亥空]"
}

struct GanZhiView: View {
	private var selectedDate: Date // 外部传入的日期
	private var ganZhiModel = GanZhiModel()
	
	init(selectedDate: Date) {
		self.selectedDate = selectedDate
		// 计算四纲
		let ganzhiStr = DateUtils.SiGangGanZhi(from: selectedDate)
		let components = ganzhiStr.split(separator: " ")
		if components.count == 4 {
			ganZhiModel.nianGanZhi = String(components[0])
			ganZhiModel.yueGanZhi = String(components[1])
			ganZhiModel.riGanZhi = String(components[2])
			ganZhiModel.shiGanZhi = String(components[3])
		}
		
		// 计算日空亡
		let riKongWang = DateUtils.RiKongWang(from: selectedDate)
		ganZhiModel.riKongWang = String(riKongWang)
	}
	var body: some View {
		HStack {
			VStack {
				Text(ganZhiModel.nianGanZhi)
			}
			Spacer()
			VStack {
				Text(ganZhiModel.yueGanZhi)
			}
			Spacer()
			VStack {
				Text(ganZhiModel.riGanZhi)
			}
			Spacer()
			VStack {
				Text(ganZhiModel.shiGanZhi)
			}
			Spacer()
			VStack {
				Text(ganZhiModel.riKongWang)
			}
		}
		.padding()
	}
}

struct HexagramSectionView: View {
	var zhuGuaXu: Int
	var dongYao: Int
	var screenWidth: CGFloat
	var screenHeight: CGFloat
	
	init(zhuGuaXu: Int, dongYao: Int, screenWidth: CGFloat, screenHeight: CGFloat) {
		self.zhuGuaXu = zhuGuaXu
		self.dongYao = dongYao
		self.screenWidth = screenWidth
		self.screenHeight = screenHeight
	}
	
	var body: some View {
		
		HStack() {
			Spacer()
			ZhuGuaHexagramView(zhuGuaXu: zhuGuaXu, dongYao: dongYao, screenWidth: screenWidth, screenHeight: screenHeight)
			Spacer()
			HuGuaHexagramView(zhuGuaXu: zhuGuaXu, dongYao: dongYao, screenWidth: screenWidth, screenHeight: screenHeight)
			Spacer()
			Spacer()
			Spacer()
			BianGuaHexagramView(zhuGuaXu: zhuGuaXu, dongYao: dongYao, screenWidth: screenWidth, screenHeight: screenHeight)
			Spacer()
		}
		.padding()
	}
	
}

struct ZhuGuaHexagramView: View {
	var zhuGuaXu: Int
	var dongYao: Int
	var screenWidth: CGFloat
	var screenHeight: CGFloat
	private var Gua: [Bool]
	private var GuaName: String
	
	init(zhuGuaXu: Int, dongYao: Int, screenWidth: CGFloat, screenHeight: CGFloat) {
		self.zhuGuaXu = zhuGuaXu
		self.dongYao = dongYao
		self.screenWidth = screenWidth
		self.screenHeight = screenHeight
		self.Gua = [Bool](repeating: false, count: 6)
		self.GuaName = ""
		
		if let yinYangYaoCStr = getGuaYinYangYao(Int32(zhuGuaXu)) {
			let binaryString = String(cString: yinYangYaoCStr)
			for (index, char) in binaryString.enumerated() {
				Gua[index] = char == "1" ? true : false
			}
		} else {
			print("Failed to get valid C string")
			Gua = [Bool](repeating: true, count: 6)
		}
		
		// 计算卦名
		let binaryString = Gua.map { $0 ? "1" : "0" }.joined()
		if let guaXu = Int(binaryString, radix: 2) {
			if let guaNameCStr = getGuaName(Int32(guaXu)) {
				GuaName = String(cString: guaNameCStr)
			} else {
				print("Failed to get valid C string")
				GuaName = ""
			}
		} else {
			print("Failed to convert binary string to integer")
			GuaName = ""
		}
		
	}
	
	var body: some View {
		VStack(){
			HStack(){
				Text("[主]")
					.foregroundColor(.gray)
			}
			VStack() {
				ForEach((0..<6).reversed(), id: \.self) { index in
					HStack {
						VStack{
							Rectangle()
								.fill(Color.black)
								.frame(height: screenWidth * 0.022)
								.frame(width: screenWidth * 0.22)
								.overlay(
									!self.Gua[index] ? AnyView(
										HStack {
											Spacer()
											Rectangle()
												.fill(Color.white)
												.frame(width: screenWidth * 0.03)
											Spacer()
										}
									) : AnyView(EmptyView())
								)
						}
						
						VStack{
							Image(systemName: "circle")
								.foregroundColor(dongYao == index ? .red : .white)
								.font(.system(size: screenWidth * 0.022))
						}
					}
					Spacer()
				}
			}
			HStack(){
				Text(GuaName)
			}
		}
	}
}

struct HuGuaHexagramView: View {
	var zhuGuaXu: Int
	var dongYao: Int
	var screenWidth: CGFloat
	var screenHeight: CGFloat
	private var Gua: [Bool]
	private var GuaName: String
	
	init(zhuGuaXu: Int, dongYao: Int, screenWidth: CGFloat, screenHeight: CGFloat) {
		self.zhuGuaXu = zhuGuaXu
		self.dongYao = dongYao
		self.screenWidth = screenWidth
		self.screenHeight = screenHeight
		self.Gua = [Bool](repeating: false, count: 6)
		self.GuaName = ""
		
		if let yinYangYaoCStr = getGuaYinYangYao(Int32(zhuGuaXu)) {
			let binaryString = String(cString: yinYangYaoCStr)
			for (index, char) in binaryString.enumerated() {
				Gua[index] = char == "1" ? true : false
			}
		} else {
			print("Failed to get valid C string")
			Gua = [Bool](repeating: true, count: 6)
		}
		// 定义主卦中每个位置对应的互卦位置关系
		let mapping = [1, 2, 3, 2, 3, 4]
		var tempGua = [Bool](repeating: false, count: 6)
		for (index, value) in mapping.enumerated() {
			tempGua[index] = Gua[value]
		}
		Gua = tempGua
		// 计算卦名
		let binaryString = Gua.map { $0 ? "1" : "0" }.joined()
		if let guaXu = Int(binaryString, radix: 2) {
			if let guaNameCStr = getGuaName(Int32(guaXu)) {
				GuaName = String(cString: guaNameCStr)
			} else {
				print("Failed to get valid C string")
				GuaName = ""
			}
		} else {
			print("Failed to convert binary string to integer")
			GuaName = ""
		}
		
	}
	
	var body: some View {
		VStack(){
			HStack() {
				Text("[互]")
					.foregroundColor(.gray)
			}
			VStack() {
				ForEach((0..<6).reversed(), id: \.self) { index in
					HStack {
						Rectangle()
							.fill(Color.black)
							.frame(height: screenWidth * 0.022)
							.frame(width:screenWidth * 0.22)
							.overlay(
								!self.Gua[index] ? AnyView(
									HStack {
										Spacer()
										Rectangle()
											.fill(Color.white)
											.frame(width: screenWidth * 0.03)
										Spacer()
									}
								) : AnyView(EmptyView())
							)
					}
					Spacer()
				}
			}
			HStack() {
				Text(GuaName)
			}
		}
	}
}

struct BianGuaHexagramView: View {
	var zhuGuaXu: Int
	var dongYao: Int
	var screenWidth: CGFloat
	var screenHeight: CGFloat
	private var Gua: [Bool]
	private var GuaName: String
	
	init(zhuGuaXu: Int, dongYao: Int, screenWidth: CGFloat, screenHeight: CGFloat) {
		self.zhuGuaXu = zhuGuaXu
		self.dongYao = dongYao
		self.screenWidth = screenWidth
		self.screenHeight = screenHeight
		self.Gua = [Bool](repeating: false, count: 6)
		self.GuaName = ""
		
		if let yinYangYaoCStr = getGuaYinYangYao(Int32(zhuGuaXu)) {
			let binaryString = String(cString: yinYangYaoCStr)
			for (index, char) in binaryString.enumerated() {
				Gua[index] = char == "1" ? true : false
			}
		} else {
			print("Failed to get valid C string")
			Gua = [Bool](repeating: true, count: 6)
		}
		// 根据动爻计算变卦
		Gua[dongYao] = !Gua[dongYao]
		
		// 计算卦名
		let binaryString = Gua.map { $0 ? "1" : "0" }.joined()
		if let guaXu = Int(binaryString, radix: 2) {
			if let guaNameCStr = getGuaName(Int32(guaXu)) {
				GuaName = String(cString: guaNameCStr)
			} else {
				print("Failed to get valid C string")
				GuaName = ""
			}
		} else {
			print("Failed to convert binary string to integer")
			GuaName = ""
		}
		
	}
	var body: some View {
		VStack(){
			HStack() {
				Text("[变]")
					.foregroundColor(.gray)
			}
			VStack() {
				ForEach((0..<6).reversed(), id: \.self) { index in
					HStack {
						Rectangle()
							.fill(Color.black)
							.frame(height: screenWidth * 0.022)
							.frame(width: screenWidth * 0.22)
							.overlay(
								!self.Gua[index] ? AnyView(
									HStack {
										Spacer()
										Rectangle()
											.fill(Color.white)
											.frame(width: screenWidth * 0.03)
										Spacer()
									}
								) : AnyView(EmptyView())
							)
					}
					Spacer()
					
				}
			}
			HStack() {
				Text(GuaName)
			}
		}
	}
}

struct QuestionTextInputView: View {
	var placeholder: String
	@Binding var text: String
	
	var body: some View {
		VStack {
			TextField(placeholder, text: $text)
			.padding()
			.background(Color.gray.opacity(0.1))
			.cornerRadius(10)
			.padding(.horizontal)
			
			Spacer()
		}
	}
}

struct FeedbackTextInputView: View {
	var placeholder: String
	@Binding var text: String
	
	var body: some View {
		VStack {
			TextField(placeholder, text: $text)
			.padding()
			.background(Color.gray.opacity(0.1))
			.cornerRadius(10)
			.padding(.horizontal)
			
			Spacer()
		}
	}
}

extension UIApplication {
	func endEditing() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}

struct PaipanDetailView_Previews: PreviewProvider {
	static var previews: some View {
		PaipanDetailView(selectedDate: Date(), selectedLunarDate: "", zhuGuaXu: 0, dongYao: 0)
	}
}

// 记录卦例的信息
struct PaipanRecord: Codable, Identifiable {
	var id = UUID()
	var date: Date
	var zhuGuaName: String
	var huGuaName: String
	var bianGuaName: String
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
