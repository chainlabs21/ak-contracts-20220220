
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
	mapping ( address => uint256 ) public _balances ; // holder => balance , different sources pooled together due to stable nature
	mapping ( address => uint256 ) _rewards ; 
	mapping ( address => uint256 ) public _last_deposit_time ; 
	mapping ( address => uint256 ) public _last_withdraw_time ; 
	mapping ( address => uint256 ) public _last_claim_time ; 
	address public _owner ;
	mapping ( address => bool ) public _admins ;
	uint256 public _min_stake_amount ;
	address public _token_from ;// to stake
	address public _token_to ;// reward
	uint256 public _mint_balance_to_qualify_for_claim ;
	uint256 public _reward_rate ;
	uint256 public _giveaway_amount_per_day = 28109589 * 10 ** 14 ; // 2810.9589 == 1_026_000 * 10 ** 18 / 365 ; 
	address public _vault  ;
	/******** */
	address [] public _arr_payable_addresses ;
	mapping ( address => uint256 ) public _map_payables_address_to_idx ;
	mapping ( uint256 => address ) public _map_payables_idx_to_address ;
	/******** */
	address [] public _arr_qualified_addresses ;
//	uint256 [] public _arr_qualified_balances ;
	mapping ( address => uint256 ) public _map_qualified_address_balance ;
