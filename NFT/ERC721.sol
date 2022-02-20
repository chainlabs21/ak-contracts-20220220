
pragma solidity>=0.8.0;
// import "../ERC721/ERC721.sol";
// import "../../utils/Counters.sol";
// import "../ERC20/IERC20.sol";
// import "./IAdmin configs.sol";
// import "../../access/Ow nable.sol";
// /Users/janglee/workscontracts/erc721-hardhat-20210619/contracts/token/ERC721custom/storage.sol
// /Users/janglee/workscontracts/erc721-hardhat-20210619/contracts/token/ERC721/ERC721.sol
/** 1)고정가격 수수료로 혹은 상품가격 비례로 하실지 : 상품가격 비례 %로
	2)수수료결제: BNB 혹은 BEP20 토큰으로 하실지 : 수수료 결제는 결제되는 것과 같은 토큰으로 부탁드립니다.
	구매자 본인이 취소 할수 있게 해주시면 될 것 같습니다.
*/
// SPDX-License-Identifier: MIT
//import "./IERC721.sol";
// import "./IERC721Receiver.sol";
// import "./extensions/IERC721Metadata.sol";
// import "../../utils/Address.sol";
// import "../../utils/Context.sol";
// import "../../utils/Strings.sol";
// import "../../utils/introspection/ERC165.sol";
// SP DX-License-Identifier: MIT

// SP DX-License-Identifier: MIT
// pragma solidity ^0.8.0;
// SP DX-License-Identifier: MIT

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721Receiver {
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
}

library Counters {
	struct Counter {
			uint256 _value; // =0; // 1 ; // default: 0
	}
	function current(Counter storage counter) internal view returns (uint256) {
			return counter._value;
	}
	function increment(Counter storage counter) internal {
			unchecked {
					counter._value += 1;
			}
	}
	function incrementwithreturnvalue (Counter storage counter) internal returns (uint256) {
			unchecked {
					counter._value += 1;
					return counter._value;
			}
	}
	function decrement(Counter storage counter) internal {
			uint256 value = counter._value;
			require(value > 0, "Counter: decrement overflow");
			unchecked {
					counter._value = value - 1;
			}
	}
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
        } else {
            if (returndata.length > 0) {
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

interface IAdminconfigs { //	function getmindeltabid() returns (uint256) ; //	function getpaymeansstatus (address _paymeans 	)			external view returns (uint);
	function isadmin( address ) external view returns (uint );
	function get_admin_fee (string memory _action ) external view returns (uint ) ;
	function is_originatorfee_in_validrange(uint _queryvalue) external returns (bool); //	function getpaymeansstatus (address _paymeans 	)		external view returns (uint);
	function getminsalesprice(address _paymeans) external view returns (uint256 ) ;
	function _map_action_int_adminfee_inbp(uint) external view returns (uint);
	function query_admin_fee (string memory _action ) external view returns (uint ) ;
	function getpaymeansstatus (address _paymeans 	)		external view returns (uint);
	function _feecollector () external view returns (address)	;
	function _originator_feeinbp_range (uint _index) external view returns (uint);
	function query_admin_fees ()        external view returns 	(string [] memory , uint[] memory  ) ; // OOO
	function set_admin_fee (string memory _action , uint _feeinbp) external  ;
	function setadminaddressstatus ( address _address , uint _status ) external ;
	function disable_fees () external ;
}

library Strings {
    bytes16 private constant alphabet = "0123456789abcdef";
    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = alphabet[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
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
abstract contract ERC165  { // is IERC165
    function supportsInterface(bytes4 interfaceId) public view virtual  returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}
// SP DX-License-Identifier: MIT
interface IERC721 { // is ERC165 
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
    function setApprovalForAll(address operator, bool _approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}

contract ERC721 is Context
	, ERC165
	, IERC721
//	, IERC721Metadata 
	{
    using Address for address;
    using Strings for uint256;
    string private _name;
    string private _symbol;
    string public _version;

    mapping (uint256 => address) public _owners;
    mapping (address => uint256) private _balances;
    mapping (uint256 => address) private _tokenApprovals;
    mapping (address => mapping (address => bool)) private _operatorApprovals;
    constructor (string memory name_
        , string memory symbol_
//        , string memory version__
        ) {
        _name = name_;
        _symbol = symbol_;
  //      _version = version__;
    }
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165) returns (bool) { // , IERC165
        return interfaceId == type(IERC721).interfaceId
//            || interfaceId == type(IERC721Metadata).interfaceId
            || super.supportsInterface(interfaceId);
    }
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }
    function ownerOfreturnspayable(uint256 tokenId) public view virtual  returns (address payable ) {
        address payable owner =  payable (_owners[tokenId]);
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }
    function name() public view virtual returns (string memory) { // override 
        return _name;
    }
    function symbol() public view virtual returns (string memory) { // override 
        return _symbol;
    }
    function tokenURI(uint256 tokenId) public view virtual returns (string memory) { // override 
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0
            ? string(abi.encodePacked(baseURI, tokenId.toString()))
            : '';
    }
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");
        require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );
        _approve(to, tokenId);
    }
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");
        return _tokenApprovals[tokenId];
    }
    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(operator != _msgSender(), "ERC721: approve to caller");
        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }
    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        //solhint-disable-next-line max-line-length
