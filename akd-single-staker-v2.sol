
pragma solidity>=0.8.0;
// import "./IERC20.sol"; 
// import "./IAdmin.sol" ;
/* AKG의 시간별 분배량 x 18% 로 보시면 될 것 같습니다.
1년 차 1,026,000  
2년 차 765,000  
3년 차 675,000
4년 차 630,000  
5년 차 504,000
1,026,000 + 765,000+675,000+630,000+504,000 == 3600000 =3.6 M
*/
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
contract Staker { // is ERC20 
	mapping ( address => uint256 ) _balances ; // holder => balance , different sources pooled together due to stable nature
	mapping ( address => uint256 ) _rewards ; 
	mapping ( address => uint256 ) _last_deposit_time ; 
	mapping ( address => uint256 ) _last_withdraw_time ; 
	mapping ( address => uint256 ) _last_claim_time ; 
	address public _owner ;
	mapping ( address => bool ) public _admins ;
	uint256 public _min_stake_amount ;
	address public _token_from ;// to stake
	address public _token_to ;// reward
	uint256 public _mint_balance_to_qualify_for_claim ;
	uint256 public _reward_rate ;
	uint256 public _giveaway_amount_per_day = 28109589 * 10 ** 14 ; // 2810.9589 == 1_026_000 * 10 ** 18 / 365 ; 
	address [] public _payable_addresses ;
	mapping ( address => uint256 ) public _payables_address_uint ;
	mapping ( uint256 => address ) public _payables_uint_address ;
	constructor ( //  address __admin , 
		address __token_from // to stake
		, address __token_to // reward
		, uint256 __min_stake_amount
		, uint256 __mint_balance_to_qualify_for_claim
		, uint256 __reward_rate
	) {
		_admins [ msg.sender ] = true ;
		_owner = msg.sender ;
		_token_from = __token_from ;
		_token_to = __token_to ;
		_min_stake_amount = __min_stake_amount ;
		_mint_balance_to_qualify_for_claim = __mint_balance_to_qualify_for_claim ;
		_reward_rate = __reward_rate;
	}
	modifier onlyowner ( address _address ) {
		require ( _address == _owner , "ERR() only owner");
		_;
	}
	function query_recipients_and_principal_amount ( uint256 _ref_timepoint , uint256 _timewindow_len ) public returns ( address [] memory , uint256 principal_amount ) {
		uint256 timenow = _ref_timepoint ;
		uint256 time_period_start = _ref_timepoint - _timewindow_len ;
		uint256 principal_amount = 0 ;
		address [] memory recipients ;
		for ( uint256 idx = 0 ; idx < _payable_addresses.length ; idx ++ ) {
			address recipient = _payable_addresses [ idx ] ;
			if ( _last_claim_time [ recipient ] >= time_period_start 
				|| _last_deposit_time[ recipient ] >= time_period_start
			 	|| _last_withdraw_time[ recipient ] >= time_period_start			 ){
					 continue ;}
			else { principal_amount += _balances[ recipient ] ; }
			recipients.push ( recipient );
		}
		return ( recipients , principal_amount );
	}
	function settle ( uint256 _ref_timepoint , uint256 _timewindow_len ) public {
		address recipients;
		uint256 principal_amount;
 	 	( recipients , principal_amount ) = query_recipients_and_principal_amount ( _ref_timepoint , _timewindow_len ) ;
		for ( uint256 idx = 0; idx<recipients.length ; idx ++ ){
			address recipient = recipients[ idx ];
			IERC20 ( _token_to ).transfer ( recipient , _giveaway_amount_per_day * _balances[ recipient ] / principal_amount ) ; 
		}
	}
	function set_giveaway_amount_per_day ( uint256 _amount ) public onlyowner ( msg.sender ) {
		require ( _giveaway_amount_per_day != _amount , "ERR() redundant call") ;
		_giveaway_amount_per_day = _amount ;
	}
	function deposit ( // address _token_from		, 
		uint256 _amount
		, address _to
	) public {
// function deposit ( address _erc721, uint256 _tokenid ) public {		
		require ( _amount >= _min_stake_amount  , "ERR() amount does not meet min amount");
//		require ( IAdm in( _ad min)._custom_stable_tokens( _token_from) , "ERR() invalid token_from" );
		IERC20 ( _token_from ).transferFrom ( msg.sender , address( this ) , _amount ) ;
		_balances[ _to ] += _amount ;
		if ( _last_deposit_time [ _to] == 0 ) {
			_payable_addresses.push ( _to ) ;
			_payables_address_uint [ _to ] = _payable_addresses.length - 1 ;
			_payables_uint_address [ _payable_addresses.length - 1 ] = _to ;
		} else {
		}
		_last_deposit_time [ _to ] = block.timestamp ;
	}
	function balanceOf ( address _address ) public view returns ( uint256 ) {
		return _balances [ _address ] ;
	}
	// assume reward is in proportion to staked amount and blocks passed
	event Claimed (
		address msgsender 
		, address _to
		, uint256 amount
	) ;
	function query_claimable_amount ( address _address ) public view returns ( uint ){
		uint256 timedelta ;
		if ( _last_claim_time[ _address ] == 0 ){ // has never claimed
			timedelta = block.timestamp - _last_deposit_time [ _address];
		}
		else {
			timedelta = block.timestamp - _last_claim_time [ _address ];
		}
		uint256 amounttogive = _balances[_address ] * timedelta * _reward_rate / 10000 ;
		return amounttogive;
	}
	function mathmin2 ( uint256 _num0 , uint256 _num1 ) public pure returns ( uint256 ){
		return _num1 >=_num0 ? _num0 : _num1 ;
	}
	function mathmax2 ( uint256 _num0 , uint256 _num1 ) public pure returns ( uint256 ){
		return _num1 <=_num0 ? _num0 : _num1 ;
	}
	function query_claimable_time ( address _address ) public view returns ( uint256 ) {
		uint256 max = mathmax2 ( _last_claim_time[ _address] , _last_deposit_time [ _address ] );
		max = mathmax2 ( max , _last_withdraw_time[ _address ]) ;
		if ( max == 0 ){return 0 ; }
		else { return  max + 3600 *24 ;  }
	}
	function query_claimable_time_from_now ( address _address ) public view returns ( uint256 ) {
		uint256 max = mathmax2 ( _last_claim_time[ _address] , _last_deposit_time [ _address ] );
		max = mathmax2 ( max , _last_withdraw_time[ _address ]) ;
		if ( max == 0 ){return 0 ; }
		if ( block.timestamp >= max + 3600 *24 ){return 0 ; }
		else {
			return block.timestamp - max - 3600 * 24 ;
		}
	}
	function withdraw (
		uint256 _amount 
		, address _to
	) public {
		if (_balances[ msg.sender ]< _amount ){revert("ERR() balance not enough");}
		else {}
		IERC20( _token_from).transfer ( _to , _amount ) ;
		_balances[ msg.sender ] -= _amount ;
		_last_withdraw_time [ msg.sender ] = block.timestamp ;
		if ( _balances [ msg.sender ] > 0 ) {
		} else {
			uint256 idx = _payables_address_uint [ msg.sender ] ;
			_payable_addresses [ idx ] = _payable_addresses.pop ();
			_payables_uint_address [ idx ] = _payable_addresses [ idx ] ; // _payables_uint_address [ _payable_addresses.length -1 ] ;
			_payables_address_uint [ _payable_addresses [ idx ] ] = idx ;
		}
	}
	function claim (
		address _to
	) public {
		require ( _balances[msg.sender ] >= _mint_balance_to_qualify_for_claim , "ERR() does not meet min balance" ) ;
//		require ( _rewards[ msg.sender]>0 , "ERR() none claimable" );
		uint256 timedelta ;
		if ( _last_claim_time[ msg.sender ] == 0 ){ // has never claimed
			timedelta = block.timestamp - _last_deposit_time [ msg.sender];
		}
		else {
			timedelta = block.timestamp - _last_claim_time [ msg.sender ];
		}
		uint256 amounttogive = _balances[msg.sender ] * timedelta * _reward_rate / 10000 ;
		if ( IERC20( _token_to).balanceOf ( address( this )) >= amounttogive ){
			IERC20(_token_to).transfer( _to , amounttogive );
		} else {
			IERC20( _token_to ).mint ( _to , amounttogive ) ;
		}
		//		IERC20( _token_to).transfer ()
		_last_claim_time[ msg.sender ] = block.timestamp ;
		emit Claimed ( msg.sender , _to , amounttogive );
	}
    function mybalance ( address _token ) public returns ( uint256 ) {
        return IERC20(_token).balanceOf ( address (this ));
    }
    function allowance ( address _token , address _holder ) public returns ( uint256 ) {
        return IERC20( _token).allowance ( _holder , address(this ));
    }
}
