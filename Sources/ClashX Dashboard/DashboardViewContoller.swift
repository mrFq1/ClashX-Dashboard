//
//  DashboardViewContoller.swift
//  ClashX
//
//  Created by yicheng on 2018/8/28.
//  Copyright © 2018年 west2online. All rights reserved.
//

import Cocoa
import SwiftUI

public class DashboardWindowController: NSWindowController {
    public var onWindowClose: (() -> Void)?

	public static func create() -> DashboardWindowController {
        let win = NSWindow()
        win.center()
        let wc = DashboardWindowController(window: win)
        wc.contentViewController = DashboardViewContoller()
        return wc
    }

	public override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        NSApp.activate(ignoringOtherApps: true)
        window?.makeKeyAndOrderFront(self)
        window?.delegate = self
    }
	
	public func set(_ apiURL: String, secret: String? = nil) {
		ConfigManager.shared.isRunning = true
		ConfigManager.shared.overrideApiURL = .init(string: apiURL)
		ConfigManager.shared.overrideSecret = secret
	}
	
	public func reload() {
		NotificationCenter.default.post(name: .reloadDashboard, object: nil)
	}
}

extension DashboardWindowController: NSWindowDelegate {
	public func windowWillClose(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        onWindowClose?()
        if let contentVC = contentViewController as? DashboardViewContoller, let win = window {
            if !win.styleMask.contains(.fullScreen) {
                contentVC.lastSize = win.frame.size
            }
        }
    }
}

class DashboardViewContoller: NSViewController {
    let contentView = NSHostingView(rootView: DashboardView())
    let minSize = NSSize(width: 920, height: 580)
    var lastSize: CGSize? {
        set {
            if let size = newValue {
                UserDefaults.standard.set(NSStringFromSize(size), forKey: "ClashWebViewContoller.lastSize")
            }
        }
        get {
            if let str = UserDefaults.standard.value(forKey: "ClashWebViewContoller.lastSize") as? String {
                return NSSizeFromString(str) as CGSize
            }
            return nil
        }
    }

    let effectView = NSVisualEffectView()
	
	private let levels = [
		ClashLogLevel.silent,
		.error,
		.warning,
		.info,
		.debug
	]
	
	private var sidebarItemObserver: NSObjectProtocol?

	func createWindowController() -> NSWindowController {
        let sb = NSStoryboard(name: "Main", bundle: Bundle.main)
        let vc = sb.instantiateController(withIdentifier: "DashboardViewContoller") as! DashboardViewContoller
        let wc = NSWindowController(window: NSWindow())
        wc.contentViewController = vc
        return wc
    }

	override func loadView() {
        view = contentView
    }

	override func viewDidLoad() {
        super.viewDidLoad()
		
		sidebarItemObserver = NotificationCenter.default.addObserver(forName: .sidebarItemChanged, object: nil, queue: .main) {
			guard let item = $0.userInfo?["item"] as? SidebarItem else { return }
			
			var items = [NSToolbarItem.Identifier]()
			items.append(.toggleSidebar)
			
			switch item {
			case .overview, .config:
				break
			case .proxies, .providers:
				items.append(.hideNamesItem)
				items.append(.searchItem)
			case .rules:
				items.append(.searchItem)
			case .conns:
				items.append(.stopConnsItem)
				items.append(.searchItem)
			case .logs:
				items.append(.logLevelItem)
				items.append(.searchItem)
			}
			self.reinitToolbar(items)
		}
    }

	public override func viewWillAppear() {
		super.viewWillAppear()
		guard view.window?.toolbar == nil else { return }
		
		view.window?.styleMask.insert(.fullSizeContentView)
		
		view.window?.isOpaque = false
		view.window?.styleMask.insert(.closable)
		view.window?.styleMask.insert(.resizable)
		view.window?.styleMask.insert(.miniaturizable)
		
		let toolbar = NSToolbar(identifier: .init("DashboardToolbar"))
		toolbar.displayMode = .iconOnly
		toolbar.delegate = self
		
		view.window?.toolbar = toolbar
		view.window?.title = "Dashboard"
		reinitToolbar([])
		
		view.window?.minSize = minSize
		if let lastSize = lastSize, lastSize != .zero {
			view.window?.setContentSize(lastSize)
		}
		view.window?.center()
		if NSApp.activationPolicy() == .accessory {
			NSApp.setActivationPolicy(.regular)
		}
		
		
		// Fix sidebar list highlight
		let button = NSButton(frame: .zero)
		view.window?.contentView?.addSubview(button)
		view.window?.initialFirstResponder = button
	}
	
