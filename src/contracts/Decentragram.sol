pragma solidity >=0.4.21 <0.6.0;

contract Decentragram {
    string public name = "Decentragram";

    struct Image {
        uint256 id;
        string hash;
        string description;
        uint256 tipAmount;
        address payable author;
    }
    event ImageCreated(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );
    event ImageTipped(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );
    mapping(uint256 => Image) public images;
    uint256 public imageCount = 0;

    function uploadImage(string memory _imgHash, string memory _desc) public {
        require(bytes(_desc).length > 0);
        require(bytes(_imgHash).length > 0);
        require(msg.sender != address(0x0));

        imageCount++;
        images[imageCount] = Image(imageCount, _imgHash, _desc, 0, msg.sender);

        emit ImageCreated(imageCount, _imgHash, _desc, 0, msg.sender);
    }

    function tipImageOwner(uint256 _id) public payable {
        // Make sure the id is valid
        require(_id > 0 && _id <= imageCount);
        // Fetch the image
        Image memory _image = images[_id];
        // Fetch the author
        address payable _author = _image.author;
        // Pay the author by sending them Ether
        address(_author).transfer(msg.value);
        // Increment the tip amount
        _image.tipAmount = _image.tipAmount + msg.value;
        // Update the image
        images[_id] = _image;
        // Trigger an event
        emit ImageTipped(
            _id,
            _image.hash,
            _image.description,
            _image.tipAmount,
            _author
        );
    }
}
