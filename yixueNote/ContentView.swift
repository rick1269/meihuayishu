import SwiftUI

struct ContentView: View {
	var body: some View {
		NavigationView {
			VStack {
				Text("易学笔记")
					.font(.title)
					.padding()
				
				Spacer()
				
				LazyVGrid(columns: [
					GridItem(.flexible(), spacing: 20),
					GridItem(.flexible(), spacing: 20)
				], spacing: 20) {
					NavigationLink(destination: MeihuayishuPanSelectionView()) {
						FeatureButton(title: "梅花易数")
					}
					NavigationLink(destination: Text("四柱八字")) {
						FeatureButton(title: "四柱八字")
					}
					NavigationLink(destination: Text("奇门遁甲")) {
						FeatureButton(title: "奇门遁甲")
					}
					NavigationLink(destination: Text("风水笔记")) {
						FeatureButton(title: "风水笔记")
					}
				}
				.padding()
				
				Spacer()
				
				HStack {
					Spacer()
					NavigationLink(destination: Text("首页")) {
						VStack {
							Image(systemName: "house.fill")
							Text("首页")
								.font(.caption)
						}
					}
					Spacer()
					NavigationLink(destination: Text("发现")) {
						VStack {
							Image(systemName: "magnifyingglass")
							Text("发现")
								.font(.caption)
						}
					}
					Spacer()
					NavigationLink(destination: Text("我的")) {
						VStack {
							Image(systemName: "person.fill")
							Text("我的")
								.font(.caption)
						}
					}
					Spacer()
				}
				.padding()
				.background(Color(UIColor.systemGray6))
			}
		}
	}
}

struct FeatureButton: View {
	var title: String
	
	var body: some View {
		VStack {
			Text(title)
				.font(.headline)
				.padding(.vertical, 10)
				.foregroundColor(Color.black) // 设置文字颜色为黑色
		}
		.frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.width / 2.5)
		.background(Color.white)
		.cornerRadius(10)
		.shadow(radius: 5)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

