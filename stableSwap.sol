
pragma solidity>=0.8.0;

// import "./IERC20.sol"; 
// import "./IAdmin.sol" ;

// SPDX-License-Identifier: MIT

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender
			, address recipient
			, uint256 amount
		) 		external returns (bool);
		function mint ( address _to , uint256 _amount  ) external returns ( bool );
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IAdmin {
	function _owner () external returns ( address ) ;
	function _stable_tokens (address ) external returns ( bool ) ;
	function _admins ( address ) external returns ( bool );
	function _token_registry ( string memory ) external returns ( address ) ;
	function _feecollector () external returns ( address );
	function _feetaker () external returns ( address );
	function set_stable_token ( address _address , bool _status ) external ;
	function _fees ( string memory ) external returns (  uint256 );
	function _custom_stable_tokens (address) external returns (bool) ;
}

// pragma solidity>=0.8.0;
// import "./IERC20.sol"; 
// import "./IAdmin.sol" ;

interface __StableSwap {
	function set_min_lockup_period ( uint256 __min_lockup_period ) external ;
  function mybalance (address _tokenaddress) external returns ( uint256 ) ;
  function withdraw (		address _token_from 
		, address _token_to
		, uint256 _amount
		, address _to
	) external ;
  function swap ( 			address _token_from
		, address _token_to
		, uint256 _amount_from
		, address _to
	) external ;
} 
contract StableSwap is __StableSwap {
	address public _owner ;
	address public _admin ;
	mapping ( address => uint256 ) public _balances ; // holder => balance , different sources pooled together due to stable nature
	mapping ( address => uint256 ) public _last_deposit_time ; // holder => last deposit
	mapping ( address => uint256 ) public _last_withdraw_time; 
	uint256 public _min_lockup_period = 3600 * 24 * 7 ; // a week
	modifier onlyowner ( address _address ) {
		require ( _address == _owner, "ERR() only owner") ;
		_;
	}
	function set_min_lockup_period ( uint256 __min_lockup_period ) public onlyowner( msg.sender ) {
		require ( __min_lockup_period != _min_lockup_period , "ERR() redundant call" );
		_min_lockup_period = __min_lockup_period ;
	}
	event Withdrawn (
		address _token_from // not referenced for now, since 
		, address _token_to
		, uint256 _amount
		, address _to
	) ;
	function mybalance (address _tokenaddress) public returns ( uint256 ) {
		return IERC20(_tokenaddress ).balanceOf ( address (this ));
	}
	function withdraw (
		address _token_from 
		, address _token_to
		, uint256 _amount
		, address _to
	) public {
		require ( _balances[ msg.sender ] >= _amount , "ERR() balance not enough" ) ;
		require ( IERC20( _token_from ).balanceOf( address(this )) >= _amount , "ERR() reserve not enough" );
		require ( _last_deposit_time[ msg.sender ] - block.timestamp >= _min_lockup_period , "ERR() min lockup period required");
		if ( IERC20( _token_from ).transferFrom ( msg.sender , address(this) , _amount ) ){
			// IERC20(_token_from ).burn ( _amount);
			IERC20(_token_to ).transfer ( _to , _amount );
		}
		else {} //
		_balances [ msg.sender ] -= _amount ;
		_last_withdraw_time [ msg.sender ] = block.timestamp ;
		emit Withdrawn (
			 _token_from //
			,  _token_to
			,  _amount
			,  _to
		) ;
	}
	function XXXwithdraw (
		address _token_from // not referenced for now, since withdraw source is pooled one
		, address _token_to
		, uint256 _amount
		, address _to
	) public {
		require ( _balances[ msg.sender ] >= _amount , "ERR() balance not enough" ) ;
		require ( IERC20( _token_to).balanceOf( address(this )) >= _amount , "ERR() reserve not enough" );
		require ( _last_deposit_time[ msg.sender ] - block.timestamp >= _min_lockup_period , "ERR() min lockup period required");
		if ( IERC20( _token_to).transfer ( _to , _amount ) ){}
		else {} // fail case due to recipient not able to receive , but go on for now
		_balances [ msg.sender ] -= _amount ;
		_last_withdraw_time [ msg.sender ] = block.timestamp ;
		emit Withdrawn (
			 _token_from //
			,  _token_to
			,  _amount
			,  _to
		) ;
	}
	event Swapped (
		address _msgsender
		, address _token_from
		, address _token_to
		, uint256 _amount_from
		, address _to
	) ;
	
	function swap ( //
			address _token_from
		, address _token_to
		, uint256 _amount_from
		, address _to
	) public {
		if ( IAdmin( _admin )._stable_tokens( _token_from) || IAdmin( _admin )._custom_stable_tokens( _token_from )) {}
		else {}
		if ( IAdmin( _admin )._stable_tokens( _token_to ) || IAdmin( _admin )._custom_stable_tokens( _token_to )) {}
		else {}
		// if ( IAdmin( _admin )._blacklist( msg.sender) ){revert("ERR() caller blacklisted"); }
		// else {}

		if ( IERC20( _token_from ).transferFrom ( msg.sender , address(this ) , _amount_from )) {}
		else {revert("ERR() balance not enough"); }
		uint256 feerate = IAdmin( _admin )._fees ( "STABLE_SWAP" ) ;
		if(feerate == 0){}
		else {
			uint256 feeamount_00 = _amount_from * 10 / 10000 ;
			uint256 feeamount_01 = 2 * 10**17;
			uint256 feeamount = feeamount_00> feeamount_01? feeamount_00 : feeamount_01;
			address feecollector = IAdmin( _admin )._feecollector () ;
			address feetaker = IAdmin( _admin )._feetaker () ;
			if (feecollector != address(0)){	IERC20( _token_from).transfer (feecollector , feeamount /2 );
			} else {}
			if ( feetaker != address(0)){			IERC20( _token_from ).transfer (feetaker , feeamount / 2 );
			} else {}
		}
		if (IERC20( _token_to).mint ( _to , _amount_from ) ){}
		else {revert ("ERR() mint fail"); }
		_balances[ _to ] += _amount_from ;
		_last_deposit_time [ msg.sender ] = block.timestamp ;
		emit Swapped (
			msg.sender 
			, _token_from
			,  _token_to
			,  _amount_from
			,  _to
		) ;
	}

	constructor ( address __admincontract ){
		_admin = __admincontract ;
		_owner = msg.sender ;
	}

}
