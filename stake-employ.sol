
// pragma solidity>=0.8.0;
pragma solidity>=0.5.6;
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
interface IKIP13 {
  function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
contract KIP13 is IKIP13 {
    bytes4 private constant _INTERFACE_ID_KIP13 = 0x01ffc9a7;
    mapping(bytes4 => bool) private _supportedInterfaces;
    constructor () internal {
        _registerInterface(_INTERFACE_ID_KIP13);
    }
    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return _supportedInterfaces[interfaceId];
    }
    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff, "KIP13: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}
contract IKIP17 is IKIP13  { // 
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
contract IKIP17Receiver {
    function onKIP17Received(address operator, address from, uint256 tokenId, bytes memory data)
    public returns (bytes4);
}

contract StakeEmploy is KIP13 { // , IKIP17Receiver 
	address public _owner;
  bytes4 private constant _KIP17_RECEIVED = 0x6745782b;
  bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
	constructor ( address __reward_token ) public {
		_owner = msg.sender ;
    _reward_token = __reward_token ;
		_registerInterface( _KIP17_RECEIVED ); // _INTERFACE_ID_ERC721
		_registerInterface( _ERC721_RECEIVED );
	}
	mapping ( address => uint256 ) public _balancesums ;
	mapping ( address => mapping ( uint256  => uint256 ) ) public _balances ;
	address public _reward_token ;
	uint256 public _reward_amount = 1 * 10**18 ;
	event Deposit (
		address _erc721, uint256 _tokenid 
	) ;
  function set_reward_token ( address _address ) public {
        require ( msg.sender == _owner , "ERR() not privileged") ;
        _reward_token = _address ;
    }
	function deposit ( address _erc721, uint256 _tokenid ) public {
		IKIP17 ( _erc721).safeTransferFrom ( msg.sender , address(this) , _tokenid) ;		
		_balancesums [ msg.sender ] += 1; 
		_balances [msg.sender][ _tokenid] = 1;
        IKIP17 ( _erc721 ).approve (msg.sender , _tokenid ) ;
        if ( IERC20( _reward_token ).balanceOf(address(this)) >= _reward_amount ) {
            IERC20 (_reward_token).transfer ( msg.sender , _reward_amount ) ;
        } 
        else {}
		emit Deposit ( _erc721 , _tokenid );
	}
	function deposit_batch ( address _erc721 , uint256 [] memory _tokenids ) public {
		uint256 N= _tokenids.length;
		for (uint256 i=0; i< N ; i++){
            uint256 tokenid = _tokenids[ i ] ;
			IKIP17 (_erc721).safeTransferFrom ( msg.sender , address ( this), tokenid ) ;
			_balances [msg.sender][ tokenid ] = 1;
            IKIP17 ( _erc721 ).approve ( msg.sender , tokenid ) ;
		}
        if ( IERC20( _reward_token ).balanceOf(address(this)) >=_tokenids.length * _reward_amount ) {
            IERC20 (_reward_token).transfer ( msg.sender , _tokenids.length *  _reward_amount ) ;
        }
		_balancesums [ msg.sender ] += N ;
		emit Deposit ( _erc721 , _tokenids[ 0 ] );
	}
	event Withdraw (
		address _erc721 , uint256 _tokenid 
	) ;
	function withdraw ( address _erc721 , uint256 _tokenid , address _to ) public {
		if ( _balances [msg.sender ][ _tokenid ] > 0 ){}
		else {revert("ERR() balance not enough");}
//		IKIP17 ( _erc721 ).transfer ( _to , _tokenid ) ;
		emit Withdraw ( _erc721 , _tokenid ) ;
	}
	function withdraw_batch ( address _erc721 , uint256 [] memory _tokenids , address _to ) public {
		uint256 N = _tokenids.length ;
		for ( uint256 i = 0 ; i<N;i++){
//			IKIP17( _erc721 ).transfer ( _to , _tokenids[ i ]) ;
		}
		emit Withdraw ( _erc721 , _tokenids[ 0 ] ) ;
	}
    function mybalance ( address _token ) public view returns ( uint256 ){ 
        return IERC20( _token ).balanceOf ( address ( this ) );
    }
    function withdraw_fund ( address _token , address _to , uint256 _amount ) public {
        require (msg.sender == _owner , "ERR() not privileged") ;
        IERC20( _token ).transfer ( _to , _amount );
    }
}