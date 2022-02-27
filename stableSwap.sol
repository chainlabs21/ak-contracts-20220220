
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
	modifier onlyowner ( address _address ) public {
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
	function withdraw (
		address _token_from // not referenced for now, since withdraw source is pooled one
		, address _token_to
		, uint256 _amount
		, address _to
	) public {
		require ( _balances[ msg.sender ] >= _amount , "ERR() balance not enough" ) ;
		require ( IERC20( _token_to).balanceOf( address(this )) >= _amount , "ERR() reserve not enough" );
		require ( _last_deposit_time[ msg.sender ] - block.timestamp >= _min_lockup_period , "ERR() min lockup required");
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
		if ( IERC20( _token_from ).transferFrom ( msg.sender , _amount_from )) {}
		else {revert("ERR() balance not enough"); }
		uint256 feerate = IAdmin( _admin )._fees ( "STABLE_SWAP" ) ;
		if(feerate == 0){}
		else {}
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

	constructor ( address __admincontract ){
		_admin = __admincontract ;
		_owner = msg.sender ;
	}

}
