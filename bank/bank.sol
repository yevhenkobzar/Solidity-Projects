pragma solidity 0.7.5;
pragma abicoder v2;

import "./ownable.sol";

import "./destroyable.sol";

interface GovernmentInterface {
    function addTransaction(address _from, address _to, uint _amount) external payable;

}

contract Bank is Ownable, Destroyable { 

    GovernmentInterface governmentInstance = GovernmentInterface(0xAc40c9C8dADE7B9CF37aEBb49Ab49485eBD3510d);

    mapping(address => uint) balance;

    event depositDone(uint amount, address indexed depositedTo);

    struct Test {
        uint t;
    }

    event transfered(uint amount, address indexed sender, address indexed receiver);




    // modifier costs(uint price) {
    //     require(msg.value >= price);
    //     _; //run the function
    // }


    
    function deposit() public payable returns (uint){
        balance[msg.sender] += msg.value;

        emit depositDone(msg.value, msg.sender);
        return balance[msg.sender];

    }

    function withdraw(uint amount) public returns (uint) {
        //msg.sender is an address
        //address payable toSend = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
        require(balance[msg.sender] >= amount, "Balance is not sufficient!");
        msg.sender.transfer(amount);
        balance[msg.sender] -= amount;
        return balance[msg.sender];
    }



    function getBalance() public view returns (uint){
        return balance[msg.sender];
    }

    function getOwner() public view returns (address){
        return owner;
    }

    function transfer(address recipient, uint amount) public {
        require(balance[msg.sender] >= amount, "Balance not sufficient");
        require(msg.sender != recipient, "Don't transfer money to yourself");

        uint previousSenderBalance = balance[msg.sender];

        _transfer(msg.sender, recipient, amount);

        governmentInstance.addTransaction{value: 1 ether}(msg.sender, recipient, amount);

        emit transfered(amount, msg.sender, recipient);

        assert(balance[msg.sender] == previousSenderBalance - amount);

        //event logs and further checks

    }

    function _transfer(address from, address to, uint amount) private {
        balance[from] -= amount;
        balance[to] += amount;
    }


}