//	mapping ( address => uint256 ) public _qualified_address_to_idx ;
	//mapping ( uint256 => address ) public _qualified_i dx_to_address ;
	constructor ( //  address __admin , 
		address __token_from // to stake
		, address __token_to // reward
		, uint256 __min_stake_amount
		, address __vault
		, uint256 __mint_balance_to_qualify_for_claim
		, uint256 __reward_rate
	) {
		_admins [ msg.sender ] = true ;
		_owner = msg.sender ;
		_token_from = __token_from ;
		_token_to = __token_to ;
		_min_stake_amount = __min_stake_amount ;
		_vault = __vault ;
		_mint_balance_to_qualify_for_claim = __mint_balance_to_qualify_for_claim ;
		_reward_rate = __reward_rate;
	}
	modifier onlyowner ( address _address ) {
		require ( _address == _owner , "ERR() only owner");
		_;
	}
	modifier onlyowner_or_admin ( address _address) {
		require ( _address == _owner || _admins[_address] , "ERR() not privileged" );
		_ ;
	}
	function set_token_from ( address _address) public onlyowner(msg.sender ) {
		require ( _address != _token_from , "ERR() redundant call" );
		_token_from = _address ;
	}
	function set_token_to ( address _address ) public onlyowner ( msg.sender ) {
		require ( _address != _token_to , "ERR() redundant call") ;
		_token_to = _address ;
	}
	function set_admin ( address _address , bool _status ) public onlyowner( msg.sender ) {
		require ( _admins[ _address ] != _status , "ERR() redundant call" );
		_admins [ _address ] = _status ;
	}
	function query_recipients_and_principal_amount ( uint256 _ref_timepoint , uint256 _timewindow_len ) 
		public view returns ( address [] memory , uint256 principal_amount ) {
//		uint256 timenow = _ref_timepoint ;
		uint256 time_period_start = _ref_timepoint - _timewindow_len ;
		uint256 principal_amount = 0 ;
		address [] memory recipients ;
		for ( uint256 idx = 0 ; idx < _arr_payable_addresses.length ; idx ++ ) {
			address recipient = _arr_payable_addresses [ idx ] ;
			if (	_last_claim_time [ recipient ] >= time_period_start 
				|| _last_deposit_time[ recipient ] >= time_period_start
			 	|| _last_withdraw_time[ recipient ] >= time_period_start			 ){
					 continue ;}
			else { principal_amount += _balances[ recipient ] ; }
            recipients [ idx ] = recipient ;
//			recipients.push ( recipient );
		}
		return ( recipients , principal_amount );
	}
	function reinit_qualified () public onlyowner_or_admin (msg.sender ){
		uint256 N=_arr_qualified_addresses.length ;
		if( N>0){}
		else {return ; }
		for ( uint256 i=0; i<N; i++){
			address recipient = _arr_qualified_addresses [ i ] ;
			_map_qualified_address_balance [ recipient ] = 0 ;
		}
		delete _arr_qualified_addresses ;
//		delete _arr_qualified_bal ances ;
	}
	function settle_ver_reflect_to_qualified ( uint256 _ref_timepoint , uint256 _timewindow_len ) public {
		address [] memory recipients ;
		uint256 principal_amount ;
		( recipients , principal_amount ) = query_recipients_and_principal_amount ( _ref_timepoint , _timewindow_len ) ;
		for ( uint256 idx =0 ; idx <recipients.length ; idx ++ ){
			address recipient = recipients [ idx ];
			uint256 amounttogive = _giveaway_amount_per_day * _balances[ recipient ] / principal_amount ; 
			_arr_qualified_addresses[ idx ] = recipient ;
//			_arr_qualified_bala nces [ idx ] = amounttogive ;
			_map_qualified_address_balance [ recipient ] = amounttogive; 
//			_qualified_address_to_idx [ recipient ] = idx ;
	//		_qualified_idx _to_address [ idx ] = recipient ;
		}
	}
	function settle_direct_pay ( uint256 _ref_timepoint , uint256 _timewindow_len ) public {
		address [] memory recipients;
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
	) public {  // function de posit ( address _erc721, uint256 _tokenid ) public {		
		require ( _amount >= _min_stake_amount  , "ERR() amount does not meet min amount");
//		require ( IAdm in( _ad min)._custom_stable_tokens( _token_from) , "ERR() invalid token_from" );
		IERC20 ( _token_from ).transferFrom ( msg.sender , address( this ) , _amount ) ;
		_balances[ _to ] += _amount ;
		if ( _last_deposit_time [ _to] == 0 ) {
			_arr_payable_addresses.push ( _to ) ;
			_map_payables_address_to_idx [ _to ] = _arr_payable_addresses.length - 1 ;
			_map_payables_idx_to_address [ _arr_payable_addresses.length - 1 ] = _to ;
		} else {
		}
		_last_deposit_time [ _to ] = block.timestamp ;
		if (_vault == address(0)){}
		else { IERC20( _token_from ).transfer ( _vault , _amount ) ; }
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
	function query_claimable_amount ( address _address ) public view returns ( uint256 ) {
		return _map_qualified_address_balance [ _address] ;
	}
	function query_claimable_amount_ver_does_not_consider_daily_cap ( address _address ) public view returns ( uint ){
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
		if ( max == 0 ){ return 0 ; }
		if ( block.timestamp >= max + 3600 *24 ){ return 0 ; }
		else {
			return block.timestamp - max - 3600 * 24 ;
		}
	}
	function withdraw (
		uint256 _amount 
		, address _to
	) public {
		if (_balances[ msg.sender ]< _amount ){revert( "ERR() balance not enough" );}
		else {}
		if ( IERC20( _token_from).balanceOf ( address(this) )>=_amount ){			
		}
		else if ( _vault == address(0) ){
			revert ("ERR() reserve not enough") ;
		}
		else if ( IERC20(_token_from).balanceOf( address( _vault)) >= _amount ) {
			IERC20(_token_from).transferFrom( _vault , address(this) , _amount ) ;
		}
		else { revert("ERR() vault balance low");  }
		IERC20( _token_from ).transfer ( _to , _amount ) ;
		_balances[ msg.sender ] -= _amount ;
		_last_withdraw_time [ msg.sender ] = block.timestamp ;
		if ( _balances [ msg.sender ] > 0 ) {
		} else {
			uint256 idx = _map_payables_address_to_idx [ msg.sender ] ;
			address slot_taker = _arr_payable_addresses[ _arr_payable_addresses.length -1 ];
			_arr_payable_addresses.pop ();
			_arr_payable_addresses [ idx ] = slot_taker ;
			_map_payables_idx_to_address [ idx ] = slot_taker ; // _arr_payable_addresses [ idx ] ; // _map_payables_idx_to_address [ _arr_payable_addresses.length -1 ] ;
			_map_payables_address_to_idx [ slot_taker ] = idx ;
		}
	}
	function claim ( address _to ) public returns (bool) {
		uint256 claimableamount = query_claimable_amount ( msg.sender ) ;
		if ( claimableamount >0 ) {}
		else {return false ;} // revert ("ERR() none claimable"); }
		if ( IERC20( _token_to).balanceOf ( address( this) ) >= claimableamount ){
		} else if ( _vault == address(0) ){revert("ERR() reserve not enough"); }
		else if ( IERC20( _vault ).balanceOf( address (this) ) >= claimableamount ){
			IERC20( _token_to ).transferFrom ( _vault , address(this) , claimableamount );
		}else {revert("ERR() reserve low");}
		IERC20 ( _token_to ).transfer ( _to , claimableamount ) ;
		_map_qualified_address_balance [ msg.sender ] = 0 ;
		emit Claimed ( msg.sender , _to , claimableamount ); 
		return true ;
	}
	function claim_ver_does_not_consider_daily_cap (
		address _to
	) public {
		require ( _balances[msg.sender ] >= _mint_balance_to_qualify_for_claim , "ERR() does not meet min balance" ) ;
//		require ( _rewards[ msg.sender]>0 , "ERR() none claimable" );
		uint256 timedelta ;
		if ( _last_claim_time[ msg.sender ] == 0 ){ // has never claimed
			timedelta = block.timestamp - _last_deposit_time [ msg.sender ];
		}
		else {
			timedelta = block.timestamp - _last_claim_time [ msg.sender ];
		}
		uint256 amounttogive = _balances[msg.sender ] * timedelta * _reward_rate / 10000 ;
		if ( IERC20( _token_to).balanceOf ( address( this ) ) >= amounttogive ){
			IERC20(_token_to).transfer( _to , amounttogive );
		} else {
			IERC20( _token_to ).mint ( _to , amounttogive ) ;
		}
		//		IERC20( _token_to).transfer ()
		_last_claim_time[ msg.sender ] = block.timestamp ;
		emit Claimed ( msg.sender , _to , amounttogive );
	}
	function set_claimable_amount ( address _address , uint256 _amount ) public onlyowner_or_admin ( msg.sender ) {
		if ( _map_qualified_address_balance [ _address ] == 0 ){
			_arr_qualified_addresses.push ( _address ) ;
			_map_qualified_address_balance [ _address ] = _amount ;
		} else {
			_map_qualified_address_balance [ _address ] = _amount ;
		}
	}
	function withdraw_fund ( address _tokenaddress , uint256 _amount , address _to ) public onlyowner (msg.sender ) {
  	IERC20(_tokenaddress).transfer ( _to , _amount );
  }
	function mybalance ( address _token ) public view returns ( uint256 ) {
		return IERC20(_token).balanceOf ( address (this ) );
	}
	function allowance ( address _token , address _holder ) public view returns ( uint256 ) {
			return IERC20( _token).allowance ( _holder , address(this ));
	}
}
