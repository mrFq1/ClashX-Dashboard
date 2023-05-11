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
	@State var mode: String = "Rule"
	@State var logLevel: String = "Debug"
	@State var allowLAN: Bool = false
	@State var sniffer: Bool = false
	
	@State var enableTUNDevice: Bool = false
	@State var tunIPStack: String = "System"
	@State var deviceName: String = "utun9"
	@State var interfaceName: String = "en0"
	
	@State var disableAll = true
	
	var body: some View {
		ScrollView {
			LazyVGrid(columns: [
				GridItem(.flexible()),
				GridItem(.flexible())
			]) {
				VStack(alignment: .leading) {
					Text("Http Port")
					TextField("0", value: $httpPort, formatter: NumberFormatter())
				}
				
				VStack(alignment: .leading) {
					Text("Socks5 Port")
					TextField("0", value: $socks5Port, formatter: NumberFormatter())
				}
				
				VStack(alignment: .leading) {
					Text("Mixed Port")
					TextField("0", value: $mixedPort, formatter: NumberFormatter())
				}
				
				VStack(alignment: .leading) {
					Text("Redir Port")
					TextField("0", value: $redirPort, formatter: NumberFormatter())
				}
				
				VStack(alignment: .leading) {
					Text("Mode")
					Picker("", selection: $mode) {
						ForEach(["Direct", "Rule", "Script", "Global"], id: \.self) {
							Text($0)
						}
					}
					.pickerStyle(.menu)
				}
				
				VStack(alignment: .leading) {
					Text("Log Level")
					Picker("", selection: $logLevel) {
						ForEach(["Silent", "Error", "Warning", "Info", "Debug"], id: \.self) {
							Text($0)
						}
					}
					.pickerStyle(.menu)
				}
				Toggle("Allow LAN", isOn: $allowLAN)
				Toggle("Sniffer", isOn: $sniffer)
			}
			.padding()
			
			Divider()
				.padding()
			
			LazyVGrid(columns: [
				GridItem(.flexible()),
				GridItem(.flexible())
			]) {
				Toggle("Enable TUN Device", isOn: $enableTUNDevice)
				
				VStack(alignment: .leading) {
					Text("TUN IP Stack")
					Picker("", selection: $tunIPStack) {
						ForEach(["gVisor", "System", "LWIP"], id: \.self) {
							Text($0)
						}
					}
					.pickerStyle(.menu)
				}
				
				VStack(alignment: .leading) {
					Text("Device Name")
					TextField("utun9", text: $deviceName)
				}
				
				VStack(alignment: .leading) {
					Text("Interface Name")
					TextField("en0", text: $interfaceName)
				}
				
			}
			.padding()
		}
		.disabled(disableAll)
		.onAppear {
			ApiRequest.requestConfig { config in
				httpPort = config.port
				socks5Port = config.socksPort
				mixedPort = config.mixedPort
				redirPort = config.redirPort
				mode = config.mode.rawValue.capitalized
				logLevel = config.logLevel.rawValue.capitalized
				
				allowLAN = config.allowLan
				sniffer = config.sniffing
				
				enableTUNDevice = config.tun.enable
				tunIPStack = config.tun.stack
				deviceName = config.tun.device
				interfaceName = config.interfaceName
			}
		}
	}
}

//struct ConfigView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfigView()
//    }
//}
