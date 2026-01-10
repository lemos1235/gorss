//
//  AddFeedView.swift
//  GoRSS
//
//  Created by Gemini on 2026/1/10.
//

import SwiftUI

struct AddFeedView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: FeedViewModel
    
    @State private var urlString = ""
    @State private var nameString = ""
    @State private var isValidating = false
    @State private var showError = false
    @State private var errorMessage = ""
    @FocusState private var isUrlFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 12) {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                                .font(.system(size: 40))
                                .foregroundStyle(.tint)
                                .symbolEffect(.bounce, value: isValidating)
                                .padding(.top, 20)
                            
                            Text("添加 RSS 源")
                                .font(.headline)
                        }
                        
                        // Inputs
                        VStack(spacing: 0) {
                            HStack(spacing: 12) {
                                Image(systemName: "link")
                                    .foregroundStyle(.secondary)
                                    .font(.system(size: 16))
                                    .frame(width: 20)
                                
                                TextField("RSS 地址", text: $urlString)
                                    .keyboardType(.URL)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .focused($isUrlFocused)
                            }
                            .padding(16)
                            
                            Divider()
                                .padding(.leading, 48)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "tag")
                                    .foregroundStyle(.secondary)
                                    .font(.system(size: 16))
                                    .frame(width: 20)
                                
                                TextField("备注名称 (可选)", text: $nameString)
                            }
                            .padding(16)
                        }
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                        
                        if !errorMessage.isEmpty && !showError {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .padding(.horizontal)
                        }

                        Text("支持 RSS 2.0, Atom 以及 JSON Feed 格式。")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 100) // Space for bottom button
                }
                .scrollDismissesKeyboard(.interactively)
                
                // Bottom Button
                VStack {
                    Button(action: {
                        Task {
                            await addFeed()
                        }
                    }) {
                        HStack {
                            if isValidating {
                                ProgressView()
                                    .tint(.white)
                                    .padding(.trailing, 6)
                            }
                            Text(isValidating ? "正在验证..." : "添加")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(urlString.isEmpty ? Color.secondary.opacity(0.2) : Color.accentColor)
                        .foregroundStyle(urlString.isEmpty ? Color.secondary : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(urlString.isEmpty || isValidating)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 10)
                .background(
                    VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
                        .ignoresSafeArea()
                )
            }
            .navigationTitle("新订阅")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
            }
            .alert("添加失败", isPresented: $showError) {
                Button("确定", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .onAppear {
                isUrlFocused = true
            }
        }
    }
    
    private func addFeed() async {
        let cleanedUrlString = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: cleanedUrlString) else {
            errorMessage = "无效的 URL 地址"
            showError = true
            return
        }
        
        isValidating = true
        errorMessage = ""
        // Close keyboard
        isUrlFocused = false
        
        do {
            try await viewModel.validateAndAddSource(url: url, name: nameString.isEmpty ? nil : nameString)
            isValidating = false
            dismiss()
        } catch {
            isValidating = false
            errorMessage = "无法解析该订阅源。请检查链接是否正确，且支持 RSS/Atom/JSON 格式。\n\n详情: \(error.localizedDescription)"
            showError = true
        }
    }
}

// Helper for Blur Background
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
