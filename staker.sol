
pragma solidity>=0.8.0;

import "./IERC20.sol"; 
import "./IAdmin.sol" ;

contract Staker {
	mapping ( address => uint256 ) _balances ; // holder => balance , different sources pooled together due to stable nature
	mapping ( address => uint256 ) _rewards ; 
	address public _owner ;
	address public _admin ;
	uint256 public _min_stake_amount ;
	address public _token_from // to stake
	address public _token_to // reward
	uint256 public _mint_balance_to_qualify_for_claim ;
	constructor ( address __admin 
		, address __token_from // to stake
		, address __token_to // reward
		, uint256 __min_stake_amount
		, uint256 __mint_balance_to_qualify_for_claim
	) {
		_admin =	__admin ;
		_owner = msg.sender ;
		_token_from = __token_from ;
		_token_to = __token_to ;
		_min_stake_amount = __min_stake_amount ;
		_mint_balance_to_qualify_for_claim = __mint_balance_to_qualify_for_claim ;
	}
	function stake ( address _token_from
		, uint256 _amount
		, address _to
	) public {
		require ( _amount >= _min_stake_amount () , "ERR() amount does not meet min amount");
//		require ( IAdmin( _admin)._custom_stable_tokens( _token_from) , "ERR() invalid token_from" );
		IERC20 ( _token_from ).transferFrom ( msg.sender , address( this ) , _amount ) ;
		_balances[ _to ] += _amount ;
	}
	// assume reward is in proportion to staked amount and blocks passed
	function claim (
	) public {
		require ( _balances[msg.sender ] >= _mint_balance_to_qualify_for_claim , "ERR() does not meet min balance" ) ;
		require ( _rewards[ msg.sender]>0 , "ERR() none claimable" );
		IERC20( _token_to).transfer ()
		
	}
}
