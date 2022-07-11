pragma solidity 0.8.0;

//Send and transfer
//2300 gas stripend
//msg.sender.call.value(amount)("")

//CHECKS, EFFECTS (changing state), INTERACTIONS - pattern

contract test {
    mapping(address => uint) balance;

    function withdrawal() public {
        require(balance[msg.sender] > 0); //checks
        uint toTransfer = balance[msg.sender];
        balance[msg.sender] = 0; //effects
        (bool success, ) = msg.sender.call{value: toTransfer}(""); //interaction
        if(!success) {
            balance[msg.sender] = toTransfer;
        }
    }
}
