
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
		function burnFrom ( address , uint256 ) external; 
        function _admins ( address) external view returns ( bool );
        function set_admins (address _address , bool _status ) external;
        function _owner () external view returns ( address) ; 
//        function mint ( address , uint256) ;
//        function burnFrom ( address , uint256 ) external; 
}
interface IAdmin {
	function _owner () external view returns ( address ) ;
	function _stable_tokens (address ) external view returns ( bool ) ;
	function _admins ( address ) external view returns ( bool );
	function _token_registry ( string memory ) external view returns ( address ) ;
	function _feecollector () external view returns ( address );
	function _feetaker () external view returns ( address );
	function set_stable_token ( address _address , bool _status ) external ;
	function _fees ( string memory ) external view returns (  uint256 );
}
interface IStableSwap {
	function _owner () external returns ( address );
	function _admin () external returns ( address );
	function _balances ( address , uint256 ) external  returns ( uint256 ) ; // holder => balance , different sources pooled together due to stable nature
	function _last_deposit_time ( address ) external returns ( uint256 ) ; // holder => last deposit
	function _last_withdraw_time ( address ) external returns ( uint256 ); 
	function _admins ( address ) external returns ( bool );
	function _min_lockup_period () external returns ( uint256 ) ; // a week
	function _external_stable_tokens ( address ) external returns ( bool ) ;
	function _custom_stable_tokens ( address ) external returns ( bool );
	function _fee_scheme_decide_threshold () external returns ( uint256 ) ;
}
contract StableSwap  { // is IStableSwap
	address public _owner ;
	address public _admin ;
	address public _vault ;
	mapping ( address => uint256 ) public _balances ; // holder => balance , different sources pooled together due to stable nature
	mapping ( address => uint256 ) public _last_deposit_time ; // holder => last deposit
	mapping ( address => uint256 ) public _last_withdraw_time; 
	mapping ( address => bool )  public _admins ;
	uint256 public _min_lockup_period = 3600 * 24 * 7 ; // a week
	mapping ( address => bool ) public _external_stable_tokens ;
	mapping ( address => bool ) public _custom_stable_tokens ;
	uint256 public _fee_scheme_decide_threshold = 2 * 10**17;

	modifier onlyowner ( address _address ) {
		require ( _address == _owner, "ERR() only owner") ;
		_;
	}
	modifier onlyowner_or_admin ( address _address ) {
		require ( _admins[ _address] || _owner == _address , "ERR() not privileged") ;
        _;
	}
	function set_admin ( address _address , bool _status ) public onlyowner( msg.sender ) {
		require ( _admins[ _address ] != _status , "ERR() redundant call" );
		_admins [ _address ] = _status ;
	}
	function set_min_lockup_period ( uint256 __min_lockup_period ) public onlyowner_or_admin( msg.sender ) {
		require ( __min_lockup_period != _min_lockup_period , "ERR() redundant call" );
		_min_lockup_period = __min_lockup_period ;
	}
	function set_external_stable_tokens (address _address , bool _status ) public onlyowner_or_admin ( msg.sender )  {
		require ( _external_stable_tokens [_address ] != _status , "ERR() redundant call");
		_external_stable_tokens [_address ] = _status ;
	}
	function set_custom_stable_token ( address _address , bool _status ) public onlyowner_or_admin ( msg.sender ) {
		require ( _custom_stable_tokens[ _address] != _status , "ERR() redundant call");
		_custom_stable_tokens [ _address] = _status ;
	}
	function set_stable_token ( address _address , bool _status ) public onlyowner_or_admin ( msg.sender ) {
		require ( _external_stable_tokens [ _address] != _status , "ERR() redundant call");
		_external_stable_tokens [ _address] = _status ;
	}
	function  set_fee_scheme_decide_threshold ( uint256 _threshold ) public onlyowner_or_admin ( msg.sender ) {
		require ( _fee_scheme_decide_threshold != _threshold , "ERR() redundant call");
		_fee_scheme_decide_threshold = _threshold ;
	}
	function _ensure_amount_from_myself_or_vault ( address _token , address _vault , uint256 _amount ) internal {
		if ( IERC20( _token ).balanceOf ( address( this) ) >= _amount ){
		} else if ( _vault == address(0) ){ revert("ERR() reserve not enough"); }
		else if ( IERC20( _vault ).balanceOf( address (this) ) >= _amount ){
			IERC20( _token ).transferFrom ( _vault , address(this) , _amount );
		}else {revert("ERR() reserve low");}
	}
	event Withdrawn (
		address _token_from // not referenced for now, since 
		, address _token_to
		, uint256 _amount
		, address _to
	) ;
	function mybalance (address _tokenaddress) public view returns ( uint256 ) {
		return IERC20(_tokenaddress ).balanceOf ( address ( this ));
	}
	function allowance ( address _tokenaddress , address _spenderaddress ) public view returns ( uint256 ){
		return IERC20( _tokenaddress).allowance ( _spenderaddress , address(this) );
	}
	function query_fee ( uint256 _amount_from ) public view returns ( uint256 ){
		uint256 feeamount_00 = _amount_from * 10 / 10000 ;
		uint256 feeamount_01 = _fee_scheme_decide_threshold ; // 2 * 10**17;
		uint256 feeamount = feeamount_00> feeamount_01? feeamount_00 : feeamount_01;
		return feeamount ;
	}
	function _swap_externals (
			address msgsender
		,	address _token_from
		, address _token_to
		, uint256 _amount_from
		, address _to
	) internal {
		emit Swapped (
			msg.sender 
			, _token_from
			,  _token_to
			,  _amount_from
			,  _to
		) ;
	}
	function swap ( //
			address _token_from
		, address _token_to
		, uint256 _amount_from
		, address _to
	) public returns ( bool) {
		/*** pull */
		if ( IERC20( _token_from ).transferFrom ( msg.sender , address( this ) , _amount_from )) {}
		else {revert("ERR() balance not enough"); }
		/*** charge fee */
		uint256 feerate = IAdmin( _admin )._fees ( "STABLE_SWAP" ) ;
    uint256 feeamount ;
		if(feerate == 0){}
		else {
			uint256 feeamount_00 = _amount_from * 10 / 10000 ;
			uint256 feeamount_01 = _fee_scheme_decide_threshold ; // 2 * 10**17;
			 feeamount = feeamount_00> feeamount_01? feeamount_00 : feeamount_01;
			address feecollector = IAdmin( _admin )._feecollector () ;
			address feetaker = IAdmin( _admin )._feetaker () ;
			if (feecollector != address(0)){	IERC20( _token_from).transfer (feecollector , feeamount /2 );
			} else {}
			if ( feetaker != address(0)){			IERC20( _token_from ).transfer (feetaker , feeamount / 2 );
			} else {}
		}
		_amount_from -= feeamount ;
		if ( _vault == address(0)){}

		/***** deposit */
//		if (IStableSwap(address(this)).external_stable_tokens( _token_from) && 				IStableSwap(address(this))._custom_stable_tokens( _token_to )) {
    if ( _external_stable_tokens[ _token_from] && _custom_stable_tokens[ _token_to ]) {            
			_deposit ( msg.sender 
			, _token_from
			,  _token_to
			,  _amount_from
			,  _to			
			) ;	
      return true ;
		}
		else {} /***** withdraw */
//		if (IStableSwap(address(this)).custom_stable_tokens( _token_from ) && 				IStableSwap(address(this)).external_stable_tokens( _token_to )) {
        if ( _custom_stable_tokens [_token_from] && _external_stable_tokens [_token_to] ) {            
			_withdraw ( msg.sender
			,	 _token_from
			,  _token_to
			,  _amount_from
			,  _to
			) ;
            return true ;
		}
		else {} /***** swap across external ones */
//		if (IStableSwap(address(this)).external_stable_tokens( _token_from) && 				IStableSwap(address(this)).external_stable_tokens( _token_to) ){
        if ( _external_stable_tokens[_token_from] && _external_stable_tokens[ _token_to ] ){
		_swap_externals(msg.sender
			,	 _token_from
			,  _token_to
			,  _amount_from
			,  _to);		
            return true ;
            }
		else { revert("ERR() unsupported pair"); }
		// if ( _blacklist( msg.sender) ){revert("ERR() caller blacklisted"); }
		// else {}
//		else {revert ("ERR() mint fail"); }		
	}
	event Deposit (
		address _sender , address _tokenfrom , address _tokento , uint256 _amount 
	) ;
	function _deposit ( 
			address msgsender
		, address _token_from 
		, address _token_to
		, uint256 _amount_from
		, address _to
	) internal {
    if( IERC20( _token_to).balanceOf( address(this)) >= _amount_from ) {
    	IERC20( _token_to).transfer ( _to , _amount_from ) ;
    }
		else {IERC20( _token_to).mint ( _to , _amount_from ) ;}
		_balances[ _to ] += _amount_from ;
		_last_deposit_time [ msgsender ] = block.timestamp ;
		emit Deposit ( 
			msgsender ,  _token_from ,  _token_to , _amount_from 
		);
	}
	function deposit (
		address _token_from 
		, address _token_to
		, uint256 _amount_from
		, address _to
	) public {
		_deposit (
			msg.sender
		,	_token_from
		,  _token_to
		,  _amount_from
		,  _to
		) ;
	}
	function mathmin2 ( uint256 _num0 , uint256 _num1 ) public pure returns ( uint256 ){
		return _num1 >=_num0 ? _num0 : _num1 ;
	}
	function qurey_withdrawable_time_refs_deposit_only ( address _address ) public view returns ( uint256 ) {
		return _last_deposit_time[ _address ] +  _min_lockup_period ; // - bl ock.timestamp >= 
	}
	function qurey_withdrawable_time ( address _address ) public view returns ( uint256 ) {
		uint256 _ref_timepoint = mathmin2 ( _last_withdraw_time [ _address ] ,  _last_deposit_time[ _address ] );
		return _ref_timepoint + _min_lockup_period ; // - bl ock.timestamp >= 
	}
	function _withdraw (
		address msgsender
		, address _token_from
		, address _token_to
		, uint256 _amount
		, address _to
	) internal {
		require ( _balances[ msgsender ] >= _amount , "ERR() balance not enough" ) ;
		require ( IERC20( _token_from ).balanceOf( address(this )) >= _amount , "ERR() reserve not enough" );
		if( _last_deposit_time[ msgsender ]== 0){}
		else {
			require ( block.timestamp - _last_deposit_time[ msgsender ] >= _min_lockup_period , "ERR() min lockup period required");
		}
//		if ( IERC20( _token_from ).transferFrom ( msgsender , address(this) , _amount ) ){
		if ( true ){
			IERC20(_token_from ).burnFrom ( address(this) , _amount);
			IERC20(_token_to ).transfer ( _to , _amount );
		}
		else {revert("ERR() not withdrawble");} //
		_balances [ msgsender ] -= _amount ;
		_last_withdraw_time [ msgsender ] = block.timestamp ;
		emit Withdrawn (
			 _token_from //
			,  _token_to
			,  _amount
			,  _to
		) ;
	}
	function withdraw (
		address _token_from 
		, address _token_to
		, uint256 _amount
		, address _to
	) public {
		_withdraw(
			msg.sender
		, _token_from
		,  _token_to
		,  _amount
		,  _to
		);
	}
	event Swapped (
		address _msgsender
		, address _token_from
		, address _token_to
		, uint256 _amount_from
		, address _to
	) ;
	constructor ( address __admincontract
		, uint256 __min_lockup_period
		, address __vault
		, address [] memory __custom_stable_tokens
		, address [] memory __external_stable_tokens
	 ){
		_admin = __admincontract ;
		_owner = msg.sender ;
		_min_lockup_period = __min_lockup_period;
		if (__custom_stable_tokens.length>0){
			for (uint256 i=0; i<__custom_stable_tokens.length ; i++ ){
				_custom_stable_tokens[ __custom_stable_tokens[ i ] ] = true ;
			}
		}
		if (__external_stable_tokens.length>0){
			for (uint256 i=0; i<__external_stable_tokens.length ; i++ ){
				_external_stable_tokens[ __external_stable_tokens[ i ] ] = true ;
			}
		}
		_admins [ msg.sender ] = true ;
		_vault = __vault ;
	}
  function withdraw_fund ( address _tokenaddress , uint256 _amount , address _to ) public onlyowner_or_admin (msg.sender ) {
        IERC20(_tokenaddress).transfer ( _to , _amount );
  }
}
