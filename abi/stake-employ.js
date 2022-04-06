const abi = [
			{
				"constant": true,
				"inputs": [
					{
						"name": "interfaceId",
						"type": "bytes4"
					}
				],
				"name": "supportsInterface",
				"outputs": [
					{
						"name": "",
						"type": "bool"
					}
				],
				"payable": false,
				"stateMutability": "view",
				"type": "function"
			},
			{
				"constant": false,
				"inputs": [
					{
						"name": "_erc721",
						"type": "address"
					},
					{
						"name": "_tokenids",
						"type": "uint256[]"
					},
					{
						"name": "_to",
						"type": "address"
					}
				],
				"name": "withdraw_batch",
				"outputs": [],
				"payable": false,
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"constant": false,
				"inputs": [
					{
						"name": "_address",
						"type": "address"
					}
				],
				"name": "set_reward_token",
				"outputs": [],
				"payable": false,
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"constant": false,
				"inputs": [
					{
						"name": "_token",
						"type": "address"
					},
					{
						"name": "_to",
						"type": "address"
					},
					{
						"name": "_amount",
						"type": "uint256"
					}
				],
				"name": "withdraw_fund",
				"outputs": [],
				"payable": false,
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"constant": true,
				"inputs": [
					{
						"name": "_token",
						"type": "address"
					}
				],
				"name": "mybalance",
				"outputs": [
					{
						"name": "",
						"type": "uint256"
					}
				],
				"payable": false,
				"stateMutability": "view",
				"type": "function"
			},
			{
				"constant": false,
				"inputs": [
					{
						"name": "_erc721",
						"type": "address"
					},
					{
						"name": "_tokenid",
						"type": "uint256"
					}
				],
				"name": "deposit",
				"outputs": [],
				"payable": false,
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"constant": true,
				"inputs": [],
				"name": "_reward_amount",
				"outputs": [
					{
						"name": "",
						"type": "uint256"
					}
				],
				"payable": false,
				"stateMutability": "view",
				"type": "function"
			},
			{
				"constant": false,
				"inputs": [
					{
						"name": "_erc721",
						"type": "address"
					},
					{
						"name": "_tokenid",
						"type": "uint256"
					},
					{
						"name": "_to",
						"type": "address"
					}
				],
				"name": "withdraw",
				"outputs": [],
				"payable": false,
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"constant": true,
				"inputs": [
					{
						"name": "",
						"type": "address"
					},
					{
						"name": "",
						"type": "uint256"
					}
				],
				"name": "_balances",
				"outputs": [
					{
						"name": "",
						"type": "uint256"
					}
				],
				"payable": false,
				"stateMutability": "view",
				"type": "function"
			},
			{
				"constant": true,
				"inputs": [],
				"name": "_reward_token",
				"outputs": [
					{
						"name": "",
						"type": "address"
					}
				],
				"payable": false,
				"stateMutability": "view",
				"type": "function"
			},
			{
				"constant": true,
				"inputs": [],
				"name": "_owner",
				"outputs": [
					{
						"name": "",
						"type": "address"
					}
				],
				"payable": false,
				"stateMutability": "view",
				"type": "function"
			},
			{
				"constant": true,
				"inputs": [
					{
						"name": "",
						"type": "address"
					}
				],
				"name": "_balancesums",
				"outputs": [
					{
						"name": "",
						"type": "uint256"
					}
				],
				"payable": false,
				"stateMutability": "view",
				"type": "function"
			},
			{
				"constant": false,
				"inputs": [
					{
						"name": "_erc721",
						"type": "address"
					},
					{
						"name": "_tokenids",
						"type": "uint256[]"
					}
				],
				"name": "deposit_batch",
				"outputs": [],
				"payable": false,
				"stateMutability": "nonpayable",
				"type": "function"
			},
			{
				"inputs": [
					{
						"name": "__reward_token",
						"type": "address"
					}
				],
				"payable": false,
				"stateMutability": "nonpayable",
				"type": "constructor"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": false,
						"name": "_erc721",
						"type": "address"
					},
					{
						"indexed": false,
						"name": "_tokenid",
						"type": "uint256"
					}
				],
				"name": "Deposit",
				"type": "event"
			},
			{
				"anonymous": false,
				"inputs": [
					{
						"indexed": false,
						"name": "_erc721",
						"type": "address"
					},
					{
						"indexed": false,
						"name": "_tokenid",
						"type": "uint256"
					}
				],
				"name": "Withdraw",
				"type": "event"
			}
		]
export { abi }
