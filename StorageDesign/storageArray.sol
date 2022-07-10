pragma solidity 0.8.0;

contract storageArray {

    struct Entity{
        uint data;
        address _address;
    }

    Entity[] entityArray;

    function addEntity(uint _data) public returns(bool success) {
        Entity memory newEntity;
        newEntity.data = _data;
        newEntity._address = msg.sender;
        entityArray.push(newEntity);
        return true;
    }

    function updateEntity(uint _index, uint newData) public returns (bool success) {
        entityArray[_index].data = newData;
        return true;
    }

}
