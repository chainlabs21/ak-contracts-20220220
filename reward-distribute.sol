
pragma solidity>=0.8.0;

import "./IERC20.sol"; 
import "./IAdmin.sol" ;

contract DistributeReward {
	address public _reward_token ;
	address public _owner ;
	modifier only_owner ( address _address ) public {
		require ( msg.sender == _owner , "ERR() not privileged");
		_; 
	}∂
	constructor () {
		_owner = msg.sender ;
	}
	function distribute_reward (
		address [] _recipients
		, uint256 [] _amounts
		, address _reward_token
		, bool _mint_or_transfer
	) public only_owner( msg.sender ) {
		uint256 count = _recipients.length ;
		require ( _recipients.length == _amounts.length , "ERR() arg lengths mismatch");
		if ( _mint_or_transfer ){
			for ( uint256 i=0; i< count ; i++){
				if (IERC20( _reward_token).mint( _recipients[ i] , _amounts[i ]) ){}
				else {break ;}
			}
		} else {
			if (IERC20( _reward_token).transfer( _recipients[ i] , _amounts[i ]) ){}
			else {break ;}
		}
	}
}

