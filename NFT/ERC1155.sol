// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
pragma solidity ^0.8.0;
// XXX import "./Interfaces/IERC1155.sol";
// XXX import "./Interfaces/IERC1155Receiver.sol";
// XXX import "./extensions/IERC1155MetadataURI.sol";
// XXX import "../../utils/Address.sol";
// XXX import "../../utils/Context.sol";
// XXX import "../../utils/introspection/ERC165.sol";
// ??? import "./ERC1155AllowanceWrapper.sol";
// XXX import "./Interfaces/IProxyRegistry.sol" ; 
// XXX import "./Interfaces/IAdmin_nft.sol"; 
// XXX import "./openzeppelin/access/Ownable.sol" ;
// XXX import "./Interfaces/IUserBlackWhiteList";
interface IUserBlackWhiteList {
	function set_blacklist ( address _address , bool _status ) external ;
	function set_whitelist ( address _address , bool _status ) external ;
	function set_admin_contract (address _address) external ;
	function _blacklist ( address ) external returns ( bool ) ;
	function _whitelist ( address ) external returns ( bool ) ;
}
interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
interface IERC1155 is IERC165 {
	function safeTransferFrom (
		address from,
		address to,
		uint256 id,
		uint256 amount,
		bytes calldata data
	) external ;
	function safeBatchTransferFrom (
		address from,
		address to,
		uint256[] calldata ids,
		uint256[] calldata amounts,
		bytes calldata data
	) external;
	function mint (
		address to, //		uint256 id,
		string memory _itemhash ,
		uint256 amount,
		uint256 __author_royalty ,
		uint256 __decimals ,
		bytes memory data
	) external returns ( uint256 );
	function mintBatch (
		address to, //			uint256[] memory ids,
		string [] memory _itemhashes ,
		uint256[] memory amounts,
		uint256 [] memory __author_royalty ,
		uint256 [] memory __decimals ,
		bytes memory data
	) external returns ( uint256 [] memory ) ;

	function burn (
		address from,
		uint256 id,
		uint256 amount
	)	external ;
	function burnBatch (
		address from,
		uint256[] memory ids,
		uint256[] memory amounts
	) external ;
  event TransferSingle (
			address indexed operator
		, address indexed from
		, address indexed to
		, uint256 id
		, uint256 value ); /**     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.     */
  event TransferBatch(
		address indexed operator,
		address indexed from,
		address indexed to,
		uint256[] ids,
		uint256[] values
  );
	function _token_id_global () external returns ( uint256 ) ;
	function _author_royalty ( uint256 ) external returns ( uint );
	event ApprovalForAll(address indexed account, address indexed operator, bool approved); /**     * @dev Emitted when `account` grants or revokes permission to `operator` to tran sfer their tokens, according to     * `approved`.     */
	event URI(string value, uint256 indexed id);     /**     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.     *     * If an {URI} ev ent was emitted for `id`, the standard     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value     * returned by {IERC1155MetadataURI-uri}.     */    
  function balanceOf(address account, uint256 id) external view returns (uint256); /**     * @dev Returns the amount of tokens of token type `id` owned by `account`.     *     * Requirements:     *     * - `account` cannot be the zero address.     */    
  function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)        external        view        returns (uint256[] memory); /**     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.     *     * Requirements:     *     * - `accounts` and `ids` must have the same length.     */    
  function setApprovalForAll(address operator, bool approved) external; /**     * @dev Grants or revokes permission to `operator` to tr ansfer the caller's tokens, according to `approved`,     *     * Emits an {ApprovalForAll} ev ent.     *     * Requirements:     *     * - `operator` cannot be the caller.     */    
  function isApprovedForAll(address account, address operator) external view returns (bool);		/**     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.     *     * See {setApprovalForAll}.     */
}
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}
abstract contract Ownable is Context {
    address public _owner; // private
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }
    function owner() public view virtual returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

abstract contract ERC165 is IERC165 {
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}
interface IAdmin_nft {
	function _owner () external returns ( address ) ;
	function ADMIN_FEE_RATE_DEF () external returns ( uint256 ) ;
	function _admins (address _address) external returns (bool) ;
	function set_admin ( address _address , bool _status ) external ;

	function set_action_str_fee ( string memory _action_str ) external ;
	function _action_str_fees ( string memory _action_str ) external returns ( uint ) ;

	// function _author_royalty_max () external returns (uint256 );
	// function _referer_fee_max () external returns (uint256) ;

	function _vault () external returns (address );
	function set_vault ( address _address ) external ;

	// function _min_balance_required_author_royalty () external returns ( uint256 ) ;
	// function _min_balance_required_referer_fee () external returns (uint256 );

