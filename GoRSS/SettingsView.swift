//
//  SettingsView.swift
//  GoRSS
//
//  Created by Gemini on 2026/1/10.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: FeedViewModel
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    
    @State private var showClearReadConfirmation = false
    @State private var showClearFavoritesConfirmation = false
    @State private var showClearCacheConfirmation = false
    
    var body: some View {
        NavigationStack {
            Form {
                appearanceSection
                dataSection
                aboutSection
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .alert("确认重置已读状态？", isPresented: $showClearReadConfirmation) {
                Button("重置", role: .destructive) {
                    viewModel.clearReadStatus()
                }
                Button("取消", role: .cancel) { }
            } message: {
                Text("此操作将清除所有文章的已读标记，无法撤销。")
            }
            .alert("确认清空收藏列表？", isPresented: $showClearFavoritesConfirmation) {
                Button("清空", role: .destructive) {
                    viewModel.clearStarredStatus()
                }
                Button("取消", role: .cancel) { }
            } message: {
                Text("此操作将移除所有收藏的文章，无法撤销。")
            }
            .alert("确认清除缓存数据？", isPresented: $showClearCacheConfirmation) {
                Button("清除", role: .destructive) {
                    viewModel.clearCache()
                }
                Button("取消", role: .cancel) { }
            } message: {
                Text("此操作将清除本地缓存数据（已收藏的文章除外）。")
            }
        }
        .preferredColorScheme(appTheme.colorScheme)
    }
    
    private var appearanceSection: some View {
        Section {
            Picker(selection: $appTheme) {
                ForEach(AppTheme.allCases) { theme in
                    Text(theme.rawValue)
                        .tag(theme)
                }
            } label: {
                Label("外观模式", systemImage: "paintbrush")
            }
            .pickerStyle(.menu)
            .tint(.primary) // Use primary color for the selected text
        } header: {
            Text("个性化")
        }
    }
    
    private var dataSection: some View {
        Section {
            Button(role: .destructive) {
                showClearReadConfirmation = true
            } label: {
                Label("重置已读状态", systemImage: "checkmark.circle.badge.xmark")
            }
            
            Button(role: .destructive) {
                showClearFavoritesConfirmation = true
            } label: {
                Label("清空收藏列表", systemImage: "star.slash")
            }
            
            Button(role: .destructive) {
                showClearCacheConfirmation = true
            } label: {
                Label("清除缓存数据", systemImage: "trash")
            }
        } header: {
            Text("数据管理")
        } footer: {
            Text("清除的数据将无法恢复。")
        }
    }
    
    private var aboutSection: some View {
        Section {
            HStack {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "wave.3.right") // Abstract Icon
                        .font(.system(size: 48))
                        .foregroundStyle(.tint)
                        .padding()
                        .background(
                            Circle()
                                .fill(.tint.opacity(0.1))
                        )
                    
                    VStack(spacing: 4) {
                        Text("GoRSS")
                            .font(.title3.weight(.bold))
                            .fontDesign(.serif)
                        
                        Text("v1.0.0")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text("Designed for immersive reading.")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
                Spacer()
            }
            .listRowBackground(Color.clear)
        }
    }
}

enum AppTheme: String, CaseIterable, Identifiable {
    case system = "跟随系统"
    case light = "浅色模式"
    case dark = "深色模式"
    
    var id: String { rawValue }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    var iconName: String {
        switch self {
        case .system: return "gearshape"
        case .light: return "sun.max"
        case .dark: return "moon"
        }
    }
}
