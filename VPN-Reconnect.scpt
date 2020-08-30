on idle
	set en0 to do shell script "ipconfig getifaddr en0; exit 0"
	if en0 is not "" then
		tell application "System Events"
			tell current location of network preferences
				set vpnConnection to the service "VPN (L2TP)"
				if vpnConnection is not null then
					if current configuration of vpnConnection is not connected then
						connect vpnConnection
					end if
				end if
			end tell
			return 10
		end tell
	end if
end idle