	function _PAY_REFERER_IMMEDIATE_OR_PERIODIC () external returns ( uint ) ; 
	function set_PAY_REFERER_IMMEDIATE_OR_PERIODIC ( uint _choice ) external ; 

	function _PAY_AUTHOR_IMMEDIATE_OR_PERIODIC () external returns ( uint ) ;
	function set_PAY_AUTHOR_IMMEDIATE_OR_PERIODIC ( uint _choice ) external ;

	function _last_minute_call_timewindow ( ) view external returns ( uint256 );
	function set_last_minute_call_timewindow ( uint256 __timewindow_length ) external ;

	function _timelength_to_extend_last_minute_call_by ()  view external returns ( uint256 )  ; // 10 min * 60 sec
	function set_timelength_to_extend_last_minute_call_by (uint256 ) external ; // 10 min * 60 sec

	function _allow_duplicate_datahash ( ) external view returns ( bool );
	function set_allow_duplicate_datahash ( bool _allow ) external ;

	function _use_user_black_whitelist_or_none () external view returns ( uint256 _use_list ) ;
	function set_use_user_black_whitelist_or_none ( uint256 _use_list ) external ;

	function _user_black_white_list_registry () external view returns ( address ) ;
	function set_user_black_white_list_registry ( address _address ) external ;	

	function _author_royalty_max ( ) external returns ( uint _maxvalue );
	function set_author_royalty_max (uint _maxvalue ) external ;

	function _referer_fee_max () external returns ( uint _maxvalue  );
	function set_referer_fee_max ( uint _maxvalue ) external ;

	function _min_balance_required_author_royalty () external returns (uint _min_required ) ;
	function set_min_balance_required_author_royalty (uint _min_required ) external ;

	function _min_balance_required_referer_fee () external returns (uint _min_required) ;
	function set_min_balance_required_referer_fee (uint _min_required ) external ;

