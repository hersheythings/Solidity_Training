// Sample Auction Contract

pragma solidity ^0.4.21;

contract simpleAuction {
address public beneficiary
uint public auctionEnd;
}

// 1. 옥션의 현재 상황
address public highestBidder;
uint public highestBid

// 2. HighestBid 미만으로 제시된 Bid에 대한 출금 컨트랙
mapping (address => uint) pendingReturns;

bool auctionEnded;

// 3. Auction에 변동이 생기는 경우를 표현해주는 event 컨트랙
event HighestBidIncreased (address bidder, uint amount);
event AuctionEnded(address winner, uint amount)
