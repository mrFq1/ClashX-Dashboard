//
//  ConfigView.swift
//  ClashX Dashboard
//
//

import SwiftUI

struct ConfigView: View {
	
	@State var httpPort: Int = 0
	@State var socks5Port: Int = 0
	@State var mixedPort: Int = 0
	@State var redirPort: Int = 0
	@State var mode: ClashProxyMode = .direct
	@State var logLevel: ClashLogLevel = .unknow
	@State var allowLAN: Bool = false
	@State var sniffer: Bool = false
	@State var ipv6: Bool = false
	
	@State var enableTUNDevice: Bool = false
	@State var tunIPStack: String = "System"
	@State var deviceName: String = "utun9"
	@State var interfaceName: String = "en0"
	
	@State private var configInited = false
	
	private let toggleStyle = SwitchToggleStyle()
	
	var body: some View {
		ScrollView {
			modeView
			
			content1
				.padding()
			
			Divider()
				.padding()
			
			tunView
				.padding()
			
			Divider()
				.padding()
			
			content2
				.padding()
		}
		.disabled(!configInited)
		.onAppear {
			configInited = false
			ApiRequest.requestConfig { config in
				httpPort = config.port
				socks5Port = config.socksPort
				mixedPort = config.mixedPort
				redirPort = config.redirPort
				mode = config.mode
				logLevel = config.logLevel
				
				allowLAN = config.allowLan
				sniffer = config.sniffing
				ipv6 = config.ipv6
				
				enableTUNDevice = config.tun.enable
				tunIPStack = config.tun.stack
				deviceName = config.tun.device
				interfaceName = config.interfaceName
				
				configInited = true
			}
		}
		.onDisappear {
			configInited = false
		}
	}
	
	
	var modeView: some View {
		Picker("", selection: $mode) {
			ForEach([
				ClashProxyMode.direct,
				.rule,
				.global
			], id: \.self) {
				Text($0.name).tag($0)
			}
		}
		.onChange(of: mode) { newValue in
			guard configInited else { return }
			ApiRequest.updateOutBoundMode(mode: newValue)
		}
		.padding()
		.controlSize(.large)
		.labelsHidden()
		.pickerStyle(.segmented)
	}
	
	var content1: some View {
		LazyVGrid(columns: [
			GridItem(.flexible()),
			GridItem(.flexible())
		], alignment: .leading) {
			
			ConfigItemView(name: "Http Port") {
				Text(String(httpPort))
					.font(.system(size: 17))
			}
			
			ConfigItemView(name: "Socks5 Port") {
				Text(String(socks5Port))
					.font(.system(size: 17))
			}
			
			ConfigItemView(name: "Mixed Port") {
				Text(String(mixedPort))
					.font(.system(size: 17))
			}
			
			ConfigItemView(name: "Redir Port") {
				Text(String(redirPort))
					.font(.system(size: 17))
			}
			
			ConfigItemView(name: "Log Level") {
				Text(logLevel.rawValue.capitalized)
					.font(.system(size: 17))
				
//				Picker("", selection: $logLevel) {
//					ForEach([
//						ClashLogLevel.silent,
//						.error,
//						.warning,
//						.info,
//						.debug,
//						.unknow
//					], id: \.self) {
//						Text($0.rawValue.capitalized).tag($0)
//					}
//				}
//				.disabled(true)
//				.pickerStyle(.menu)
			}
			
			ConfigItemView(name: "ipv6") {
				Toggle("", isOn: $ipv6)
					.toggleStyle(toggleStyle)
					.disabled(true)
			}
		}
	}
	
	var tunView: some View {
		LazyVGrid(columns: [
			GridItem(.flexible()),
			GridItem(.flexible())
		], alignment: .leading) {
			
			
			ConfigItemView(name: "Enable TUN Device") {
				Toggle("", isOn: $enableTUNDevice)
					.toggleStyle(toggleStyle)
			}
			
			
			ConfigItemView(name: "TUN IP Stack") {
//				Picker("", selection: $tunIPStack) {
//					ForEach(["gVisor", "System", "LWIP"], id: \.self) {
//						Text($0)
//					}
//				}
//				.pickerStyle(.menu)
				
				Text(tunIPStack)
					.font(.system(size: 17))
			}
			
			
			ConfigItemView(name: "Device Name") {
				Text(deviceName)
					.font(.system(size: 17))
			}
			
			
			ConfigItemView(name: "Interface Name") {
				Text(interfaceName)
					.font(.system(size: 17))
			}
			
		}
	}
	
	var content2: some View {
		LazyVGrid(columns: [
			GridItem(.flexible()),
			GridItem(.flexible())
		], alignment: .leading) {
			
			ConfigItemView(name: "Allow LAN") {
				Toggle("", isOn: $allowLAN)
					.toggleStyle(toggleStyle)
					.onChange(of: allowLAN) { newValue in
						guard configInited else { return }
						ApiRequest.updateAllowLan(allow: newValue) {
							ApiRequest.requestConfig { config in
								allowLAN = config.allowLan
							}
						}
					}
			}
			
			ConfigItemView(name: "Sniffer") {
				Toggle("", isOn: $sniffer)
					.toggleStyle(toggleStyle)
					.onChange(of: sniffer) { newValue in
						guard configInited else { return }
						ApiRequest.updateSniffing(enable: newValue) {
							ApiRequest.requestConfig { config in
								sniffer = config.sniffing
							}
						}
					}
			}
			
			/*
			ConfigItemView(name: "Reload") {
				Button {
					AppDelegate.shared.updateConfig()
				} label: {
					Text("Reload config file")
				}
			}
			 */
			
			ConfigItemView(name: "GEO Databases") {
				Button {
					ApiRequest.updateGEO()
				} label: {
					Text("Update GEO Databases")
				}
			}
			
			ConfigItemView(name: "FakeIP") {
				Button {
					ApiRequest.flushFakeipCache()
				} label: {
					Text("Flush fake-iP data")
				}
			}
		}
	}
}

//struct ConfigView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfigView()
//    }
//}
