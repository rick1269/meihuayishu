import SwiftUI

struct PaipanDetailView: View {
	@Environment(\.presentationMode) var presentationMode
	
	var selectedDate: Date
	var selectedLunarDate: String
	var zhuGuaXu: Int
	var dongYao: Int
	
	@State private var spacing: CGFloat = 10 // 初始间距
	@State private var question: String = ""
	@State private var feedback: String = ""
	@State private var screen_width: CGFloat = 100 // 初始间距
	@State private var screen_height: CGFloat = 100 // 初始间距
	
	var body: some View {
		GeometryReader { geometry in
			ScrollView {
				VStack(spacing: spacing) {
					Text("指定排盘")
						.font(.title)
						.frame(maxWidth: .infinity, alignment: .center)
					
					DateDisplayView(title: "公历", date: DateUtils.dateToString(selectedDate))
					
					DateDisplayView(title: "农历", date: selectedLunarDate)
					
					GanZhiView(selectedDate: selectedDate)
					
					HexagramSectionView(zhuGuaXu: zhuGuaXu, dongYao: dongYao, screen_width: screen_width, screen_height: screen_height)
					
					TextInputView(placeholder: "占问 所问之事", text: $question)
					
					TextInputView(placeholder: "反馈 断语，分析", text: $feedback)
					
					
					Spacer()
					
					HStack {
						Spacer()
						Button(action: {
							// Save to cloud action
						}) {
							Image(systemName: "plus")
								.resizable()
								.frame(width: 50, height: 50)
								.foregroundColor(.green)
								.background(Color.white)
								.clipShape(Circle())
								.shadow(radius: 5)
						}
					}
					.padding()
				}
				.padding()
				.onAppear() {
					screen_width = geometry.size.width
					screen_height = geometry.size.height
				}
				.onChange(of: geometry.size.height) { new_height in
					if(new_height > 500){
						spacing = 10
					}else{
						spacing = 5
					}
				}
			}
		}
		.onAppear {
			// Fetch or initialize ganZhiModel data here if needed
		}
	}
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
	var screen_width: CGFloat
	var screen_height: CGFloat
	
	private var zhuGua: [Bool]
	private var huGua: [Bool]
	private var bianGua: [Bool]
	
	init(zhuGuaXu: Int, dongYao: Int, screen_width: CGFloat, screen_height: CGFloat) {
		self.zhuGuaXu = zhuGuaXu
		self.dongYao = dongYao
		self.screen_width = screen_width
		self.screen_height = screen_height
		self.zhuGua = [Bool](repeating: false, count: 6)
		self.huGua = [Bool](repeating: false, count: 6)
		self.bianGua = [Bool](repeating: false, count: 6)
		
		if let zhuGuaYinYangYaoCStr = getGuaYinYangYao(Int32(zhuGuaXu)) {
			let binaryString = String(cString: zhuGuaYinYangYaoCStr)
			// print("ZhuGuaView 二进制字符串: \(binaryString)")
			for (index, char) in binaryString.enumerated() {
				self.zhuGua[index] = char == "1" ? true : false
			}
		} else {
			print("Failed to get valid C string")
			self.zhuGua = [Bool](repeating: true, count: 6)
		}
		
		// 定义主卦中每个位置对应的互卦位置关系
		let mapping = [1, 2, 3, 2, 3, 4]
		
		for (index, value) in mapping.enumerated() {
			self.huGua[index] = self.zhuGua[value]
		}
		
		// 根据动爻计算变卦
		self.bianGua = zhuGua
		self.bianGua[dongYao] = !self.bianGua[dongYao]
	}
	
	var body: some View {
		
		HStack() {
			Spacer()
			VStack {
				ZhuGuaHexagramView(zhuGua: zhuGua, dongYao: dongYao, screen_width: screen_width, screen_height: screen_height)
			}
			Spacer()
			VStack {
				HuGuaHexagramView(Gua: huGua, screen_width: screen_width, screen_height: screen_height)
			}
			Spacer()
			VStack {
				BianGuaHexagramView(Gua: bianGua, screen_width: screen_width, screen_height: screen_height)
			}
			Spacer()
		}
		.padding()
	}
	
}

struct ZhuGuaHexagramView: View {
	var zhuGua: [Bool]
	var dongYao: Int
	var screen_width: CGFloat
	var screen_height: CGFloat
	
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
								.frame(height: 6)
								.frame(width: screen_width * 0.2)
								.overlay(
									!self.zhuGua[index] ? AnyView(
										HStack {
											Spacer()
											Rectangle()
												.fill(Color.white)
												.frame(width: screen_width * 0.03)
											Spacer()
										}
									) : AnyView(EmptyView())
								)
						}
						
						VStack{
							Image(systemName: "circle")
								.foregroundColor(dongYao == index ? .red : .white)
								.font(.system(size: 5))
						}
					}
					Spacer()
					Spacer()
				}
			}
			HStack(){
				Text("雷水解")
			}
		}
	}
}

struct HuGuaHexagramView: View {
	var Gua: [Bool]
	var screen_width: CGFloat
	var screen_height: CGFloat
	
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
							.frame(height: 6)
							.frame(width:screen_width * 0.2)
							.overlay(
								!self.Gua[index] ? AnyView(
									HStack {
										Spacer()
										Rectangle()
											.fill(Color.white)
											.frame(width: screen_width * 0.03)
										Spacer()
									}
								) : AnyView(EmptyView())
							)
					}
					Spacer()
					Spacer()
				}
			}
			HStack() {
				Text("水火既济")
			}
		}
	}
}

struct BianGuaHexagramView: View {
	var Gua: [Bool]
	var screen_width: CGFloat
	var screen_height: CGFloat
	
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
							.frame(height: 6)
							.frame(width: screen_width * 0.2)
							.overlay(
								!self.Gua[index] ? AnyView(
									HStack {
										Spacer()
										Rectangle()
											.fill(Color.white)
											.frame(width: screen_width * 0.03)
										Spacer()
									}
								) : AnyView(EmptyView())
							)
					}
					Spacer()
					Spacer()
				}
			}
			HStack() {
				Text("雷地豫")
			}
		}
	}
}

struct TextInputView: View {
	var placeholder: String
	@Binding var text: String

	var body: some View {
		HStack(){
			TextField(placeholder, text: $text)
				.padding()
				.background(Color.gray.opacity(0.1))
				.cornerRadius(10)
				.padding(.horizontal)
		}
		.padding()
	}
}

struct PaipanDetailView_Previews: PreviewProvider {
	static var previews: some View {
		PaipanDetailView(selectedDate: Date(), selectedLunarDate: "", zhuGuaXu: 0, dongYao: 0)
	}
}



