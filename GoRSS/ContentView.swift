//
//  ContentView.swift
//  GoRSS
//
//  Created by Alfred Jobs on 2026/1/10.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FeedViewModel()
    @State private var showingSettings = false
    @State private var showingAddFeed = false
    @State private var selectedItemURL: URL?
    @State private var showingMenu = false
    
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    
    var body: some View {
        NavigationStack {
            MainFeedView(
                viewModel: viewModel,
                selectedItemURL: $selectedItemURL
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingMenu.toggle()
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 20))
                            .foregroundStyle(.primary)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .popover(isPresented: $showingMenu) {
                        MenuView(
                            viewModel: viewModel,
                            showingSettings: $showingSettings,
                            showingAddFeed: $showingAddFeed,
                            closeMenu: { showingMenu = false }
                        )
                        .presentationCompactAdaptation(.popover)
                        .frame(width: 280)
                    }
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingAddFeed) {
            AddFeedView(viewModel: viewModel)
                .presentationDetents([.medium])
        }
        .sheet(item: $selectedItemURL) { url in
            SafariView(url: url)
                .ignoresSafeArea()
        }
        .task {
            await viewModel.loadAllFeeds()
        }
        .preferredColorScheme(appTheme.colorScheme)
    }
}

// MARK: - Menu View (Popover Content)
struct MenuView: View {
    @ObservedObject var viewModel: FeedViewModel
    @Binding var showingSettings: Bool
    @Binding var showingAddFeed: Bool
    var closeMenu: () -> Void
    
    // Edit Source State
    @State private var sourceToEdit: FeedSource?
    
    // Delete Source State
    @State private var showDeleteConfirmation = false
    @State private var sourceToDelete: FeedSource?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {

                // MARK: - 文章
                VStack(alignment: .leading, spacing: 4) {
                    sectionTitle("文章")

                    MenuButton(
                        title: "全部",
                        icon: "tray",
                        count: viewModel.items.count,
                        isSelected: viewModel.selectedFilter == .all
                    ) {
                        viewModel.selectedFilter = .all
                        closeMenu()
                    }

                    MenuButton(
                        title: "我的收藏",
                        icon: "star",
                        count: viewModel.starredItemIDs.count,
                        isSelected: viewModel.selectedFilter == .starred
                    ) {
                        viewModel.selectedFilter = .starred
                        closeMenu()
                    }
                }

                // MARK: - 我的订阅
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        sectionTitle("我的订阅")

                        Spacer()

                        Button {
                            closeMenu()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                showingAddFeed = true
                            }
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .semibold))
                                .padding(8)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 16)

                    if viewModel.sources.isEmpty {
                        Text("暂无订阅")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    } else {
                        ForEach(viewModel.sources) { source in
                            MenuButton(
                                title: source.name ?? "未命名源",
                                icon: "dot.radiowaves.right",
                                iconUrl: source.iconUrl,
                                isSelected: viewModel.selectedFilter == .source(source)
                            ) {
                                viewModel.selectedFilter = .source(source)
                                closeMenu()
                            }
                            .contextMenu {
                                Button {
                                    sourceToEdit = source
                                } label: {
                                    Text("编辑订阅")
                                }
                                
                                Button(role: .destructive) {
                                    sourceToDelete = source
                                    showDeleteConfirmation = true
                                } label: {
                                    Text("删除订阅")
                                }
                            }
                        }
                    }
                }

                Divider()
                    .padding(.horizontal, 16)

                // MARK: - 设置
                Button {
                    closeMenu()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        showingSettings = true
                    }
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 18))
                        Text("设置")
                            .font(.body)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .contentShape(Rectangle())
                }
                .foregroundStyle(.primary)
            }
            .padding(.vertical, 12)
            .padding(.leading, 8)
        }
        .frame(maxHeight: 500) // Limit height for long lists
        .sheet(item: $sourceToEdit) { source in
            EditFeedView(viewModel: viewModel, source: source)
                .presentationDetents([.medium])
        }
        .alert("删除订阅？", isPresented: $showDeleteConfirmation) {
            Button("删除", role: .destructive) {
                if let source = sourceToDelete {
                    viewModel.deleteSource(source)
                }
                sourceToDelete = nil
            }
            Button("取消", role: .cancel) {
                sourceToDelete = nil
            }
        } message: {
            Text("删除后将无法恢复，且会清除该源的所有已缓存文章。")
        }
    }

    // MARK: - Section Title
    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 16)
            .padding(.bottom, 2)
    }
}

