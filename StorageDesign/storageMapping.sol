pragma solidity 0.8.0;

contract storageMapping {

    struct Entity{
        uint data;
        address _address;
    }

    mapping(address => Entity) public entityStructs;


    function addEntity(uint _data) public returns(bool success) {
        Entity memory newEntity;
        newEntity.data = _data;
        newEntity._address = msg.sender;
        return true;
    }

    function updatateEntity(address _entity, uint newData) public returns (bool success){
        entityStructs[_entity].data = newData;
        return true;
    }

}
