// Banking 컨트랙트를 작성해보자 !

pragma solidity ^0.5.1;

contract Banking

  address owner; // 컨트랙트의 현재 owner
  function Banking () public {
    owner = msg.sender
  }

  function withdraw() public {
    require(owner == msg.sender); // 인출 트랜잭션을 날리는 msg.sender만이 오너가 되어야 함. 권한이 없는 사람이 돈을 빼가면 안되니깐.
    msg.sender.transfer(address(this).balance);
  }

  function deposit(uint256 amount) public payable {
    require(msg.value == amount); // 입금하는 금액(amount)과 '실제로' 입금하는 금액(msg.value)가 서로 같아야 함.
  }

  function getBalance() public view returns (uint256) {
    return address(this).balance // 입출금 이후, 해당 컨트랙트 안에 남아있는 잔액 보여주기
  }
