
pragma solidity>=0.8.0;

import "./IERC20.sol"; 
// import "./IAdmin.sol" ;

contract Staker {
	mapping ( address => uint256 ) _balances ; // holder => balance , different sources pooled together due to stable nature
	mapping ( address => uint256 ) _rewards ; 
	mapping ( address => uint256 ) _last_stake_time ; 
	mapping ( address => uint256 ) _last_claim_time ; 
	mapping ( address => uint256 ) _last_withdraw_time ; 
	address public _owner ;
	address public _admin ;
	uint256 public _min_stake_amount ;
	address public _token_from; // to stake
	address public _token_to ;// reward
	uint256 public _mint_balance_to_qualify_for_claim ;
	uint256 public _reward_rate ;
	address public _reward_reserve  ;
	constructor ( address __admin 
		, address __token_from // to stake
		, address __token_to // reward
		, uint256 __min_stake_amount
		, uint256 __mint_balance_to_qualify_for_claim
		, uint256 __reward_rate
	) {
		_admin =	__admin ;
		_owner = msg.sender ;
		_token_from = __token_from ;
		_token_to = __token_to ;
		_min_stake_amount = __min_stake_amount ;
		_mint_balance_to_qualify_for_claim = __mint_balance_to_qualify_for_claim ;
		_reward_rate = __reward_rate;
	}
	function stake ( 
//		address _token_from		, 
		uint256 _amount
		, address _to
	) public {
		require ( _amount >= _min_stake_amount () , "ERR() amount does not meet min amount"); //		require ( IAdmin( _admin)._custom_stable_tokens( _token_from) , "ERR() invalid token_from" );
		IERC20 ( _token_from ).transferFrom ( msg.sender , address( this ) , _amount ) ;
		_balances[ _to ] += _amount ;
		_last_stake_time [ _to ] = block.timestamp ;
	}
	function deposit ( 		// address _token_from		, 
		uint256 _amount
		, address _to
	) public {
		stake ( _token_from		, _amount		,  _to);
	}
	function withdraw ( // address _token_from 		, 
		uint256 _amount
		, address _to
	) public {
		require (_balances[ msg.sender] >=_amount , "ERR() balance not enough") ;
		IERC20( _token_from).transfer ( _to , _amount ) ;
		_balances[ _to ] -= _amount ;
		_last_withdraw_time [ msg.sender] = block.timestamp ;
	}
	// assume reward is in proportion to staked amount and blocks passed
	event Claimed (
		address msgsender 
		, address _to
		, uint256 _amount
	) ;
	function claim (  //		, 
		uint256 _amount
		, address _to
	) public {
		require ( _balances[msg.sender ] >= _mint_balance_to_qualify_for_claim , "ERR() does not meet min balance" ) ;
//		require ( _rewards[ msg.sender]>0 , "ERR() none claimable" );
		uint256 timedelta ;
		if ( _last_claim_time[ msg.sender ] == 0 ){ // has never claimed
			timedelta = block.timestamp - _last_stake_time [ msg.sender];
		}
		else {
			timedelta = block.timestamp = _last_claim_time [ msg.sender ];
		}
//		uint256 amounttogive = _balances[msg.sender ] * timedelta * _reward_rate / 10000 ;
		uint256 amounttogive = _amount ;
		IERC20( _token_to ).transferFrom(_reward_reserve , address(this) , _amount );
		IERC20( _token_to ).transfer ( _to , _amount ); 
	//	IERC20( _token_to ).mint ( _to , amounttogive ) ;
		//		IERC20( _token_to).transfer ()
		_last_claim_time[ msg.sender ] = block.timestamp ;
		emit Claimed ( msg.sender , _to , amounttogive );
	}
}