	func reinitToolbar(_ items: [NSToolbarItem.Identifier]) {
		guard let toolbar = view.window?.toolbar else { return }
		
		toolbar.items.enumerated().reversed().forEach {
			toolbar.removeItem(at: $0.offset)
		}
		
		items.reversed().forEach {
			toolbar.insertItem(withItemIdentifier: $0, at: 0)
		}
	}

    deinit {
		if let sidebarItemObserver {
			NotificationCenter.default.removeObserver(sidebarItemObserver)
		}
        NSApp.setActivationPolicy(.accessory)
    }
}


extension NSToolbarItem.Identifier {
	static let hideNamesItem = NSToolbarItem.Identifier("HideNamesItem")
	static let stopConnsItem = NSToolbarItem.Identifier("StopConnsItem")
	static let logLevelItem = NSToolbarItem.Identifier("LogLevelItem")
	static let searchItem = NSToolbarItem.Identifier("SearchItem")
}

extension DashboardViewContoller: NSSearchFieldDelegate {
	
	func controlTextDidChange(_ obj: Notification) {
		guard let obj = obj.object as? NSSearchField else { return }
		NotificationCenter.default.post(name: .toolbarSearchString, object: nil, userInfo: ["String": obj.stringValue])
	}
	
	@IBAction func stopConns(_ sender: NSToolbarItem) {
		NotificationCenter.default.post(name: .stopConns, object: nil)
	}
	
	@IBAction func hideNames(_ sender: NSToolbarItem) {
		switch sender.tag {
		case 0:
			sender.tag = 1
			sender.image = NSImage(systemSymbolName: "eyeglasses", accessibilityDescription: nil)
		case 1:
			sender.tag = 0
			sender.image = NSImage(systemSymbolName: "wand.and.stars", accessibilityDescription: nil)
		default:
			break
		}
		
		NotificationCenter.default.post(name: .hideNames, object: nil, userInfo: ["hide": sender.tag == 1])
	}
	
	@objc func setLogLevel(_ sender: NSToolbarItemGroup) {
		guard sender.selectedIndex < levels.count, sender.selectedIndex >= 0 else { return }
		let level = levels[sender.selectedIndex]
		
		NotificationCenter.default.post(name: .logLevelChanged, object: nil, userInfo: ["level": level])
	}
	
}

extension DashboardViewContoller: NSToolbarDelegate, NSToolbarItemValidation {
	
	func validateToolbarItem(_ item: NSToolbarItem) -> Bool {
		return true
	}
	
	func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
		
		switch itemIdentifier {
		case .searchItem:
			let item = NSSearchToolbarItem(itemIdentifier: .searchItem)
			item.resignsFirstResponderWithCancel = true
			item.searchField.delegate = self
			item.toolTip = "Search"
			return item
		case .toggleSidebar:
			return NSTrackingSeparatorToolbarItem(itemIdentifier: .toggleSidebar)
		case .logLevelItem:

			let titles = levels.map {
				$0.rawValue.capitalized
			}
			
			let group = NSToolbarItemGroup(itemIdentifier: .logLevelItem, titles: titles, selectionMode: .selectOne, labels: titles, target: nil, action: #selector(setLogLevel(_:)))
			group.selectionMode = .selectOne
			group.controlRepresentation = .collapsed
			group.selectedIndex = levels.firstIndex(of: ConfigManager.selectLoggingApiLevel) ?? 0
			
			return group
		case .hideNamesItem:
			let item = NSToolbarItem(itemIdentifier: .hideNamesItem)
			item.target = self
			item.action = #selector(hideNames(_:))
			item.isBordered = true
			item.tag = 0
			item.image = NSImage(systemSymbolName: "wand.and.stars", accessibilityDescription: nil)
			return item
		case .stopConnsItem:
			let item = NSToolbarItem(itemIdentifier: .stopConnsItem)
			item.target = self
			item.action = #selector(stopConns(_:))
			item.isBordered = true
			item.image = NSImage(systemSymbolName: "stop.circle.fill", accessibilityDescription: nil)
			return item
		default:
			break
		}
		
		return nil
	}
	
	
	func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		[
			.toggleSidebar,
			.stopConnsItem,
			.hideNamesItem,
			.logLevelItem,
			.searchItem
		]
	}
	
	func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
		[
			.toggleSidebar,
			.stopConnsItem,
			.hideNamesItem,
			.logLevelItem,
			.searchItem
		]
	}
}
