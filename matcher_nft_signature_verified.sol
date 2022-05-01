
// pragma solidity ^0.8.0;
// import "./IKIP17.sol" ;
// import "./IAdmin_nft.sol" ;
// import "./IPayroll_fees.sol" ;
// import "./Verify_sig.sol" ;
pragma solidity ^0.5.6 ;
interface IKIP13 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
contract IKIP17 is IKIP13 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    function balanceOf(address owner) public view returns (uint256 balance);
    function ownerOf(uint256 tokenId) public view returns (address owner);
    function safeTransferFrom(address from, address to, uint256 tokenId) public;
    function transferFrom(address from, address to, uint256 tokenId) public;
    function approve(address to, uint256 tokenId) public;
    function getApproved(uint256 tokenId) public view returns (address operator);
    function setApprovalForAll(address operator, bool _approved) public;
    function isApprovedForAll(address owner, address operator) public view returns (bool);
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
}
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
//	function mint ( address , uint) external ;
}
interface ISales {
	struct Mint_data {
		address _target_kip17_contract ; // 0
		address _minter ; // 1
		string _itemid ; // 2 es ;
		uint256 _amount; // 3 s ; // degenerate to =1
		uint256 _decimals ; // 4
		uint256 _author_royalty ; // 5 //		address _to ; // oughta be minter address in case buyer calls
	}
	struct Sale_data {
		address _target_kip17_contract ; // 0
		address _seller ; // 1
		string _itemid ; // 2
		uint256 _amount ; // 3
		uint256 _price ; // 4
		uint256 _starting_time ; // 5
		uint _expiry ; // 6
		address _referer ; // 7
		uint256 _refererfeerate ; // 8
	}
}
// pragma solidity ^0.8.0;
contract IKIP17Receiver {
    function onKIP17Received(address operator, address from, uint256 tokenId, bytes memory data)
    public returns (bytes4);
}
interface IAdmin_nft {
		enum PAY_REFERER_IMMEDIATE_OR_PERIODIC 	{
		__SKIPPER__
		, IMMEDIATE // right upon settlement
		, PERIODIC // monthly or sth periodic
	}
	enum PAY_AUTHOR_IMMEDIATE_OR_PERIODIC 	{
		__SKIPPER__
		, IMMEDIATE // right upon settlement
		, PERIODIC // monthly or sth
	}
	function _payroll_fees_contract () external view returns ( address );
	function set_payroll_fees_contract ( address _address) external ;
	function _owner () external view returns ( address ) ;

	function ADMIN_FEE_RATE_DEF () external view returns ( uint256 ) ;
	function _admins (address _address) external view returns (bool) ;
	function set_admin ( address _address , bool _status ) external ;

//	function set_action_str_fee ( string memory _action_str ) external ;
//	function _action_str_fees ( string memory _action_str ) external view returns ( uint ) ;
	function set_action_str_fee ( string calldata _action_str ) external ;
	function _action_str_fees ( string calldata _action_str ) external view returns ( uint ) ;

//	function _author_royalty_max () external returns (uint256 );
//	function _referer_fee_max () external returns (uint256) ;

	function _vault () external view returns (address );
	function set_vault ( address _address ) external ;

//	function _min_balance_required_author_royalty () external returns ( uint256 ) ;
//	function _min_balance_required_referer_fee () external returns (uint256 );

	function _PAY_REFERER_IMMEDIATE_OR_PERIODIC () external view returns ( uint ) ; 
	function set_PAY_REFERER_IMMEDIATE_OR_PERIODIC ( uint _choice ) external ; 

	function _PAY_AUTHOR_IMMEDIATE_OR_PERIODIC () external view returns ( uint ) ;
	function set_PAY_AUTHOR_IMMEDIATE_OR_PERIODIC ( uint _choice ) external ;

	function _last_minute_call_timewindow ( ) external view  returns ( uint256 );
	function set_last_minute_call_timewindow ( uint256 __timewindow_length ) external ;

	function _timelength_to_extend_last_minute_call_by () external view  returns ( uint256 )  ; // 10 min * 60 sec
	function set_timelength_to_extend_last_minute_call_by (uint256 ) external ; // 10 min * 60 sec

	function _allow_duplicate_datahash ( ) external view returns ( bool );
	function set_allow_duplicate_datahash ( bool _allow ) external ;

	function _use_user_black_whitelist_or_none () external view returns ( uint256 _use_list ) ;
	function set_use_user_black_whitelist_or_none ( uint256 _use_list ) external ;

