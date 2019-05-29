// Simple Crowdfunding Codes like Kickstarter

// 1. 크라우드펀딩 컨트랙트 관련 파라미터 설정 -> 1) 기간, 2) Total Investment Cap

Contract Crowdfunding {
  address owner;
  uint256 deadline;
  uint256 goal;
  mapping(address => uint256) public pledgeOf;

  function Crowdfunding (uint256 numberOfDays, uint256 _goal) public {
    owner = msg.sender;
    deadline = now + (numberOfDays * 1 days);
    goal = _goal;
  }
}


// 2. Accepting Pledges : 기간 또는 Cap이 달성되었을 때, 투자 종료 !
function pledge(uint amount) public payable {
  require(now < deadline);
  require(msg.value == amount);
  pledgeOf[msg.sender] += amount;
}

// 3. 투자금 인출하기
/// 3-1. Funds 인출 요청에 대한 조건들
  function claimFunds() public {
    require(address(this).balance) >= goal; // 모인 투자금이 goal cap보다 높아야, 인출이 가능한 설계를 했나보네.
    require(now>=deadline); // 데드라인이 지난 이후에야 인출할 수 있고.
    require(msg.sender == owner); // funds를 인출하는 msg.sender는 이 컨트랙트의 오너여야 함 !

    msg.sender.transfer(address(this).balance);
  }

/// 3-2. Funds 실제 인출 단계 Structure

  function getRefund() public { // 환불해주는 절차
    require(address(this).balance < goal); // funding goal not met T.T
    require(now >= deadline);

    uint256 amount = pledgeOf[msg.sender]
    pledgeOf[msg.sender] = 0;
    msg.sender.transfer(amount);
  }
