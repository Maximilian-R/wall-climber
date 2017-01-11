package states {
	
	public interface IState {
		function update():IState;
		function destroy():void;
	}
}