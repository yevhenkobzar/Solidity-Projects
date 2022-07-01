// Multi signature wallet on Ethereum, Solidity language 

pragma solidity 0.7.5;
pragma abicoder v2;

contract Wallet {
    address[] public owners;
    uint limit; 


    mapping(address => uint) balance;

    event transferRequestCreated(address _sender, address _reciever, uint _amount, uint _id);
    event ApprovalRecieved(uint _id, uint _approvals, address _approver);
    event TransferApproved(uint _id);

    struct Transfer {
        address payable recipient;
        bool sent;
        uint approvals;
        uint amount;
        uint id;
    }


    modifier onlyOwners(){
        bool owner = false;
        for(uint i=0; i<owners.length;i++){
            if(owners[i] == msg.sender){
                owner = true;
            }
        }
        require(owner == true);
        _;
    }



    Transfer[] transferRequests;

    mapping(address => mapping(uint => bool)) approvals;

    //mapping[address][transferID] => true/false

    //mapping[msg.sender][5] = true;

    constructor(address[] memory _owners, uint _limit) {
        owners = _owners;
        limit = _limit;
    }

    function deposit() public payable {}

    function createTransfer(address payable _recipient, uint _amount) public onlyOwners {
        transferRequests.push(Transfer(_recipient, false, 0, _amount, transferRequests.length));
    }

    function approve(uint _id) public onlyOwners {
        require(approvals[msg.sender][_id] == false);
        require(transferRequests[_id].sent == false);

        approvals[msg.sender][_id] = true;
        transferRequests[_id].approvals++; 

        emit ApprovalRecieved(_id, transferRequests[_id].approvals, msg.sender);

        if (transferRequests[_id].approvals >= limit) {
            transferRequests[_id].sent = true;
            transferRequests[_id].recipient.transfer(transferRequests[_id].amount);
            emit TransferApproved(_id);
        }
    }

    function getTransferRequests() public view returns (Transfer[] memory){
        return transferRequests;
    }
    

}

