
pragma solidity>=0.8.0;

import "./IERC20.sol"; 
import "./IAdmin.sol" ;

contract Staker {
	mapping ( address => uint256 ) _balances ; // holder => balance , different sources pooled together due to stable nature
	address public _owner ;
	address public _admin ;
	constructor ( address __admin ) {
		_admin =	__admin ;
		_owner = msg.sender ;
	}
	function stake ( address _token_from
		, uint256 _amount
		, address _to
	) public {
		require ( _amount >= IAdmin( _admin )._min_stake_amount () , "ERR() amount does not meet min amount");
		require ( IAdmin( _admin)._custom_stable_tokens( _token_from) , "ERR() invalid token_from" );
		IERC20 ( _token_from ).transferFrom ( msg.sender , address(this ) , _amount ) ;
		_balances[ _to ] += _amount ;
	}
	// assume reward is in proportion to staked amount and blocks passed
	function claim (
		
	) public {

	}
}