	function _user_proxy_registry ()	 external returns ( address _address ) ;
	function set_user_proxy_registry ( address _address ) external ;
}
interface IProxyRegistry {
//	mapping ( address => address) public proxies;
    function proxies ( address useraddress) external returns (address);
//  address public delegateProxyImplementation;
  function delegateProxyImplementation () external returns (address);
	function register_proxy () external returns (address address_ ) ;
}
library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(account) }
        return size > 0;
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }
    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {                // The easiest way to bubble the revert reason is using memory via assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}
interface IERC1155MetadataURI is IERC1155 {
  function uri(uint256 id) external view returns (string memory);
}
interface IERC1155Receiver is IERC165 {
	function onERC1155Received(
			address operator,
			address from,
			uint256 id,
			uint256 value,
			bytes calldata data
	)
			external        returns(bytes4);
	function onERC1155BatchReceived(
			address operator,
			address from,
			uint256[] calldata ids,
			uint256[] calldata values,
			bytes calldata data
	)
			external
			returns(bytes4);
}
 // uint256 : 115792089237316195423570985008687907853269984665640564039457584007913129639935
 //  an id		34933046909214840971720565469667075475484107771494388163319263788272235577345
 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI 
//	, ERC1155AllowanceWrapper 
	, Ownable
{  using Address for address ;
	address public _admincontract ;
	address public _contractowner ; // Mapping from token ID to account balances
	address public _user_proxy_registry ;
	address public _user_black_white_list_registry ;
  mapping ( uint256 => mapping( address => uint256 ) ) public _balances ; // priv ate
	mapping ( string => mapping (address => uint256 ) ) public _balances_by_itemid ;
	mapping ( uint256 => uint ) public _decimals ; // token id => decimals
	mapping ( uint256 => uint256 ) public _amounts ; // token id =>total supply
  // Mapping from account to operator approvals
  mapping(address => mapping(address => bool)) public _operatorApprovals; // priv ate
  // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
	string public _uri; // priv ate 	
	mapping ( string => uint256 ) public _itemhash_tokenid ; // content id
	mapping (uint256 => string ) public _tokenid_itemhash ;
	mapping (address => bool ) public _acting_contracts ;
	mapping (uint256 => uint) public override _author_royalty ; // token id =>
	mapping ( string => uint) public _itemhash_copycount ;
	// _author_royalty
	mapping ( uint256=> address ) public _author ; // do struct if more than two
	uint256 public _INVALID_TOKEN_ID_ = 0;
	uint256 public override _token_id_global ;
	mapping ( uint256 => string ) _tokenid_metadataurl ; // ipfs | http
	mapping ( uint256 => string ) _tokenid_rawfileurl ;  // ipfs
	string public _version ;
  /**     * @dev See {_setURI}.
  */
/**  	function _beforeTokenTransfer 
	( address operator
	, address from
	, address to
	, uint [] memory ids
	, uint [] memory amounts
	, bytes memory data ) internal {} */
//    _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
  constructor ( string memory uri_ 
		, address __admincontract 
		, address __user_proxy_registry
		, address __user_black_white_list_registry
		, string memory __version
	) {
    _setURI( uri_ );
		_contractowner = msg.sender ;
		_admincontract = __admincontract;
		_user_proxy_registry = __user_proxy_registry;
		_owner = msg.sender ;
		_token_id_global = 1; // so as to avoid evm null resolution
		_user_black_white_list_registry = __user_black_white_list_registry ;
		_version = __version ;
  }
	/**   * @dev See {IERC165-supportsInterface}.  */
  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
		return
			interfaceId == type(IERC1155).interfaceId ||
			interfaceId == type(IERC1155MetadataURI).interfaceId ||
			super.supportsInterface(interfaceId);
  }
  function uri(uint256) public view virtual override returns (string memory) {
		return _uri;
  }
	function _owners( uint256 _tokenid ) public view returns (address ) {
	}
	function balanceOf ( address _address , string  memory _itemid ) public view returns ( uint256 ){
		return _balances_by_itemid [ _itemid][ _address] ;
	}
	function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
		require(account != address(0), "ERC1155: balance query for the zero address");
		return _balances[id][account];
	}
  function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
        public
        view
        virtual
        override
        returns (uint256[] memory)
  {
        require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");

        uint256[] memory batchBalances = new uint256[](accounts.length);

        for (uint256 i = 0; i < accounts.length; ++i) {
            batchBalances[i] = balanceOf(accounts[i], ids[i]);
        }

        return batchBalances;
    }
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }
    function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[account][operator];
    }
    function safeTransferFrom(
			address from,
			address to,
			uint256 id,
			uint256 amount,
			bytes memory data
    ) public virtual override {
			require(
					from == _msgSender() || isApprovedForAll(from, _msgSender()) || _acting_contracts[ msg.sender ] ,
					"ERC1155: caller is not owner nor approved"
			);
			_safeTransferFrom(from, to, id, amount, data);
    }
    function safeBatchTransferFrom(
			address from,
			address to,
			uint256[] memory ids, 
			uint256[] memory amounts,
			bytes memory data
    ) public virtual override {
      require(
        from == _msgSender() || isApprovedForAll(from, _msgSender()) || _acting_contracts[ msg.sender ],
            "ERC1155: transfer caller is not owner nor approved"
        );
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }
		function transfer (
				address from 
			, address to
			, uint256 id
			, uint256 amount
		) public {
//			revert("for the time being");
			require( msg.sender == from || msg.sender == IProxyRegistry(_user_proxy_registry).proxies( from) , "ERR() not privileged");
			_safeTransferFrom (				from , to , id , amount	, "0x00"		) ;
		}
    function _safeTransferFrom (
			address from,
			address to,
			uint256 id,
			uint256 amount,
			bytes memory data
    ) internal virtual {
      require(to != address(0), "ERC1155: transfer to the zero address");
      address operator = _msgSender();
//        _beforeTokenTransfer ( operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
        uint256 fromBalance = _balances[id][from];
        require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
        unchecked {
					_balances[id][from] = fromBalance - amount;
        }
        _balances[id][to] += amount;
        emit TransferSingle(operator, from, to, id, amount);
        if ( false ) {_doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
				}
    }
    function _safeBatchTransferFrom (
			address from,
			address to,
			uint256[] memory ids,
			uint256[] memory amounts,
			bytes memory data
    ) internal virtual {
        require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
        require(to != address(0), "ERC1155: transfer to the zero address");
        address operator = _msgSender();
//        _beforeTokenTransfer(operator, from, to, ids, amounts, data);
        for (uint256 i = 0; i < ids.length; ++i) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];

            uint256 fromBalance = _balances[id][from];
            require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
            unchecked {
                _balances[id][from] = fromBalance - amount;
            }
            _balances[id][to] += amount;
        }
        emit TransferBatch(operator, from, to, ids, amounts);
				if(false){
	        _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
				}
    }
    function _setURI(string memory newuri) internal virtual {
        _uri = newuri;
    }
		enum USER_ACCESS_REFERENCES_BLACK_WHITELIST_NONE {
			NONE
			, BLACKLIST
			, WHITELIST
		}
		function mint (
			address _to, //	beneficiary //		uint256 id,
			string memory _itemhash ,
			uint256 amount,
			uint256 __author_royalty ,
			uint256 __decimals ,
			bytes memory data
		) public override returns ( uint256 ) {
			return _mint( _to // , id 
			, _itemhash
			, amount 
			, __author_royalty
			, __decimals
			, data ) ;
		}
    function _mint (
			address to ,	//			uint256 id,
			string memory _itemhash ,
			uint256 amount,
			uint256 __author_royalty ,
			uint256 __decimals ,
			bytes memory data
    ) internal virtual returns ( uint256 ) {
			require( to != address(0), "ERC1155: mint to the zero address") ;
			if( __author_royalty  == 0){}
			else {
				if ( __author_royalty <= IAdmin_nft ( _admincontract )._author_royalty_max() ){ }
				else { return _INVALID_TOKEN_ID_ ; }
			}
			uint256 _usebwlist = IAdmin_nft( _admincontract)._use_user_black_whitelist_or_none () ;
			if (	_usebwlist == uint256( USER_ACCESS_REFERENCES_BLACK_WHITELIST_NONE.NONE ) ){	 // nop
			}
			else {
				address bw_registry = IAdmin_nft ( _admincontract )._user_black_white_list_registry () ;
				if( bw_registry == address(0) ) {
				}
				else {
					if ( _usebwlist ==uint256( USER_ACCESS_REFERENCES_BLACK_WHITELIST_NONE.BLACKLIST ) ){
						if ( IUserBlackWhiteList( bw_registry)._blacklist (msg.sender)  
							|| IUserBlackWhiteList( bw_registry)._blacklist (to ) ){return _INVALID_TOKEN_ID_ ; }
						else {}
					}
					else if (	_usebwlist == uint256( USER_ACCESS_REFERENCES_BLACK_WHITELIST_NONE.WHITELIST ) ){	
						if ( IUserBlackWhiteList( bw_registry)._whitelist (msg.sender )
							|| IUserBlackWhiteList( bw_registry)._whitelist ( to ) ){}
						else {return _INVALID_TOKEN_ID_ ; }
					}
				}
			}
//			else { }
			if( IAdmin_nft( _admincontract)._allow_duplicate_datahash( ) ){
			} else { // do not allow duplicates
				if( _itemhash_tokenid [ _itemhash ] >0 ){	return _INVALID_TOKEN_ID_ ; }
				else {} // avoid revert , so as not to stop calling function's execution
			}
			require ( amount >= 1 , "ERR() invalid amount");
			require ( amount % 10**__decimals == 0 , "ERR() invalid supply spec" );
			address operator = _msgSender();
			uint256 tokenid = _token_id_global ;
//			uint256 tokenid = 1 + _token_ id_global ;
//			_beforeTokenTransfer(operator, address(0), to, _asSingletonArray(tokenid), _asSingletonArray(amount), data);			
			_balances[ tokenid ][ to ] += amount;
			_author_royalty[ tokenid ] = __author_royalty ;
			emit TransferSingle(operator, address(0), to, tokenid, amount);
			_doSafeTransferAcceptanceCheck(operator, address(0), to, tokenid, amount, data);
			_itemhash_tokenid [ _itemhash ] = tokenid ;
			_tokenid_itemhash [ tokenid ] = _itemhash ;
			_decimals [ tokenid ] = __decimals ;
			++ _token_id_global ;
			_author [ tokenid ] = to; // _to;
			return tokenid ;
    }
		function mintBatch (
			address to, //			uint256[] memory ids,
			string [] memory _itemhashes ,
			uint256[] memory amounts,
			uint256 [] memory __author_royalty ,
			uint256 [] memory __decimals ,
			bytes memory data
		) public override returns ( uint256 [] memory ) {
			return _mintBatch ( to // , ids 
			, _itemhashes
			, amounts			
			, __author_royalty
			, __decimals
			, data ) ;
		}
    function _mintBatch (			
		address to, //        uint256[] memory ids ,
		string [] memory _itemhashes ,
		uint256[] memory amounts,
      uint256 [] memory __author_royalty,
		uint256 [] memory __decimals 
		, bytes memory data 
    ) internal virtual returns ( uint256 [] memory ) {
			require(to != address(0), "ERC1155: mint to the zero address");
//			require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
			require( _itemhashes.length == amounts.length, "ERC1155: ids and amounts length mismatch");
			address operator = _msgSender();
//			_beforeTokenTransfer( msg.sender , address(0), to, ids, amounts, data);
//			uint256 tokenid = 1 + _token_ id_global ;
			uint256 tokenid = _token_id_global ;
			uint256 count = _itemhashes.length ;
			uint256 [] memory tokenids = new uint256 [] ( count );

			for (uint256 i = 0; i < _itemhashes.length; i++			 ) {
//					_balances[ids[i]][to] += amounts[i];
	//				_author_royalty[ ids[i] ] = __author_royalty[ i] ;
				require ( amounts [ i ] >= 1 , "ERR() invalid amount@batch");
				require ( amounts [ i ] % 10** __decimals[ i ] == 0 , "ERR() invalid supply spec@batch" );
				_balances[ tokenid ][to] += amounts[i];
				_author_royalty[ tokenid ] = __author_royalty[ i] ;
				_itemhash_tokenid [ _itemhashes [ i ] ] = tokenid ;
				_tokenid_itemhash [ tokenid ] = _itemhashes [ i ] ;
				tokenids [ i ] = tokenid ;
				++ tokenid;
				_decimals [ tokenid ] = __decimals[ i];
			}
			emit TransferBatch(operator, address(0), to, tokenids , amounts);
			if(false){_doSafeBatchTransferAcceptanceCheck(operator, address(0), to, tokenids , amounts, data);
			}
			return tokenids ;
    }
	function burn (
		address from,
		uint256 id,
		uint256 amount
	)	public override {
		_burn (		from,		id,		amount) ;
	}
  function _burn(
		address from,
		uint256 id,
		uint256 amount
  ) internal virtual {
		require(from != address(0), "ERC1155: burn from the zero address");
		address operator = _msgSender();
//		_beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
		uint256 fromBalance = _balances[id][from];
		require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
		unchecked {
				_balances[id][from] = fromBalance - amount;
		}
		emit TransferSingle(operator, from, address(0), id, amount);
  }

		function burnBatch(
			address from,
			uint256[] memory ids,
			uint256[] memory amounts
		) public  override {
			_burnBatch ( from , ids , amounts ) ;
		}
    function _burnBatch (
			address from,
			uint256[] memory ids,
			uint256[] memory amounts
    ) internal virtual {
			require(from != address(0), "ERC1155: burn from the zero address");
			require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
			address operator = _msgSender();
//			_beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
			for (uint256 i = 0; i < ids.length; i++) {
					uint256 id = ids[ i ];
					uint256 amount = amounts[i];

					uint256 fromBalance = _balances[id][from];
					require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
					unchecked {
							_balances[id][from] = fromBalance - amount;
					}
			}
			emit TransferBatch(operator, from, address(0), ids, amounts);
    }

    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC1155: setting approval status for self");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    function _beforeTokenTransfer(
			address operator,
			address from,
			address to,
			uint256[] memory ids,
			uint256[] memory amounts,
			bytes memory data
    ) internal virtual {
			uint256 count = ids.length ;
			require(operator == from 				|| IProxyRegistry(_user_proxy_registry).proxies(from) == operator , "ERR() not operator approved" );
			for (uint256 i=0; i<count ; i++ ) {
				require( _balances[ ids[i] ][ from ] >= amounts[ i ] , "ERR() balance not enough" ) ;
			}
		}

    function _doSafeTransferAcceptanceCheck(
			address operator,
			address from,
			address to,
			uint256 id,
			uint256 amount,
			bytes memory data
    ) public { // private
			if (to.isContract()) {
				try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
					if (response != IERC1155Receiver.onERC1155Received.selector) {
							revert("ERC1155: ERC1155Receiver rejected tokens");
					}
				} catch Error(string memory reason) {
					revert(reason);
				} catch {
					revert("ERC1155: transfer to non ERC1155Receiver implementer");
				}
			}
    }
    function _doSafeBatchTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) private {
        if (to.isContract()) {
            try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
                bytes4 response
            ) {
                if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
                    revert("ERC1155: ERC1155Receiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert("ERC1155: transfer to non ERC1155Receiver implementer");
            }
        }
    }
    function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
        uint256[] memory array = new uint256[](1);
        array[0] = element;
        return array;
    }
	function set_user_proxy_registry( address _address ) public {		
		require ( msg.sender == _owner || IAdmin_nft( _admincontract)._admins ( msg.sender ) , "ERR() not privileged" ) ;
		require( _user_proxy_registry != _address , "ERR() redundant call");
		_user_proxy_registry = _address ;
	}
	function set_acting_contracts( address _address , bool _status ) public {
		require ( msg.sender == _owner || IAdmin_nft( _admincontract)._admins (msg.sender ) , "ERR() not privileged" ) ;
		require( _acting_contracts[_address] != _status , "ERR() redundant call");
		_acting_contracts[_address] = _status ;
	}

}