	function _user_black_white_list_registry () external view returns ( address ) ;
	function set_user_black_white_list_registry ( address _address ) external ;	

	function _author_royalty_max ( ) external view returns ( uint _maxvalue );
	function set_author_royalty_max (uint _maxvalue ) external ;

	function _referer_fee_max () external view  returns ( uint _maxvalue  );
	function set_referer_fee_max ( uint _maxvalue ) external ;

	function _min_balance_required_author_royalty () external view returns (uint _min_required ) ;
	function set_min_balance_required_author_royalty (uint _min_required ) external ;

	function _min_balance_required_referer_fee ( ) external view returns (uint _min_required) ;
	function set_min_balance_required_referer_fee (uint _min_required ) external ;

	function _user_proxy_registry ()	 external view returns ( address _address ) ;
	function set_user_proxy_registry ( address _address ) external ;
}
contract Matcher_single_simple is // Ownable , Utils  ,//	Interface_to_vault	, //	VerifySig	,
	 ISales
	 , IKIP17Receiver
{	
	function _asSingletonArray ( uint256 element ) private pure returns (uint256[] memory) {
		uint256[] memory array = new uint256[](1);
		array[0] = element;
		return array;
	}
	address public _admincontract ;
	address public _user_proxy_registry ;
	address public _target_kip17_contract_def ;
	address public _payroll ;
	address public _owner ; 
  string public _version ;
  function onKIP17Received(address operator, address from, uint256 tokenId, bytes memory data)
    public returns ( bytes4 ) {
	   return this.onKIP17Received.selector;
  }
	constructor (
			address __admincontract
//		, address __user_proxy_registry
//		, address __target_kip17_contract_def
    , string memory __version
	) public {
		_admincontract = __admincontract ;
//		_user_proxy_registry = __user_proxy_registry ;
//		_target_kip17_contract_def = __target_kip17_contract_def ;
		_owner = msg.sender ;
        _version = __version ;
	}
//	uint256 public _flowsel = 1 ;
	function match_single_simple_legacy (
			address _target_kip17_contract // 0
/** 		, string memory _itemid //1 //		, uint256 _tokenid // 2 ignored for now
		, uint256 _amounttomint // 2 */
    , uint256 _author_royalty_rate // 3 //        , uint256 _decimals // 5  //		, address _paymeans // 6
		, address _author // 4
		, uint256 tokenid // 10
//		, uint256 _amounttobuy // 5
		, address _paymeansaddress
		, uint256 _amounttopay // 5 //		, uint256 _pr ice // 7
		, address _seller // 7 
		, address _to // 8 
		, uint256 _flowsel 
		, bytes memory _sell_signature
		, bytes32 _message
//		, address _referer // 9
	) public payable {
		require( _to != address(0) , "ERR() invalid beneficiary" );
		require( _seller != address(0) , "ERR() invalid seller" );
		//***** recovering the seller's address
		require(recoverSigner(_message, _sell_signature) == _seller, "Sender is not the owner!");
		/******* settlement */
		if ( IERC20( _paymeansaddress ).transferFrom ( msg.sender , address(this) , _amounttopay )){}
		else {revert("ERR() balance not enough"); }
		uint256 remaining_amount = _amounttopay ; // order_buy.asset_amount_bid[0] ;
		/****  admin */
		uint256 admin_fee_rate = 0; // IAdmin_nft( _admincontract )._action_str_fees( "MATCH" ) ;
		uint256 admin_fee_amount = remaining_amount * admin_fee_rate / 10000 ;
		address vault_contract = address(0) ; // IAdmin_nft( _admincontract )._vault() ;
/**		if (admin_fee_amount>0) {
			if ( vault_contract == address(0) ){ } // revert("ERR() vault address invalid"); }
			else { // payable( vault_contract ).ca ll { value : admin_fee_amount } ( "" ) ; 
			IERC20( _paymeansaddress ).transfer ( vault_contract , admin_fee_amount ) ;
				emit DepositToVault(
					address(this)
					, admin_fee_amount
					, uint256(SEND_TYPES.ADMIN_FEE_SPOT) 
					, vault_contract
				); 
				remaining_amount -= admin_fee_amount ;
			}
		} else {} */ 			/**** referer */
			/***** royalty */			
			if ( _author_royalty_rate > 0 ) {
				if (_author == address(0) ){}
				else {
					uint256 author_royalty_amount = _amounttopay * _author_royalty_rate / 10000 ;
					if ( true  ){ // 						//payable( _author ).ca ll { value : author_royalty_amount } ( "" ) ;
						IERC20( _paymeansaddress ).transfer ( _author , author_royalty_amount ) ;
/*						emit PaidFee (
							address(this)
							, author_royalty_amount
							, uint256(SEND_TYPES.AUTHOR_ROYALTY_DEPOSIT) 
							, _author
						);*/
					}
					remaining_amount -= author_royalty_amount ;
				}
			}
			else {}

			 		
			/***** remaining of sales proceeds */
		//payable ( _seller ).ca ll { value : remaining_amount } ("") ;
		IERC20( _paymeansaddress ).transfer ( _seller , remaining_amount ) ;

		if ( _flowsel==1){
			IKIP17( _target_kip17_contract ).safeTransferFrom ( // Batch
			  _seller
      		, _to
			, tokenid
//      , _amounttobuy
    	  	, "0x00"
			) ;
		}
		if(_flowsel==2){		IKIP17( _target_kip17_contract ).safeTransferFrom ( // Batch
			  _seller
    	  	, address( this )
			, tokenid
//      , _amounttobuy
	      	, "0x00"
		) ;
		/*******  */
		IKIP17( _target_kip17_contract ).safeTransferFrom ( // Batch
		  address ( this )
    	  	, _to
			, tokenid
//      , _amounttobuy
      		, "0x00"
		) ;
		}
	}
	function prefixed (bytes32 hash) public pure returns (bytes32) {
		return keccak256(abi.encodePacked("\x19Klaytn Signed Message:\n32", hash));
	}

	function splitSignature (bytes memory _sig) public pure returns (uint8, bytes32, bytes32) {
		require(_sig.length == 65);

		bytes32 r;
		bytes32 s;
		uint8 v;

		assembly {
			// first 32 bytes, after the length prefix
			r := mload(add(_sig, 32))
			// second 32 bytes
			s := mload(add(_sig, 64))
			// final byte (first byte of the next 32 bytes)
			v := byte(0, mload(add(_sig, 96)))
		}
		return (v, r, s);
	}

	

	function recoverSigner (bytes32 message, bytes memory _sig) public pure returns (address) {
		uint8 v;
		bytes32 r;
		bytes32 s;
		bytes32 dehashed_message;

		(dehashed_message) = prefixed(message);

		(v, r, s) = splitSignature(_sig);

		return ecrecover(dehashed_message, v, r, s);
	}

	

	function only_owner_or_admin (address _address ) public returns ( bool )  {
		if ( _address == _owner || IAdmin_nft( _admincontract )._admins( _address ) ){return true ; }
		else {return false; } 
	}
}
/*	function verify_mint_data ( Mint_data memory _mintdata 
		, string memory _signature
	) public returns ( bool ) {
		address signer = _mintdata._minter ;
		bytes32 hashed = keccak256 ( abi.encodePacked ( _mintdata ));
		return true ;
		//address signer_recovered = recoverSigner ( hashed , _signature ) ;
		//return signer == signer_recovered ;
	} */
/*	function verify_sale_data ( Sale_data memory _saledata 
		, string memory _signature
	) public returns ( bool ) {
		address signer = _saledata._minter ;
		bytes32 hashed = keccak256 ( abi.encodePacked ( _saledata ));
		return true ;
//		address signer_recovered = recoverSigner ( hashed , _signature ) ;
//		return signer == signer_recovered ;
	}*/
/*	function mint_and_match_single_simple (
			address _target_kip17_contract // 0
		, Mint_data memory mintdata
		, Sale_data memory saledata
		, string memory signaturemint
		, string memory signaturesale
	) public payable { 
		if ( verify_mint_data ( mintdata , signaturemint ) ){}
		else { revert("ERR() invalid mint signature" ); }
		if ( verify_sale_data ( saledata , signaturesale ) ){}
		else {revert("ERR() invalid sale signature"); }
		mint_and_match_single_simple_legacy (
			mintdata._target_kip17_contract //0
			, mintdata._itemid //1
			, mintdata._amount // 2
			, mintdata._author_royalty // 3
			, saledata._amount // 4
			, saledata._price // 5
			, mintdata._minter // 6
			, saledata._seller // 7
			, msg.sender // 8
			, saledata._referer // 9
		)	;
	} */