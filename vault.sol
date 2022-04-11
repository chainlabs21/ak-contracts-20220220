
pragma solidity>=0.8.0;
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
pragma solidity ^0.5.0;

import "../../introspection/IKIP13.sol";

/**
 * @dev Required interface of an KIP17 compliant contract.
 */
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
contract IKIP17Receiver {
    function onKIP17Received(address operator, address from, uint256 tokenId, bytes memory data)
    public returns (bytes4);
}
contract Vault is IKIP17Receiver {
	address public _owner;
	mapping ( address => bool ) public _admins ;
	constructor () {
		_owner = msg.sender;
	}
	function onKIP17Received(address operator, address from, uint256 tokenId, bytes memory data)
    public returns (bytes4){
//		return bytes4(keccak256("onKIP17Received(address,address,uint256,bytes)"));
//		return bytes4(keccak256("onKIP17Received(operator,from, uint256 tokenId, bytes memory data)"));
    return this.onKIP17Received.selector;
	}
	modifier onlyowner ( address _address ) {
		require ( _address == _owner , "ERR() only owner");
		_;
	}
	modifier onlyowner_or_admin ( address _address) {
		require ( _address == _owner || _admins[_address] , "ERR() not privileged" );
		_ ;
	}
	function set_admin ( address _address , bool _status ) public onlyowner( msg.sender ) {
		require ( _admins[ _address ] != _status , "ERR() redundant call" );
		_admins [ _address ] = _status ;
	}
	function transfer_erc721 ( address _erc721contract , address _to , uint256 _tokenid ) public onlyowner_or_admin ( msg.sender ){ 
		IKIP17 ( _erc721contract ).transferFrom ( address( this ) , _to , _tokenid ); 
	}
	function approve ( address _token , address _acting_contract , uint256 _amount ) public  onlyowner_or_admin( msg.sender ){
		IERC20( _token ).approve ( _acting_contract , _amount ) ;
	}
	function withdraw_fund ( address _tokenaddress , uint256 _amount , address _to ) public onlyowner ( msg.sender ) {
		if ( _tokenaddress == address(0)){
			payable( _to ).call { value : _amount } ("");
		}
		else {
			IERC20( _tokenaddress).transfer ( _to , _amount );
		}  	
  }
	function mybalance ( address _token ) public view returns ( uint256 ) {
			return IERC20(_token).balanceOf ( address (this ));
	}
	function allowance ( address _token , address _holder ) public view returns ( uint256 ) {
			return IERC20( _token).allowance ( _holder , address(this ));
	}

	function () payable public {

	}
}
