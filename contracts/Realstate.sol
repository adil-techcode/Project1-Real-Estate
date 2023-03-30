// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

contract Realstate {
    /* This Struct  contains details related to  land such as
    LandId, LandOwner, Area, City, State, LandPrice, and whether it is verified or not. */
    struct landDetail {
        uint256 LandId;
        address LandOwner;
        string Area;
        string City;
        string State;
        uint256 LandPrice;
        bool isVerified;
    }

    /* This Struct contains details about a seller
      such as the seller's address, name, age, city, CNIC, email, and whether the seller is verified or not.   */
    struct SellerDetail {
        address Seller_address;
        string Name;
        uint8 Age;
        string City;
        string CNIC;
        string Email;
        bool isVerified;
    }

    /* The third struct  contains details about a buyer
    such as the buyer's address, name, age, city, CNIC, email, and whether the buyer is verified or not. */
    struct BuyyerDetail {
        address Buyyer_address;
        string Name;
        uint8 Age;
        string City;
        string CNIC;
        string Email;
        bool isVerified;
    }

    /*  This Last Struct  contains details about a land inspector
  such as the inspector's address, ID, name, age, and designation. */
    struct landInspectorDetail {
        address LandInspectorAddress;
        uint256 Id;
        string Name;
        uint8 Age;
        string Designation;
    }

    mapping(address => SellerDetail) Sellerlist; //  This mapping associates a unique(key) seller's address with their corresponding SellerDetail struct for storing information about sellers.
    mapping(address => BuyyerDetail) Buyyerlist; // Similar  To Sellerlist , this mapping store information about Buyyers.
    mapping(uint256 => landDetail) landlists; // This Mapping store Landdetail in which land_Id a unique key with their land detail struct.
    uint256[] LandAvailable; // This Array is used to check Which Land are Available to Sell.
    landInspectorDetail public Land_Inspector; // This Struct type Varaible store Information about Inspector


    
    event Status(string, address);
      
    modifier OnlyLandInspector() {
        require(
            Land_Inspector.LandInspectorAddress == msg.sender,
            "Only LandInspector Verify "
        );
        _;
    }

    modifier LandInspectorNotAllowed() {
        require(
            Land_Inspector.LandInspectorAddress != msg.sender,
            "LandInspector Not allowed"
        );
        _;
    }


    constructor() {
        Land_Inspector.LandInspectorAddress = msg.sender;
        Land_Inspector.Id = 520;
        Land_Inspector.Name = "Adil";
        Land_Inspector.Age = 18;
        Land_Inspector.Designation = "SDO";
    }

    function RegisterSeller(
        string memory _Name,
        uint8 _Age,
        string memory _City,
        string memory _CNIC,
        string memory _Email
    ) public LandInspectorNotAllowed {
        require(
            Buyyerlist[msg.sender].Buyyer_address != msg.sender,
            "Buyyer Not Allowed"
        );

        require(
            Sellerlist[msg.sender].Seller_address != msg.sender,
            "You are Already Registered"
        );

        Sellerlist[msg.sender] = SellerDetail(
            msg.sender,
            _Name,
            _Age,
            _City,
            _CNIC,
            _Email,
            false
        );

        emit Status("Seller Has Been Registered", msg.sender);
    }

    function RegisterBuyyer(
        string memory _Name,
        uint8 _Age,
        string memory _City,
        string memory _CNIC,
        string memory _Email
    ) public LandInspectorNotAllowed {
        require(
            Sellerlist[msg.sender].Seller_address != msg.sender,
            "Seller Not Allowed"
        );

        require(
            Buyyerlist[msg.sender].Buyyer_address != msg.sender,
            " You are Already Registered"
        );

        Buyyerlist[msg.sender] = BuyyerDetail(
            msg.sender,
            _Name,
            _Age,
            _City,
            _CNIC,
            _Email,
            false
        );

        emit Status("Buyyer Has Been Registered", msg.sender);
    }

    function VerifySeller(bool permission, address _sellerAddress)
        public
        OnlyLandInspector
    {
        require(
            Sellerlist[_sellerAddress].Seller_address == _sellerAddress,
            " Seller are not Registered"
        );
        Sellerlist[_sellerAddress].isVerified = permission;
        emit Status("Seller Has Been Verified", msg.sender);
    }

    function VerifyBuyyer(bool permission, address _BuyyerAddress)
        public
        OnlyLandInspector
    {
        require(
            Buyyerlist[_BuyyerAddress].Buyyer_address == _BuyyerAddress,
            "Buyyer are not Registered"
        );
        Buyyerlist[_BuyyerAddress].isVerified = permission;
        emit Status("Buyyer Has Been Registered", msg.sender);
    }

    function GetSellerDetail(address _sellerAddress)
        public
        view
        returns (SellerDetail memory)
    {
        require(
            Sellerlist[_sellerAddress].Seller_address == _sellerAddress,
            "Seller are not Registered"
        );

        return Sellerlist[_sellerAddress];
    }

    function GetBuyyerDetail(address _BuyyerAddress)
        public
        view
        returns (BuyyerDetail memory)
    {
        require(
            Buyyerlist[_BuyyerAddress].Buyyer_address == _BuyyerAddress,
            "Buyyer are not Registered"
        );

        return Buyyerlist[_BuyyerAddress];
    }

    function AddLand(
        uint256 _LandId,
        string memory _Area,
        string memory _City,
        string memory _State,
        uint256 _LandPrice
    ) public LandInspectorNotAllowed {
        require(
            landlists[_LandId].LandId != _LandId,
            "Land Already Registered"
        );
        require(
            Sellerlist[msg.sender].Seller_address == msg.sender,
            "Registration Required"
        );
        require(
            Sellerlist[msg.sender].isVerified == true,
            " Verification Required"
        );

        landlists[_LandId] = landDetail(
            _LandId,
            msg.sender,
            _Area,
            _City,
            _State,
            _LandPrice,
            false
        );

        LandAvailable.push(_LandId);
        emit Status("Land Has Been Added", msg.sender);
    }

    function VerifyLand(bool permission, uint256 _id) public OnlyLandInspector {
        require(landlists[_id].LandId == _id, "Land are not Registered");
        landlists[_id].isVerified = permission;
        emit Status("Land Has Been Verified", msg.sender);
    }

    function LandAvailables() public view returns (uint256[] memory) {
        return LandAvailable;
    }

    function GetLandDetail(uint256 _id)
        public
        view
        returns (landDetail memory)
    {
        require(landlists[_id].LandId == _id, "Land are not Registered");
        return landlists[_id];
    }

    function UpdateSeller(
        string memory _Name,
        uint8 _Age,
        string memory _City,
        string memory _CNIC,
        string memory _Email
    ) public LandInspectorNotAllowed {
        require(
            Buyyerlist[msg.sender].Buyyer_address != msg.sender,
            "Buyyer Not Allowed"
        );

        require(
            Sellerlist[msg.sender].Seller_address == msg.sender,
            "You are not Registered"
        );

        Sellerlist[msg.sender] = SellerDetail(
            msg.sender,
            _Name,
            _Age,
            _City,
            _CNIC,
            _Email,
            false
        );

        emit Status("Seller Has Been Updated", msg.sender);
    }

    function UpdateBuyyer(
        string memory _Name,
        uint8 _Age,
        string memory _City,
        string memory _CNIC,
        string memory _Email
    ) public LandInspectorNotAllowed {
        require(
            Sellerlist[msg.sender].Seller_address != msg.sender,
            "Seller Not Allowed"
        );

        require(
            Buyyerlist[msg.sender].Buyyer_address == msg.sender,
            " You are not Registered"
        );

        Buyyerlist[msg.sender] = BuyyerDetail(
            msg.sender,
            _Name,
            _Age,
            _City,
            _CNIC,
            _Email,
            false
        );

        emit Status("Buyyer Has Been Upadted ", msg.sender);
    }

    function BuyLand(uint256 _landid) public payable LandInspectorNotAllowed {
        require(
            landlists[_landid].LandId == _landid,
            " Land are Not Registered"
        );
        require(
            Sellerlist[msg.sender].Seller_address != msg.sender,
            " Only Buyyer Buy Land"
        );
        require(
            Buyyerlist[msg.sender].Buyyer_address == msg.sender,
            " Buyyer are Not Registered"
        );
        require(landlists[_landid].isVerified == true, "Land are Not Verified");
        require(
            Buyyerlist[msg.sender].isVerified == true,
            "Buyyer are not Verified"
        );
        require(
            landlists[_landid].LandPrice == address(this).balance,
            "Insufficient Amount"
        );
        payable(landlists[_landid].LandOwner).transfer(address(this).balance);
        landlists[_landid].LandOwner = msg.sender;
    }
}
