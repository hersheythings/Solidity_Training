/ Youtube 광고수익 정산 스마트 계약 프로그램 using OraclizeAPI
/// SOPT 할 때까지 가만히 있어 썅놈아... 현재에 집중하면서.

pragma solidity ^0.4.2;

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol"; // oraclizeAPI 문서를 상속합시다ㅏㅏ

// 광고 수익의 퍼포먼스를 측정하기 위한 컨트랙트(AdPerformance). 그리고 해당 컨트랙 내에 필요한 인자들을 나열해보자.
contract AdPerformance is usingOraclize {
        address owner;
        address beneficiary;
        uint gweiToPayPerView; //View당 Pay되는 ETH의 양. (10^(-9)ETH)
        string youtubeId;
        bool withdrawn;
}

// 컨트랙을 하나 선언했으면, 이 컨트랙에 접근할 수 있도록 해당 컨트랙과 동일한 이름의 함수(생성자)를 항상 바로 생성하자.
function AdPerformance (address _beneficiary, uint _gweiToPayPerView, string _youtubeId) public payable {
        owner = msg.sender;
        beneficiary = _beneficiary;
        gweiToPayPerView = _gweiToPayPerView
        youtubeId = _youtubeId
        withdrawn = false;
}

=> 위에서 선언한 변수들에 대해서, 아래 5가지 함수를 활용해 구체적 기능을 부여.

// 본격 광고수익 정산 관련 Function 및 기능 추가 코딩
/// 1. 광고수익 인출 관련 기능
    function withdraw () public {
        require(msg.sender) == beneficiary
        require(!withdrawn);
        string memory query = strConcat('json(https://www.googleapis.com/youtube/v3/videos?id=',
                youtubeId,
                '&key=AIzaSyAhV6cw7pjvrrBoSkIDxff4gvovbF_9rXk%20&part=statistics).items.0.statistics.viewCount');
        oraclize_query('URL', query)
    }

///2.
    function __callback(bytes32, string result) public {
        require(msg.sender == oraclize_cbAddress());
        require(!withdrawn);

        uint viewCount = stringToUint(result);
        uint amount = viewCount * gweiToPayPerView * 1000000000;
        uint balance = address(this).balance;

        if (balance < amount) {
            amount = balance; // ex. amount(실제 정산액) = 110, balance(총 정산액) = 100 => 이 상황에서 amount > balance는 논리적으로 말이 안되니, amount = balance가 맞음.
        }

        beneficiary.transfer(amount);
        withdrawn = true;
    }

///3.
    function isWithdrawn() public view returns (bool) {
        return withdrawn;
    }

///4.
    function refund() public {
        require(msg.sender == owner);
        require(withdrawn);

        uint balance = address(this).balance;
        if (balance > 0) {
            owner.transfer(balance);
        }
    }

///5.
    function stringToUint(string s) internal pure returns (uint result) {
        bytes memory b = bytes(s);
        uint i;
        result = 0;
        for (i = 0; i < b.length; i++) {
            uint c = uint(b[i]);
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            }
        }
    }

    // => 항상, 특정 함수(function)를 선언하면 그 내부적으로 require, string 등 변수를 섞어서 세부 기능들을 구조화/구체화시키는 것 !
    // 어려우면, 위처럼 function 단위로 끊어서 거시적으로 메카닉을 살펴본다음, 세부사항으로 들어가기.
    // 숲 ==> 나무 ; 항상 니 스타일이었잖수
