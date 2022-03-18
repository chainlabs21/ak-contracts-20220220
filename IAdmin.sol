

pragma solidity>=0.8.0;

interface IAdmin {
	function _owner () external returns ( address ) ;
	function _stable_tokens (address ) external returns ( bool ) ;
	function _admins ( address ) external returns ( bool );
	function _token_registry ( string memory ) external returns ( address ) ;
	function _feecollector () external returns ( address );
	function _feetaker () external returns ( address );
	function set_stable_token ( address _address , bool _status ) external ;
	function _fees ( string memory ) external returns (  uint256 );
}
