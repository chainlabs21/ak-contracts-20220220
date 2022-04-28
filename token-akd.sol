// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 
pragma solidity ^0.8.0;
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
interface ICalendarLibrary {
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
}
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
    string public _name;
    string public _symbol;
    address public _owner ; 
    mapping (address => bool) public _locked ;
//    mapping (address => uint256) public _timelockstart ;
  //  mapping (address => uint256) public _timelockexpiry ;
    mapping (address => bool) public _admins;
//    address public _calendar_lib ;		
    bool public _paused = false;
    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
//     modifier target_not_owner ()
	// mapping (address => Timelock_taperdown ) public _timelock_taperdown ;
/** 	struct Timelock_taperdown { //		address _address ;
		uint start_unix ;
		uint start_year ;
		uint start_month ;
		uint start_day ;
		uint duration_in_months ;
		uint end_unix ;
		bool active;
		uint256 withdrawn_amount ;
		uint256 remaining_amount ;
		uint256 starting_balance ;
	}
  uint256 public _REQUIRE_MINIMUM_BALANCE_TIMELOCK_TAPERDOWN_ = 1000000000000000000 ;
  function set_REQUIRE_MINIMUM_BALANCE_TIMELOCK_TAPERDOWN_ ( uint256 _amount ) public {
    require(msg.sender == _owner || _admins[msg.sender] , "ERR(58036) not privileged");
    require ( _amount != _REQUIRE_MINIMUM_BALANCE_TIMELOCK_TAPERDOWN_ , "ERR(75818) redundant call" );
    _REQUIRE_MINIMUM_BALANCE_TIMELOCK_TAPERDOWN_ =_amount ;
  } */
/*	function set_timelock_taperdown (address _address 
		, uint _start_year
		, uint _start_month
		, uint _start_day
		, uint _duration_in_months
		, uint _start_unix
		, uint _end_unix
		, bool _active
	) public {
		Timelock_taperdown memory timelock_taperdown = _timelock_taperdown[_address];
//		if( timelock_taperdown.start_unix > 0 ){ }//			_timelock_taperdown[_address] = 
//		 if( timelock_taperdown.active  ){}        
  //      else { 
        uint256 current_balance = _balances[_address ] ;
        if(_active ==false){
          _timelock_taperdown[_address] = Timelock_taperdown (
              0 // _start_unix 
          , 0 // _start_year
          , 0 // _start_month
          , 0 // _start_day
          , 0 // _duration_in_months
          , 0 // _end_unix
          , false // _active 
          , 0
          , 0 // current_balance
          , 0 // current_balance // _balances[_address ]
          );
          return ;
        } else {}
        if( current_balance >= _REQUIRE_MINIMUM_BALANCE_TIMELOCK_TAPERDOWN_ ){}
        else {revert("ERR(84029) min balance requirement not met");}
		_timelock_taperdown[_address] = Timelock_taperdown (
				_start_unix 
				, _start_year
				, _start_month
				, _start_day
				, _duration_in_months
				, _end_unix
				, _active 
				, 0
				, current_balance
				, current_balance // _balances[_address ]
		);
//		}
	} */
