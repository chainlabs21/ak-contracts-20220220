
pragma solidity>=0.8.0;

import "./IERC20.sol"; 
import "./IAdmin.sol" ;

contract StableSwap {
	address public _owner ;
	address public _admin ;
	mapping ( address => uint256 ) public _balances ; // holder => balance , different sources pooled together due to stable nature
	mapping ( address => uint256 ) public _last_deposit_time ; // holder => last deposit
	mapping ( address => uint256 ) public _last_withdraw_time; 	
	uint256 public _min_lockup_period = 3600 * 24 * 7 ; // a week
	address public _base_stable_token ;
	mapping ( address => mapping (uint256 => uint256 )) _redeem_request_amounts ;
	mapping ( address => mapping (uint256 => address )) _redeem_request_tokens ;

	modifier only_owner ( address _address ) public {
		require ( _address == _owner, "ERR() only owner") ;
		_;
	}
	function set_min_lockup_period ( uint256 __min_lockup_period ) public only_owner( msg.sender ) {
		require ( __min_lockup_period != _min_lockup_period , "ERR() redundant call" );
		_min_lockup_period = __min_lockup_period ;
	}
	function redeem_step00 ( 
//		address _token_to		, 
			uint256 _amount
		, address _redeem_request_token
		 ) public {
		IERC20( _base_stable_token ).transferFrom ( msg.sender , _amount );
		_redeem_request_amounts [msg.sender ][ block.timestamp ] = _amount ;
		_redeem_request_tokens[ msg.sender ][ block.timestamp ] = _redeem_request_token;
	}
	function redeem_step01 (
		uint256 _time_step00
		, address _to
	) public {
		uint256 request_amount = _redeem_request_amounts[msg.sender ][ _time_step00 ];
		if ( request_amount > _balances[msg.sender] ) {revert("ERR() balance not enough");}
//		IERC20( _base_stable_token ).transferFrom ( msg.sender , address(this) , request_amount );
 		address _redeem_request_token = _redeem_request_tokens[ msg.sender][ _time_step00 ];
		IERC20( _base_stable_token ).burn ( request_amount );
		IERC20( _redeem_request_token ).transfer ( _to , request_amount );
		_redeem_request_amounts[ msg.sender ][ _time_step00 ] = 0;
		_redeem_request_tokens[ msg.sender ][ _time_step00 ] = 0;
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
			IERC20(_token_from ).burn ( _amount);
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
		if (IAdmin( _admin )._stable_tokens( _token_from) || IAdmin( _admin )._custom_stable_tokens( _token_from)) {}
		else {}
		if (IAdmin( _admin )._stable_tokens( _token_to ) || IAdmin( _admin )._custom_stable_tokens( _token_to )) {}
		else {}
		if ( IAdmin( _admin)._blacklist( msg.sender) ){revert("ERR() caller blacklisted"); }
		else {}

		if ( IERC20( _token_from ).transferFrom ( msg.sender , address(this ) , _amount_from )) {}
		else {revert("ERR() balance not enough"); }
		uint256 feerate = IAdmin( _admin )._fees ( "STABLE_SWAP" ) ;
		if(feerate == 0){}
		else {
			uint256 feeamount_00 = _amount_from * 10 / 10000 ;
			uint256 feeamount_01 = 2 * 10**17/10**18 ;
			uint256 feeamount = feeamount_00> feeamount_01? feeamount_00 : feeamount_01;
			address feecollector = IAdmin( _admin )._feecollector ( ) ;
			address feetaker = IAdmin( _admin )._feetaker () ;
			if (feecollector != address(0)){ IERC20( _token_from).transfer (feecollector , feeamount /2 );
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
				 _token_from
			,  _token_to
			,  _amount_from
			,  _to
		) ;
	}
	function set_base_stable_token ( address _address) public only_owner (msg.sender ) {
		require ( _address != _base_stable_token , "ERR() redundant call");
		_base_stable_token = _address ;
	}
	constructor ( address __admincontract
		, address __base_stable_token
	 ){
		_admin = __admincontract ;
		_base_stable_token = __base_stable_token ;
		_owner = msg.sender ;		
	}

}
