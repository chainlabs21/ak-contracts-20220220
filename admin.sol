
pragma solidity>=0.8.0;

contract Admin {
	address public _owner ;
	mapping (address => bool ) public _stable_tokens ;

	mapping ( address => bool ) public _custom_stable_tokens ;
	address public _custom_stable_token_selected ;
	mapping (address => bool ) public _admins ;
	mapping ( string => address ) public _token_registry ;
	mapping ( string => uint256 ) public _fees ;
	uint256 public _min_stake_period = 3600 * 24 * 7; // a week
	uint256 public _min_stake_amount = 1*10**18 ;
	address public _feecollector ;
	address public _feetaker ;
	mapping ( address => mapping( address => bool )) public _allowed_swap_pairs ;
	mapping ( address => bool ) public _blacklist ;	
	modifier onlyowner_or_admin (address _address) {
		require ( _address == _owner || _admins[ _address] , "ERR() not privileged");
		_ ;
	}
	function set_custom_stable_tokens ( address _token , bool _status ) public onlyowner_or_admin ( msg.sender ) {
		_custom_stable_tokens [ _token ] = _status ;
	}
	function set_blacklist ( address _address , bool _status ) public onlyowner_or_admin (msg.sender ){
		require ( _blacklist[ _address ] != _status , "ERR() redundant call");
		_blacklist [ _address ]= _status ;
	}

	function set_min_stake_amount ( uint256 _amount ) public onlyowner_or_admin ( msg.sender ){
		require ( _min_stake_amount != _amount  , "ERR() redundant call");
		_min_stake_amount = _amount ;
	}
	function set_custom_stable_token_selected ( address _address ) public onlyowner_or_admin( msg.sender ) {
		require ( _custom_stable_token_selected != _address , "ERR() redundant call" );
		_custom_stable_token_selected = _address;
	}
	function set_allowed_swap_pairs ( address _address0 , address _address1 , bool _status ) public onlyowner_or_admin (msg.sender ){
		require ( _allowed_swap_pairs[ _address0 ][ _address1 ] != _status , "ERR() redundant call" );
		_allowed_swap_pairs[ _address0 ][ _address1 ] = _status ;
		_allowed_swap_pairs[ _address1 ][ _address0 ] = _status ;
	}
	function set_min_stake_period ( uint256 __min_stake_period ) public onlyowner_or_admin( msg.sender ) {
		require ( _min_stake_period != __min_stake_period , "ERR() redundant call") ;
		_min_stake_period = __min_stake_period;
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
	function set_feetaker ( address _address ) public onlyowner_or_admin ( msg.sender ){
		require( _feetaker != _address , "ERR() redundant call" );
		 _feetaker = _address ;
	}
	function set_feecollector ( address _address ) public onlyowner_or_admin ( msg.sender ){
		require( _feecollector != _address , "ERR() redundant call" );
		 _feecollector = _address ;
	}
	constructor (
			address __feecollector
		, address __feetaker
	 ) {
		_owner = msg.sender ;
    _feecollector = __feecollector ;
		_feetaker = __feetaker ;
    _fees ["STABLE_SWAP"]=250 ; // bp
    _fees ["SWAP"]=250 ;
	}
}
/** set up
	set_token_registry ()
 */