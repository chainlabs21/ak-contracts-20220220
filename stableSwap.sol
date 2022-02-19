
pragma solidity>=0.8.0;

import "./IERC20.sol"; 
import "./IAdmin.sol" ;

contract StableSwap {
	address public _owner ;
	address public _admin ;
	mapping ( address => uint256 ) _balances ;

	function withdraw (

	) public {

	}
	function swap (
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
	}

	constructor ( address __admincontract ){
		_admin = __admincontract ;
		_owner = msg.sender ;
	}

}
