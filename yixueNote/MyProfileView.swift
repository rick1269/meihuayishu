//
//  MyProfileView.swift
//  yixueNote
//
//  Created by rick qiu on 2024/7/10.
//
import SwiftUI
import Foundation

struct MyProfileView: View {
	var body: some View {
		List {
			Section {
				NavigationLink(destination: PaipanHistoryView()) {
					Text("卦例笔记")
				}
				NavigationLink(destination: Text("修改密码")) {
					Text("修改密码")
				}
				NavigationLink(destination: Text("账号注销")) {
					Text("账号注销")
				}
				NavigationLink(destination: Text("功能设置")) {
					Text("功能设置")
				}
				NavigationLink(destination: Text("更新日志")) {
					Text("更新日志")
				}
				NavigationLink(destination: Text("关于")) {
					Text("关于")
				}
				
			}

			Section {
				Button(action: {
					// 执行登出操作
				}) {
					Text("退出登录")
						.foregroundColor(.red)
				}
			}
		}
		.navigationTitle("我的")
		.listStyle(GroupedListStyle())
	}
}