/*	 uint _100_PERCENT_BP_ = 10000;
	function query_withdrawable_basispoint ( address _address , uint _querytimepoint ) public view returns (uint ){
//			 getYear(uint timestamp) external returns (uint16);
	//	function getMonth(uint timestamp) external returns (uint8);
		// function getDay(uint timestamp) external returns (uint8);
		Timelock_taperdown memory timelock_taperdown = _timelock_taperdown[_address ] ;
		if(timelock_taperdown.active) {
			if( _querytimepoint >= timelock_taperdown.end_unix)		{return _100_PERCENT_BP_ ; }
			if( _querytimepoint <= timelock_taperdown.start_unix ) {return _100_PERCENT_BP_ ; }
			else {}
//			uint querytimepoint_year = uint ( ICalendarLibrary( _calendar_lib ).getYear ( _querytimepoint ) ); // ???
//			uint querytimepoint_month= uint ( ICalendarLibrary( _calendar_lib ).getMonth( _querytimepoint ) ) ; // ???
//			uint querytimepoint_day	 = uint ( ICalendarLibrary( _calendar_lib ).getDay( _querytimepoint ) ) ;		 // ???
			uint querytimepoint_year = ( ICalendarLibrary( _calendar_lib ).getYear ( _querytimepoint ) ); // ???
			uint querytimepoint_month= ( ICalendarLibrary( _calendar_lib ).getMonth( _querytimepoint ) ) ; // ???
			uint querytimepoint_day	 = ( ICalendarLibrary( _calendar_lib ).getDay( _querytimepoint ) ) ;		 // ???
//			uint256 month_lapse =12 * (querytimepoint_year - (timelock_taperdown.start_year ) )
//				+ (querytimepoint_month) - (timelock_taperdown.start_month)  ; 
			uint256 month_lapse =12 * (querytimepoint_year) 
                + (querytimepoint_month)
                - 12 * (timelock_taperdown.start_year )
			    - (timelock_taperdown.start_month)  ; 
            if( querytimepoint_day >= timelock_taperdown.start_day ){
            }
            else {
                -- month_lapse;
            }
			return (uint) ( month_lapse * _100_PERCENT_BP_ / timelock_taperdown.duration_in_months ) ;
//////// ???
		}
		else {return _100_PERCENT_BP_ ;}
	}
	function query_withdrawable_amount ( address _address , uint _querytimepoint ) public view returns (uint256){
		uint256 balance = _balances[ _address ];
		return balance * query_withdrawable_basispoint(_address , _querytimepoint ) / _100_PERCENT_BP_ ;
	} */
    function set_pause ( bool _status ) public {
            require(msg.sender == _owner || _admins[msg.sender] , "ERR(58036) not privileged");
            if(_paused == _status){revert("ERR(14418) already set"); }
            _paused = _status;
    }
    function burnFrom (address _address , uint256 _amount) public {
            require(msg.sender == _owner || _admins[msg.sender] , "ERR(56220) not privileged");
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
/*	function meets_timelock_terms (address _address) public view returns (bool) {
			uint256 timelockexpiry = _timelockexpiry [ _address ] ;
      uint256 timelockstart = _timelockstart[ _address ];
			if( timelockexpiry >0  ) {
				if( block.timestamp >= timelockexpiry ){return true;}
        if( block.timestamp <  timelockstart )   {return true ;}
				return false;
			} else {return true ;}
	}
    constructor(string memory name_, string memory symbol_ , uint256 _initsupply , 
			address __calendar_lib
		) {
      _name = name_;
      _symbol = symbol_;
			_owner = msg.sender ;
			_totalSupply = _initsupply; 
			_balances [ msg.sender ] =_initsupply;
			_admins[msg.sender ]=true;
			_calendar_lib =__calendar_lib;
    } */
/*		function set_calendar_lib ( address __calendar_lib ) public {
			require (msg.sender == _owner || _admins[msg.sender] , "ERR(39282) not privileged") ;
			_calendar_lib = __calendar_lib ;
		} */
    /**
     * @dev Returns the name of the token.
     */
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
    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) { // override 
        return _symbol;
    }
  function set_symbol(string memory __symbol ) public {
    require(msg.sender == _owner || _admins[msg.sender] , "ERR(61620) not privileged");
    if( compareStrings( __symbol , _symbol ) ){revert("ERR(60965) redundant call");}
    _symbol = __symbol;
  }

    function decimals() public view virtual  returns (uint8) { // override
        return 18;
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
        require(meets_timelock_terms(msg.sender) , "ERR(31930) time locked" );
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

/*    function massTransfer ( address [] memory _receivers , uint256 [] memory _amounts , uint256 _count ) public {
        require( msg.sender == _owner || _admins[msg.sender] , "ERR(73835) not privileged");
        require( _receivers.length >= _count , "ERR(42051) arg length short") ;
        require( _amounts  .length >= _count , "ERR(31239) arg length short") ;
        uint256 sum = 0;
            for (uint i=0; i<_count; i++){
                sum += _amounts[i];				
            }
            if( _balances[msg.sender]>=sum ){}
            else {revert("ERR(40675) balance not enough" );}
            for (uint i=0; i<_count; i++) {
                address receiver = _receivers [ i ] ;
                if(_locked[ receiver ]==false){}
                else {continue; }
                if(meets_timelock_terms( receiver )) {}
                else { continue; }
                Timelock_taperdown memory timelock_taperdown = _timelock_taperdown [ receiver ];
                if ( timelock_taperdown.active == false ){}
                else {continue ; }
                _transfer( msg.sender , receiver , _amounts[ i ]); // _receivers[ i ]
            }
        }*/
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
        require(recipient != address(0), "ERC20: transfer to the zero address");

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

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
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

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
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

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
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

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer (
      address from,
      address to,
      uint256 amount
    ) internal virtual {
      require(_paused==false , "ERR(13448) paused");
      require(_locked[ from ]==false , "ERR(84879) from account locked");
      require(_locked[ to   ]==false , "ERR(59872) to account locked" );
//			require(meets_timelock_terms( from ) , "ERR(72485) time locked(flat schedule)" );
  //    require(meets_timelock_terms( to   ) , "ERR(84212) time locked(flat schedule)" );
//			uint withdrawable_basispoint_from = query_withdrawable_basispoint( from , block.timestamp ); // function query_withdrawable_basispoint ( address _address , uint _querytimepoint ){
	//		if( withdrawable_basispoint_from == _100_PERCENT_BP_ ){}
		//	else {
//				Timelock_taperdown memory timelock_taperdown = _timelock_taperdown[from];
	//			if( amount <=		timelock_taperdown.remaining_amount &&
		//				timelock_taperdown.withdrawn_amount + amount <= withdrawable_basispoint_from * timelock_taperdown.starting_balance / _100_PERCENT_BP_ ){} // _balances[from]
//				else {revert("ERR(37332) amount exceeds timelock allowance" ); }
	//		}

		//	uint withdrawable_basispoint_to_account = query_withdrawable_basispoint ( to , block.timestamp);
			//if ( withdrawable_basispoint_to_account == _100_PERCENT_BP_){}
//			else {
	//			revert("ERR(43141) recipient time locked(taper schedule)");
		//	}
    }

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
/** 			Timelock_taperdown memory timelock_taperdown = _timelock_taperdown[from ] ;
			if(timelock_taperdown.active ){
				if( block.timestamp < timelock_taperdown.start_unix){return ;}
				if( block.timestamp > timelock_taperdown.end_unix		){return ;}
				timelock_taperdown.remaining_amount -= amount ;
				timelock_taperdown.withdrawn_amount += amount ;
				_timelock_taperdown[from ] = timelock_taperdown ;
			}
		}*/
}