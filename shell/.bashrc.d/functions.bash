# iptables
function iptables-update () {
	sudo /etc/network/if-pre-up.d/iptables
}

function iptables-clear () {
	sudo iptables -F
	sudo iptables -X
	sudo iptables -t nat -F
	sudo iptables -t nat -X
	sudo iptables -t mangle -F
	sudo iptables -t mangle -X
	sudo iptables -P INPUT ACCEPT
	sudo iptables -P OUTPUT ACCEPT
	sudo iptables -P FORWARD ACCEPT
	sudo ip6tables -F
	sudo ip6tables -X
	sudo ip6tables -t nat -F
	sudo ip6tables -t nat -X
	sudo ip6tables -t mangle -F
	sudo ip6tables -t mangle -X
	sudo ip6tables -P INPUT ACCEPT
	sudo ip6tables -P OUTPUT ACCEPT
	sudo ip6tables -P FORWARD ACCEPT
}
