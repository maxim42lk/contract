// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyToken {
    string public name = "LearnToken";
    string public symbol = "LR";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    
    // Владелец оставляем публичным если нужно
    address public owner;
    
    // Делаем приватными только эти две переменные
    string private lastMessage;
    
    // Структура для хранения информации о переводе с сообщением
    struct TransferWithMessage {
        address from;
        address to;
        uint256 amount;
        string message;
        uint256 timestamp;
    }
    
    // Делаем приватной
    TransferWithMessage private lastTransferWithMessage;
    
    // Остальные публичные переменные и функции оставляем
    TransferWithMessage[] public transferHistory;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // События
    event Transfer(address indexed from, address indexed to, uint256 value, string message);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event MessageSent(address indexed sender, string message);
    event TransferWithMessageEvent(address indexed from, address indexed to, uint256 value, string message);

    constructor(uint256 initialSupply) {
        totalSupply = initialSupply * (10 ** uint256(decimals));
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(msg.sender, msg.sender, totalSupply, "Initial supply");
        owner = msg.sender;
    }

    // Функции токена
    
    function transferWithMessage(address to, uint256 amount, string memory _message) public returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Not enough balance");
        
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        
        // Обновляем приватную переменную
        lastTransferWithMessage = TransferWithMessage({
            from: msg.sender,
            to: to,
            amount: amount,
            message: _message,
            timestamp: block.timestamp
        });
        
        // Добавляем в публичную историю
        transferHistory.push(lastTransferWithMessage);
        
        // Обновляем приватное сообщение
        lastMessage = _message;
        
        emit Transfer(msg.sender, to, amount, _message);
        emit TransferWithMessageEvent(msg.sender, to, amount, _message);
        emit MessageSent(msg.sender, _message);
        
        return true;
    }
    
    function transfer(address to, uint256 amount) public returns (bool) {
        return transferWithMessage(to, amount, "");
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(balanceOf[from] >= amount, "Not enough balance");
        require(allowance[from][msg.sender] >= amount, "Allowance too low");
        
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        allowance[from][msg.sender] -= amount;
        
        emit Transfer(from, to, amount, "");
        return true;
    }
    
    function transferFromWithMessage(address from, address to, uint256 amount, string memory _message) public returns (bool) {
        require(balanceOf[from] >= amount, "Not enough balance");
        require(allowance[from][msg.sender] >= amount, "Allowance too low");
        
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        allowance[from][msg.sender] -= amount;
        
        // Обновляем приватную переменную
        lastTransferWithMessage = TransferWithMessage({
            from: from,
            to: to,
            amount: amount,
            message: _message,
            timestamp: block.timestamp
        });
        
        // Добавляем в публичную историю
        transferHistory.push(lastTransferWithMessage);
        
        // Обновляем приватное сообщение
        lastMessage = _message;
        
        emit Transfer(from, to, amount, _message);
        emit TransferWithMessageEvent(from, to, amount, _message);
        emit MessageSent(msg.sender, _message);
        
        return true;
    }

    // Публичные функции для работы с сообщениями
    
    function sendMessage(string memory _message) public {
        lastMessage = _message;
        emit MessageSent(msg.sender, _message);
    }

    // Геттеры остаются публичными
    
    function getLastMessage() public view returns (string memory) {
        return lastMessage;
    }
    
    function getLastTransferWithMessage() public view returns (
        address from,
        address to,
        uint256 amount,
        string memory message,
        uint256 timestamp
    ) {
        return (
            lastTransferWithMessage.from,
            lastTransferWithMessage.to,
            lastTransferWithMessage.amount,
            lastTransferWithMessage.message,
            lastTransferWithMessage.timestamp
        );
    }
    
    function getTransferHistoryCount() public view returns (uint256) {
        return transferHistory.length;
    }
    
    function getTransferWithMessage(uint256 index) public view returns (
        address from,
        address to,
        uint256 amount,
        string memory message,
        uint256 timestamp
    ) {
        require(index < transferHistory.length, "Index out of bounds");
        TransferWithMessage memory transferInfo = transferHistory[index];
        
        return (
            transferInfo.from,
            transferInfo.to,
            transferInfo.amount,
            transferInfo.message,
            transferInfo.timestamp
        );
    }
    
    function getLastMessageAndTransfer() public view returns (
        string memory lastMsg,
        address sender,
        address recipient,
        uint256 amount,
        string memory transferMessage,
        uint256 timestamp
    ) {
        return (
            lastMessage,
            lastTransferWithMessage.from,
            lastTransferWithMessage.to,
            lastTransferWithMessage.amount,
            lastTransferWithMessage.message,
            lastTransferWithMessage.timestamp
        );
    }
}