// Menu Button Component
struct MenuButton: View {
    let title: String
    let icon: String
    var iconUrl: String? = nil  // 新增：支持网络图标 URL
    var count: Int? = nil
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // 如果有 iconUrl，优先显示网络图标；否则显示 SF Symbol
                if let iconUrl = iconUrl, let url = URL(string: iconUrl) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 24, height: 24)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        } else if phase.error != nil {
                            // 加载失败，显示默认图标
                            Image(systemName: icon)
                                .font(.system(size: 18))
                                .frame(width: 24, height: 24)
                                .foregroundStyle(isSelected ? .blue : .primary)
                        } else {
                            // 加载中
                            ProgressView()
                                .frame(width: 24, height: 24)
                        }
                    }
                } else {
                    // 没有 iconUrl，使用 SF Symbol
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .frame(width: 24, height: 24)
                        .foregroundStyle(isSelected ? .blue : .primary)
                }

                Text(title)
                    .font(.body)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundStyle(isSelected ? .blue : .primary)
                    .lineLimit(1)

                Spacer()

                if let count = count, count > 0 {
                    Text("\(count)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(
                            isSelected
                            ? .blue.opacity(0.8)
                            : .secondary
                        )
                }

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.blue.opacity(0.1) : .clear)
                    .padding(.horizontal, 8)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Main Feed View
struct MainFeedView: View {
    @ObservedObject var viewModel: FeedViewModel
    @Binding var selectedItemURL: URL?
    
    var navigationTitle: String {
        if viewModel.isLoading && viewModel.items.isEmpty {
            return ""
        }
        switch viewModel.selectedFilter {
        case .all: return "全部"
        case .starred: return "收藏"
        case .source(let source): return source.name ?? "订阅源"
        }
    }
    
    var body: some View {
        List {
            ForEach(viewModel.filteredItems) { item in
                ArticleCard(
                    item: item,
                    sourceName: viewModel.sources.first(where: { $0.id == item.sourceID })?.name,
                    isRead: viewModel.isRead(item),
                    isStarred: viewModel.isStarred(item)
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button {
                        withAnimation {
                            viewModel.toggleStar(item)
                        }
                    } label: {
                        Label(viewModel.isStarred(item) ? "取消收藏" : "收藏", systemImage: viewModel.isStarred(item) ? "star.slash.fill" : "star.fill")
                    }
                    .tint(.orange)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.markAsRead(item)
                    if let url = item.link {
                        selectedItemURL = url
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            await viewModel.loadAllFeeds()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.filteredItems.isEmpty {
                ContentUnavailableView(
                    "无文章",
                    systemImage: "newspaper",
                    description: Text("尝试刷新或添加更多订阅源")
                )
            }
        }
    }
}

// MARK: - Article Card
struct ArticleCard: View {
    let item: RSSItem
    let sourceName: String?
    let isRead: Bool
    let isStarred: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let imageUrl = item.imageUrl {
                AsyncImage(url: imageUrl) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                    } else {
                        Color.clear.frame(height: 0) // No placeholder if loading fails
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    if let sourceName {
                        Text(sourceName.uppercased())
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    if isStarred {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.orange)
                            .font(.caption)
                            .offset(y: -1)
                    }
                    
                    Text(item.pubDate.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text(item.title)
                    .font(.title3)
                    .fontDesign(.serif)
                    .fontWeight(.semibold)
                    .foregroundColor(isRead ? .secondary : .primary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(item.summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .lineSpacing(4)
            }
            .padding(16)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Helper Extension for Sheet
extension URL: Identifiable {
    public var id: String { absoluteString }
}