//        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _transfer(from, to, tokenId);
    }
    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
//        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }
    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }
    function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
        _mint(to, tokenId);
        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");
        _beforeTokenTransfer(address(0), to, tokenId);
				increment_tokencount_assign
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(address(0), to, tokenId);
    }
    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);
        _beforeTokenTransfer(owner, address(0), tokenId);
        _approve(address(0), tokenId);
        _balances[owner] -= 1;
        delete _owners[tokenId];
        emit Transfer(owner, address(0), tokenId);
    }
    function _transfer(address from, address to, uint256 tokenId) internal virtual {
//        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");
        _beforeTokenTransfer(from, to, tokenId);
        // Clear approvals from the previous owner
        _approve(address(0), tokenId);
        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
        private returns (bool)
    {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver(to).onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    // solhint-disable-next-line no-inline-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
		function setowner(address _to , uint256 _tokenid ) internal {			
			_owners[_tokenid ]=_to ;
//			_balances[_to] +=1;
		}
}
	
contract ERC721storage is ERC721 
// , Owna ble 
{
	using Counters for Counters.Counter;
	Counters.Counter public _tokenIdTracker ;
	string public _name;
	string public _symbol;
	string public _defaulturi;
	// address public _owner;	
    address public _owner ;
	uint256 public constant _100_ = 100;
	uint256 public constant _10000_ = 10000;
	address public _feecollector ;
	// [] constants
	string constant MSG_FEE_NOT_MET="fee not met"; 
	string constant MSG_PRICE_NOT_MET="price not met";
	string constant MSG_BID_EXISTS="bid exists";
	string constant MSG_NO_BID_EXISTS="no bid exists";
	string constant MSG_SAME_CONTENT_EXISTS="already same contents exists";
	string constant MSG_INVALID_PERCENT_ARGUMENT="invalid percent argument";
	string constant MSG_CALLER_INVALID = "caller invalid" ;
	string constant MSG_REQ_INVALID="req invalid";
	string constant MSG_NOT_ONSALE="not on sale or expired";
	string constant MSG_BEFORE_EXPIRY="not expired";
	string constant MSG_DATA_NOT_FOUND="data not found";
	string constant MSG_NO_PRIVILEGE="NO PRIVILEGE";
	string constant MSG_NOT_CANCELLABLE="not cancellable";
	string constant MSG_FORWARD_TIME_ONLY="forward time only";
	uint public mintneedsadminapproval ;
	string public _versionnumber;
	// [] satellite/friend contracts
	address public _address_adminconfigscontract ;
	// [] product info// [] item/content
	mapping ( uint256 => string) public _maptokenidtometadataurl ;
	mapping ( uint256 => string) public _maptokenidtorawfileurl;
	mapping ( uint256 => string    ) public _maptokenidtohash;
	mapping ( string => uint256    ) public _maphashtotokenid; //	uint256 public _minprice ;
	// [] sales
	mapping(uint256 => bool    ) public _maptokenidtoisonsale;
	mapping(uint256 => uint256 ) public _maptokenidtoofferprice;
	mapping(uint256 => uint256 ) public _maptokenidtoexpiry ;
	mapping(uint256 => address ) public _maptokenidtopaymeansaddress ;
	mapping(uint256 => uint) public _maptokenidtosaletype ; // uint
	// [] ownerships
	mapping (address => uint) public _mapaddresstoisadmin ;
//	mapping (uint256 => address) public _ow ners;
	mapping (address => uint256) public _balances;
	mapping (uint256 => address) public _tokenApprovals;
	mapping (address => mapping (address => bool)) public _operatorApprovals;
	mapping (uint256 => address  ) public _maptokenidtooriginator ;	
	mapping (uint256 => uint256 ) public _maptokenidtooriginatorfeeinbp ;
	// []admin
	mapping(uint => uint) public _mapactiontypetofeeschedule ;
	mapping(uint => uint) public _mapactiontypetofeeinbasispoint ;
	mapping(uint => uint256) public _mapactiontypetofixedfee ;
	/******* multicopy */
	mapping (uint256 => uint) public _maptokenidtoclass ; //	funct ion settokenidclass (uint256 _tokenid , uint256 _classnumber ) public returns (uint256){		_maptokenidtoclass [_tokenid] = _classnumber;	}
	mapping (uint => uint256[]) public _mapclasstoarrtokenids; 
	mapping (uint256 => uint) public _maptokenidtoserialnumber;	// serial number uniquely identifies token id in its class
	// [] bid and approve type of sale, 
	mapping(uint256 => uint ) public _maptokenidtobidcount ;
	mapping(uint256 => uint256) public _maptokenidtobidtime ;
	// [] auction
	mapping(uint256 => uint256) public _maptokenidtotopbidamount ;
	mapping(uint256 => address) public _maptokenidtotopbidaddress;
	mapping(uint256 => uint256) public _maptokenidtoownerserial ;
	// [] split,shared ownership
	mapping(uint256 => uint256 ) public _maptokenidtocountshares;
	mapping(uint256 => address ) public _maptokenidtosharescontract; 
	enum ADMIN_FEE_SCHEDULE_FIXED_OR_PRORATA {
			NONE // 0
		, FIXED // 1
		, PRORATA // 2
	}
	enum USER_ACTION_TYPES {
		 MINT_SINGLE // 1-0 // 0
		, PUT_ONSALE // 1-1 // 1

		, EDIT_SALE_TERMS // 1-2 // 2
		, SET_SALE_STATUS // 8 // 3
		, SET_SALE_TERMS // 8 // 4
		, SET_SALE_EXPIRY // 9 // 5
		, CHANGE_PRICE // 6 // 6
		, APPROVE_BUY_REQUEST // 1-3 // 7
		, CANCEL_SALE // 1-4 // 8

		, PUT_BID // 2-0 // 9
		, CANCEL_BID // 2-1 // 10

		,	MINTSHARES // 0
		, MINTWHOLE // 1
		, BUYWHOLE // 3
		, BUY_WHOLE_SPOT // 
		, BUY_WHOLE_AUCTION //
		, BUYSHARES // 2
		, MINT_MULTI_COPIES // 7 //		, SELLSHARES // 4 //		, SELLWHOLE // 5
	}
	enum SALETYPES {
		NOT_ON_SALE // 0
		, BID_AND_APPROVE // 3
		, TAKE_OWNERSHIP // 1 // 1==2
		, BID_TO_TAKE // 2
		, AUCTION // 5, which has expiry, starting offer price		// price unbound
		, SPLIT_SHARES // 4 // price bound
	} //	function isadmin (address _address) public returns (uint ) {		return _mapaddresstoisadmin[_address];	} //	function setadmin (address _address, uint _status) public onlyowner(msg.sender){		_mapaddresstoisadmin[_address]=_status ;	}

	function mint( address to, uint256 tokenId ) public {		
	 _mint( to, tokenId );
	}
	function burn (uint256 tokenId) public {
		 _burn( tokenId ) ;
	}
	function setfeecollector(address _address) public onlycontractowner(msg.sender) {
		_feecollector=_address; //		em it
	}
	modifier onlytokenowner ( uint256 _tokenid ) {
		require(			msg.sender == ownerOf(_tokenid),			MSG_NO_PRIVILEGE ); // 		require(			msg.sender == ERC721storage(_storageaddress)._owners[_tokenid],			"Only token owner"		);
		_;
  }
	modifier onlyowneroradmin ( uint256 _tokenid , address _sender ){
		require( _sender == ownerOf(_tokenid) 
			|| IAdminconfigs(_address_adminconfigscontract).isadmin( _sender)==1 );
		_;
	}
	modifier onlyforwardtime (uint256 _expiry){		require(block.timestamp < _expiry , "forward time only");
		_;
	}
	modifier istimenowbeforeexpiry (uint256 _expiry){
		require(block.timestamp < _expiry, "sale expired");
		_;
	}
	modifier isitemonsale (uint256 _tokenid) {
		require( _maptokenidtoisonsale[_tokenid]==true , MSG_NOT_ONSALE ); // "not on sale"
		_;
	}
	modifier onlyadmin (address _address )  { // public
//		require(			_mapaddresstoisadmin[_address]==1 ,			"Only admin"		); // 		require(			msg.sender == ERC721storage(_storageaddress)._owners[_tokenid],			"Only token owner"		);
		require( IAdminconfigs(_address_adminconfigscontract).isadmin(_address)==1, MSG_NO_PRIVILEGE );
		_;
  }
	modifier onlycontractowner (address _address){
		require (_address==_owner , "only owner");
		_;
	}
	mapping (address => bool) _accessors ;
	modifier onlyaccessors (address _address ) {
		require(			_accessors[ _address ],			MSG_NO_PRIVILEGE ); // 		require(			msg.sender == ERC721storage(_storageaddress)._owners[_tokenid],			"Only token owner"		);
		_;
  }
	function setaccessorstate (address _address , bool _state ) public {
		_accessors[_address]=_state ;
	}
	function get_current_tokenid_counter () public view returns (uint){
		return _tokenIdTracker.current();
	}
	function increment_tokenid () public onlyaccessors(msg.sender ) {
		_tokenIdTracker.increment();
	}
/***** *******/
	function increment_tokencount_assign () public  returns ( uint256 ) { // onlyaccessors (msg.sender)
		_tokenIdTracker.increment();
		return _tokenIdTracker.current();
//		_tokencount =1 + _tokencount;
	//	return _tokencount;
	}
// [] item/content
function set_maptokenidtometadataurl ( uint256 _tokenid , string memory _metadataurl) public onlyaccessors(msg.sender){
	_maptokenidtometadataurl[ _tokenid]= _metadataurl ;
}
function set_maptokenidtorawfileurl ( uint256 _tokenid , string memory _rawfileurl ) public onlyaccessors(msg.sender) {
	_maptokenidtorawfileurl[_tokenid] = _rawfileurl ;
}
function set_maptokenidtohash ( uint256 _tokenid , string memory _hash ) public onlyaccessors( msg.sender) {
	_maptokenidtohash [ _tokenid] = _hash ;
}
function set_maphashtotokenid ( string memory _hash , uint256 _tokenid ) public onlyaccessors( msg.sender) {
	_maphashtotokenid [ _hash]=_tokenid ;
}
// [] sales
function set_maptokenidtoisonsale ( uint256 _tokenid , bool _isonsale) public onlyaccessors (msg.sender) {
	_maptokenidtoisonsale[_tokenid]=_isonsale;
}
function set_maptokenidtoofferprice( uint256 _tokenid , uint256 _offerprice) public onlyaccessors(msg.sender) {
	_maptokenidtoofferprice [_tokenid]=_offerprice ;
}
function set_maptokenidtoexpiry ( uint256 _tokenid , uint256 _expiry) public onlyaccessors (msg.sender) {
	_maptokenidtoexpiry [_tokenid] = _expiry ;
}
function set_maptokenidtopaymeansaddress ( uint256 _tokenid , address _paymeans ) public onlyaccessors (msg.sender) {
	_maptokenidtopaymeansaddress [_tokenid] = _paymeans ;
}
function set_maptokenidtosaletype ( uint256 _tokenid , uint _saletype) public onlyaccessors (msg.sender) {
	_maptokenidtosaletype [_tokenid] = _saletype ;
}
// [] owners
function set_owners ( uint256 _tokenid , address _address) public onlyaccessors (msg.sender) {
//	_owne rs[_tokenid] = _address ;
}
function increment_balance (address _address) public onlyaccessors (msg.sender) {
	_balances[_address] = 1 + _balances[_address];
}
function set_balances ( address _address , uint256 _balance ) public onlyaccessors (msg.sender) {
	_balances[_address] = _balance ;
}
function set_maptokenidtooriginator(uint256 _tokenid , address _originator) public onlyaccessors (msg.sender) {
	_maptokenidtooriginator[_tokenid] = _originator ;
}
function set_maptokenidtooriginatorfeeinbp ( uint256 _tokenid , uint256 _originatorfeeinbp ) public onlyaccessors (msg.sender){
	_maptokenidtooriginatorfeeinbp [_tokenid] = _originatorfeeinbp ;
}
// [] bid and approve
function set_maptokenidtobidcount ( uint256 _tokenid , uint _bidcount ) public onlyaccessors(msg.sender) {
	_maptokenidtobidcount [_tokenid] = _bidcount ;
}
function set_maptokenidtobidtime ( uint256 _tokenid , uint256 _bidtime ) public onlyaccessors (msg.sender) {
	_maptokenidtobidtime [_tokenid] = _bidtime;
}
// [] auction
function set_maptokenidtotopbidamount (uint256 _tokenid , uint256 _topbidamount) public onlyaccessors (msg.sender) {
	_maptokenidtotopbidamount [_tokenid] = _topbidamount ;
}
function set_maptokenidtotopbidaddress ( uint256 _tokenid , address _address) public onlyaccessors (msg.sender) {
	_maptokenidtotopbidaddress [_tokenid] = _address;
}
function set_maptokenidtoownerserial (uint256 _tokenid , uint256 _serial) public onlyaccessors (msg.sender) {
	_maptokenidtoownerserial [_tokenid] = _serial ;
}
/************ */
	function getiteminfo (uint256 _tokenid) public view returns (
		bool onsalestatus, // uint
		uint256 saleexpiry,
		uint256 offerprice,
		address originator,
		uint256 originatorfee,
		string memory hash_,
		uint classnumber,
		uint256 copycount,
		address currentowner ,
		string memory metadataurl ,
		string memory rawfileurl	 ) {
		onsalestatus=_maptokenidtoisonsale[_tokenid] ;
		saleexpiry = _maptokenidtoexpiry[_tokenid] ;
		offerprice = _maptokenidtoofferprice[_tokenid];
		originator = _maptokenidtooriginator[_tokenid];
		originatorfee = _maptokenidtooriginatorfeeinbp[_tokenid];
		hash_ = _maptokenidtohash [_tokenid];
		classnumber = _maptokenidtoclass [_tokenid]; //		uint256 copycount= [_tokenid];
		currentowner = ownerOf(_tokenid);
		metadataurl = _maptokenidtometadataurl[_tokenid];
		rawfileurl = _maptokenidtorawfileurl[_tokenid];
}
	function getbidinfo (uint256 _tokenid) public view returns (
		uint bidcount_, //		uint256 ,
		uint256 bidamount_,
		address topbidder_	){
		uint bidcount_ = _maptokenidtobidcount[_tokenid ] ; //		_maptokenidtobidtime ;
		uint256 bidamount_ = _maptokenidtotopbidamount[_tokenid] ;
		address topbidder_ = _maptokenidtotopbidaddress[_tokenid];
	}
/** 	function transferOwnership(address newOwner) public virtual override onlyOwner {
//		super( newOwner);
        require(newOwner != address(0), "Own able: new owner is the zero address");
        em it OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
		_feecollector = newOwner;
	}*/
	function set_admin_configs_contract_address (address _address) public onlyadmin(msg.sender) {
		require(_address != address(0) , MSG_REQ_INVALID);
		_address_adminconfigscontract = _address ;
	}
	/******* constructor */
	constructor (string memory __name,string memory __symbol, string memory __defaulturi
		, string memory __versionnumber
		, address _adminconfigscontractaddress_input
	)	ERC721( __name , __symbol )
	{		_defaulturi=__defaulturi;
		_owner = msg.sender;
		// _minprice=1000000000000000; // ==0.001 ETH
		_mapaddresstoisadmin[msg.sender]=1; //		super(__name , __symbol) ;
/** 		for (uint i=0;i<8;i++){	
			_mapactiontypetofeeinbasispoint[i] = 100; // ADMIN_FEEPRORATA_DEF_INBASIS ;
			_mapactiontypetofeeschedule[i] = uint(ADMIN_FEE_SCHEDULE_FIXED_OR_PRORATA.PRORATA)  ;
			_mapactiontypetofixedfee[i] = 1000000000; // ADMIN_FIXEDFEE_DEF_INWEI ;
		}*/
		_address_adminconfigscontract = _adminconfigscontractaddress_input;
		_feecollector = msg.sender ;
		_versionnumber=__versionnumber;
		_tokenIdTracker.increment();
	}
/************ */
	function getrandomnumber () private view returns (uint) { // sha3 and now have been deprecated
		return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp )));		// convert hash to integer		// players is an array of entrants
  }
}
