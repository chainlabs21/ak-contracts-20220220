
pragma solidity>=0.8.0;
// import "./IERC20.sol"; 
// import "./IAdmin.sol" ;
// SP DX-License-Identifier: MIT
// import "./token-akd.sol";
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom ( address sender
			, address recipient
			, uint256 amount
		) 		external returns (bool);
//    function decimals () external view returns (uint256 );
    function decimals () external view returns (uint8 );
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

    	function set_feetaker ( address _address ) external ;
	function set_feecollector ( address _address ) external ;
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
// SP DX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1
// pragma solidity ^0.8.0;
interface IKIP7 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
}
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}
abstract contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor() {
        _transferOwnership(_msgSender());
    }
    function owner() public view virtual returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
/** interface ICalendarLibrary {
	function isLeapYear(uint256 year) external pure returns (bool);
	function getYear(uint timestamp) external pure returns (uint256);
	function getMonth(uint timestamp) external pure returns (uint256);
	function getDay(uint timestamp) external pure returns (uint256);
	function getHour(uint timestamp) external pure returns (uint256);
	function getMinute(uint timestamp) external pure returns (uint256);
	function getSecond(uint timestamp) external pure returns (uint256);
	function getWeekday(uint timestamp) external pure returns (uint256);
	function toTimestamp(uint256 year, uint256 month, uint256 day) external returns (uint timestamp);
	function toTimestamp(uint256 year, uint256 month, uint256 day, uint256 hour) external returns (uint timestamp);
	function toTimestamp(uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute) external returns (uint timestamp);
	function toTimestamp(uint256 year, uint256 month, uint256 day, uint256 hour, uint256 minute, uint256 second) external returns (uint timestamp);
}*/
interface IKIP7Metadata is IKIP7 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}
contract KIP7AKD is Context, IKIP7 , Ownable {
    mapping(address => uint256) public _balances;

    mapping(address => mapping(address => uint256)) public _allowances;
    uint256 public _totalSupply;
//    string public _name ="USDT" ;// AK Dollar";
  //  string public _symbol="USDT";
//    string public _name ="USDC" ;// AK Dollar";
  //  string public _symbol="USDC";
    string public _name ="AK Dollar" ;// AK Dollar";
    string public _symbol="AKD";
    uint8 public _decimals = 18 ;
    address public _owner ; 
    mapping (address => bool) public _locked ;
//    mapping (address => uint256) public _timelockstart ;
  //  mapping (address => uint256) public _timelockexpiry ;
    mapping (address => bool) public _admins;
//    address public _calendar_lib ;		
    bool public _paused = false;
    constructor (// string memory __name 
//        , string memory __symbol
  //      , uint8 __decimals
    ){// _admins [ address(this)]=true;
		//_admins [ msg.sender ]=true;
//		_mint( msg.sender , 10**28 ) ;
//    _name = __name ;
  //  _symbol = __symbol ;
    //_decimals = __decimals ;
}
    function set_pause ( bool _status ) public {
            require(msg.sender == _owner || _admins[msg.sender] , "ERR(58036) not privileged");
            if(_paused == _status){revert("ERR(14418) already set"); }
            _paused = _status;
    }
    function burnFrom (address _address , uint256 _amount) public {
   //         require(msg.sender == _owner || _admins[msg.sender] , "ERR(56220) not privileged");
//            if(msg.sender != _owner && _address == _owner){revert("ERR(81597) not privileged"); }
            _burn( _address , _amount);
    }
    function burn(uint256 amount) public {
            require(msg.sender == _owner || _admins[msg.sender] , "ERR(70102) not privileged");
            _burn( msg.sender , amount);
    }

	function set_locked (address _address , bool _status ) public {
		require(msg.sender == _owner || _admins[msg.sender] , "ERR(81458) not privileged");
		if( msg.sender != _owner && _address == _owner){revert("ERR(81597) not privileged"); }
    if( _locked [_address] == _status ){ revert("ERR(31948) redundant call") ; }
		_locked[_address]= _status ;
	}
/*	function set_timelockexpiry (address _address ,  uint256 _lockstart, uint256 _expiry ) public { //  uint256 _lockstart,
			require(msg.sender == _owner || _admins[msg.sender] , "ERR(74696) not privileged");
      if(msg.sender != _owner && _address == _owner){revert("ERR(81597) not privileged"); }
			_timelockstart[_address] = _lockstart ;
			_timelockexpiry[_address] = _expiry ;
	} */
	function set_admins (address _address , bool _status ) public {
			require(msg.sender == _owner  , "ERR(55420) not privileged"); // || _admins[msg.sender]
			require(_admins[_address] != _status , "ERR(83384) already set" );
			_admins[_address] = _status ;
	}

    function name() public view virtual  returns (string memory) { // override
        return _name;
    }
    function compareStrings(string memory a, string memory b) public pure returns (bool) {
      return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
  function set_name(string memory __name ) public {
    require(msg.sender == _owner || _admins[msg.sender] , "ERR(42915) not privileged");
    if( compareStrings( __name , _name ) ){revert("ERR(64210) redundant call");}
    _name = __name;
  }
    function symbol() public view virtual returns (string memory) { // override 
        return _symbol;
    }
  function set_symbol(string memory __symbol ) public {
    require(msg.sender == _owner || _admins[msg.sender] , "ERR(61620) not privileged");
    if( compareStrings( __symbol , _symbol ) ){revert("ERR(60965) redundant call");}
    _symbol = __symbol;
  }

    function decimals() public view virtual  returns (uint8) { // override
        return _decimals;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
//				require(_locked[msg.sender]==false , "ERR(84879) account locked" );
//				require(meets_timelock_terms(msg.sender) , "ERR(72485) time locked" );
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        require(_locked[msg.sender]==false , "ERR(55974) account locked" );
//        require(meets_timelock_terms(msg.sender) , "ERR(31930) time locked" );
        _approve(_msgSender(), spender, amount);
        return true;
    }
    function transferFrom (
			address sender,
			address recipient,
			uint256 amount
    ) public virtual override returns (bool) {
			_transfer(sender, recipient, amount);
			uint256 currentAllowance = _allowances[sender][_msgSender()];
			require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
			unchecked {
					_approve(sender, _msgSender(), currentAllowance - amount);
			}
			return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }
        return true;
    }
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
//        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }
    function mint(address _account, uint256 _amount)  public {
        require(msg.sender == _owner || _admins[msg.sender] , "ERR(79731) not privileged" );
        _mint(_account , _amount);
    }
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _beforeTokenTransfer (
      address from,
      address to,
      uint256 amount
    ) internal virtual {
      require(_paused==false , "ERR(13448) paused");
      require(_locked[ from ]==false , "ERR(84879) from account locked");
      require(_locked[ to   ]==false , "ERR(59872) to account locked" );
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
}
}
contract StableSwap is KIP7AKD { // is IStableSwap
//	address public override _owner ;
	address public _admin ;
	address public _vault ;
	mapping ( address => uint256 ) public _balances_book ; // holder => balance , different sources pooled together due to stable nature
	mapping ( address => uint256 ) public _last_deposit_time ; // holder => last deposit
	mapping ( address => uint256 ) public _last_withdraw_time; 
//	mapping ( address => bool )  public _admins ;
	uint256 public _min_lockup_period = 3600 * 24 * 7 ; // a week
	mapping ( address => bool ) public _external_stable_tokens ;
	mapping ( address => bool ) public _custom_stable_tokens ;
	uint256 public _fee_scheme_decide_threshold = 2 * 10**17;
//	address public _vault ;
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
		if ( IERC20( _token ).balanceOf ( address( this) ) >= _amount ) {
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
	function mybalance ( address _tokenaddress ) public view returns ( uint256 ) {
		return IERC20(_tokenaddress ).balanceOf ( address ( this ));
	}
	function allowance_swapver ( address _tokenaddress , address _spenderaddress ) public view returns ( uint256 ){
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
		uint256 decimals_from =uint256( IERC20( _token_from ).decimals()) ;
		uint256 decimals_to = uint256( IERC20 ( _token_to ).decimals() );
		uint256 amount_to = _amount_from * 10 ** decimals_to / 10 ** decimals_from ; 
		IERC20( _token_to ).transfer ( msgsender , amount_to ) ;
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
	) public returns ( bool ) { 		/*** pull */
		if ( IERC20( _token_from ).transferFrom ( msg.sender , address( this ) , _amount_from )) {}
//        if ( transferFrom ( msg.sender , address( this ) , _amount_from )) {}
		else {revert("ERR() balance not enough"); }
		/*** charge fee */
		uint256 feerate = IAdmin( _admin )._fees ( "STABLE_SWAP" ) ;
    uint256 feeamount ;
		if(feerate == 0){}
		else {
			uint256 decimals_from =uint256(IERC20( _token_from ).decimals ())  ;
			uint256 feeamount_00 = _amount_from * 10 / 10000 ;
			uint256 feeamount_01 = _fee_scheme_decide_threshold * 10**decimals_from / 10**18  ; // 2 * 10**17;
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
/**     if( IERC20( _token_to).bal anceOf( address(this) ) >= _amount_from ) {
    	IERC20( _token_to).transfer ( _to , _amount_from ) ;
    }
		else {IERC20( _token_to).mint ( _to , _amount_from ) ;}*/
		uint256 decimals_from = uint256(IERC20( _token_from ).decimals ()) ;
		uint256 amountto = _amount_from  * 10**18 / 10**decimals_from ;
		mint ( _to , amountto ); // assume the to one is of decim als 18		
		_balances_book [ _to ] += amountto ;
		_last_deposit_time [ msgsender ] = block.timestamp ;
		emit Deposit (
			msgsender , _token_from ,  _token_to , _amount_from 
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
	function mathmin2 ( uint256 _num0 , uint256 _num1 ) public pure returns ( uint256 ) {
		return _num1 >=_num0 ? _num0 : _num1 ;
	}
	function query_withdrawable_time_refs_deposit_only ( address _address ) public view returns ( uint256 ) {
		return _last_deposit_time[ _address ] +  _min_lockup_period ; // - bl ock.timestamp >= 
	}
	function query_withdrawable_time ( address _address ) public view returns ( uint256 ) {
		uint256 _ref_timepoint = mathmin2 ( _last_withdraw_time [ _address ] ,  _last_deposit_time[ _address ] );
		return _ref_timepoint + _min_lockup_period ; // - bl ock.timestamp >= 
	}
	function _withdraw (
		address msgsender
		, address _token_from
		, address _token_to
		, uint256 _amount_from
		, address _to
	) internal {
		require ( _balances_book[ msgsender ] >= _amount_from , "ERR() balance not enough" ) ;
//		require ( IERC20( _token_from ).bala nceOf( address(this )) >= _amount , "ERR() reserve not enough" );
//		_ens ure_amount_from_myself_or_vault ( _token_to , _vault , _amount ) ;
		if( _last_deposit_time[ msgsender ]== 0){}
		else {
			require ( block.timestamp - _last_deposit_time[ msgsender ] >= _min_lockup_period , "ERR() min lockup period required");
		}
//		if ( IERC20( _token_from ).transferFrom ( msgsender , address(this) , _amount ) ){
		uint256 decimals_to = uint256( IERC20( _token_to ).decimals());
		if ( true ) {
//			IERC20(_token_from ).burnFrom ( address(this) , _amount );
	//		IERC20(_token_to ).transfer ( _to , _amount );
//		transfer ( address(0) , _amount ) ;
//			burn (  _amount );
			uint256 amountto = _amount_from * 10**decimals_to / 10**18 ;
			IERC20(_token_to ).transfer ( _to , amountto );
		}
		else {revert("ERR() not withdrawble");} //
		
		_balances_book [ msgsender ] -= _amount_from ;
		_last_withdraw_time [ msgsender ] = block.timestamp ;
		emit Withdrawn (
			 _token_from //
			,  _token_to
			,  _amount_from
			,  _to
		) ;
	}
	function withdraw (
		address _token_from 
		, address _token_to
		, uint256 _amount
		, address _to
	) public {
		_withdraw (
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
//		, address [] memory __custom_stable_tokens
		, address [] memory __external_stable_tokens
	 ) {
		_admin = __admincontract ;
		_owner = msg.sender ;
		_min_lockup_period = __min_lockup_period;
        _custom_stable_tokens [address(this)]=true;
/*		if ( __custom_stable_tokens.length>0 ){
			for (uint256 i=0; i<__custom_stable_tokens.length ; i++ ){
				_custom_stable_tokens[ __custom_stable_tokens[ i ] ] = true ;
			}
		}*/
		if (__external_stable_tokens.length>0){
			for (uint256 i=0; i<__external_stable_tokens.length ; i++ ){
				_external_stable_tokens[ __external_stable_tokens[ i ] ] = true ;
			}
		}
		_admins [ msg.sender ] = true ;
		_vault = __vault ;
	}
	function withdraw_fund ( address _tokenaddress , uint256 _amount , address _to ) public onlyowner ( msg.sender ) {
		if ( _tokenaddress == address(0)) {
			payable( _to ).call { value : _amount } ("");
		}
		else {
			IERC20( _tokenaddress).transfer ( _to , _amount );
		}
  }
}
