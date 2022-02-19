
pragma solidity>=0.8.0;

contract Admin {
	address public _owner ;
	mapping (address => bool ) public _stable_tokens ;
	mapping (address => bool ) public _admins ;
	mapping ( string => address ) public _token_registry ;
	mapping ( string => uint256 ) public _fees ;
	address public _feecollector ;
	modifier onlyowner_or_admin (address _address) {
		require ( _address == _owner || _admins[ _address] , "ERR() not privileged");
		_ ;
	}
	function set_stable_token ( address _address , bool _status ) public onlyowner_or_admin(msg.sender) {
		require( _stable_tokens[_address] != _status , "ERR() redundant call" );
		_stable_tokens[_address] = _status ;
	}
	function set_fees ( string memory _action_type, uint256 _feerate ) public onlyowner_or_admin ( msg.sender ){
		require ( _fees[_action_type ] != _feerate , "ERR() redundant call" ) ;
		_fees[_action_type ] = _feerate ;
	}
	function set_token_registry ( string memory _symbol , address _address ) public onlyowner_or_admin ( msg.sender ){
		require( _token_registry[_symbol ] != _address , "ERR() redundant call" );
		 _token_registry[_symbol ] = _address ;
	}
	function set_feecollector ( address _address ) public onlyowner_or_admin ( msg.sender ){
		require( _feecollector != _address , "ERR() redundant call" );
		 _feecollector = _address ;
	}

	constructor (){
		_owner = msg.sender ;
	}
}
/** set up
	set_token_registry ()
 */