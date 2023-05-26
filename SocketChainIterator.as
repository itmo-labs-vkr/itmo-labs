class SocketChainIterator {
	private var in_sock:Socket;
	public function SocketChainIterator(s:Socket) {
		if(s.isConnected)
			this.in_sock = s.getConnectedSocket();
		else
			this.in_sock = null;
	}
	public function endOfChain():Boolean {
		return !this.in_sock;
	}
	public function getIn():Socket {
		if(endOfChain())
			return null;
		return this.in_sock;
	}
	public function getOut():Socket {
		if(endOfChain())
			return null;
		return getEquipment().getOtherSocket(in_sock);
	}
	public function getEquipment() {
		if(endOfChain())
			return null;
		return in_sock.getOwner();
	}
	public function next():Void {
		if(endOfChain())
			return;
		if(getOut().isConnected) 
			this.in_sock = getOut().getConnectedSocket();
		else
			this.in_sock = null;
	}
}