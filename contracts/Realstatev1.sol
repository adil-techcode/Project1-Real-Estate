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

    event Status(string, address); // This want display when Transcation Done
    error InsufficientBalance(string);
    //
    //
    //

    /*      Modifier    */

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

    modifier BuyyerNotAllowed() {
        require(
            Buyyerlist[msg.sender].Buyyer_address != msg.sender,
            "Buyyer Not Allowed"
        );
        _;
    }

    modifier SellerNotAllowed() {
        require(
            Sellerlist[msg.sender].Seller_address != msg.sender,
            "Seller Not Allowed"
        );
        _;
    }

    modifier SellerNotRegistered(address _sellerAddress) {
        require(
            Sellerlist[_sellerAddress].Seller_address == _sellerAddress,
            " Seller are not Registered"
        );
        _;
    }
    modifier BuyyerNotRegistered(address _BuyyerAddress) {
        require(
            Buyyerlist[_BuyyerAddress].Buyyer_address == _BuyyerAddress,
            "Buyyer are not Registered"
        );
        _;
    }

    modifier LandNotRegistered(uint256 _id) {
        require(landlists[_id].LandId == _id, "Land are not Registered");
        _;
    }

    //
    //
    //
    //  Constructor for Adding Information of Land Inspector
    constructor() {
        Land_Inspector.LandInspectorAddress = msg.sender;
        Land_Inspector.Id = 520;
        Land_Inspector.Name = "Adil";
        Land_Inspector.Age = 18;
        Land_Inspector.Designation = "SDO";
    }

    //
    //
    //
    // Function For Register Seller
    function RegisterSeller(
        string memory _Name,
        uint8 _Age,
        string memory _City,
        string memory _CNIC,
        string memory _Email
    ) public LandInspectorNotAllowed BuyyerNotAllowed {
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

    //
    //
    //
    //    Function For Register Buyyer
    function RegisterBuyyer(
        string memory _Name,
        uint8 _Age,
        string memory _City,
        string memory _CNIC,
        string memory _Email
    ) public LandInspectorNotAllowed SellerNotAllowed {
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

    //
    //
    //

    //             Function for Update Seller
    function UpdateSeller(
        string memory _Name,
        uint8 _Age,
        string memory _City,
        string memory _CNIC,
        string memory _Email
    )
        public
        LandInspectorNotAllowed
        BuyyerNotAllowed
        SellerNotRegistered(msg.sender)
    {
        Sellerlist[msg.sender] = SellerDetail(
            msg.sender,
            _Name,
            _Age,
            _City,
            _CNIC,
            _Email,
            Sellerlist[msg.sender].isVerified
        );

        emit Status("Seller Has Been Updated", msg.sender);
    }

    //
    //
    //

    //      Function for Update Buyyer
    function UpdateBuyyer(
        string memory _Name,
        uint8 _Age,
        string memory _City,
        string memory _CNIC,
        string memory _Email
    )
        public
        LandInspectorNotAllowed
        SellerNotAllowed
        BuyyerNotRegistered(msg.sender)
    {
        Buyyerlist[msg.sender] = BuyyerDetail(
            msg.sender,
            _Name,
            _Age,
            _City,
            _CNIC,
            _Email,
            Buyyerlist[msg.sender].isVerified
        );

        emit Status("Buyyer Has Been Upadted ", msg.sender);
    }

    //
    //
    //
    //   Function For Verify SEller

    function VerifySeller(bool permission, address _sellerAddress)
        public
        OnlyLandInspector
        SellerNotRegistered(_sellerAddress)
    {
        require(
            Sellerlist[_sellerAddress].isVerified == false,
            " Seller Already Verified"
        );

        Sellerlist[_sellerAddress].isVerified = permission;
        emit Status("Seller Has Been Verified", msg.sender);
    }

    //
    //
    //
    //                Function For Verify Buyyer

    function VerifyBuyyer(bool permission, address _BuyyerAddress)
        public
        OnlyLandInspector
        BuyyerNotRegistered(_BuyyerAddress)
    {
        require(
            Buyyerlist[_BuyyerAddress].isVerified == false,
            " Buyyer Already Verified"
        );
        Buyyerlist[_BuyyerAddress].isVerified = permission;
        emit Status("Buyyer Has Been Registered", msg.sender);
    }

    //
    //
    //
    //  Function for get seller information Struct

    function GetSellerDetail(address _sellerAddress)
        public
        view
        SellerNotRegistered(_sellerAddress)
        returns (SellerDetail memory)
    {
        return Sellerlist[_sellerAddress];
    }

    //
    //
    //
    //  Function for get Buyyer information Struct

    function GetBuyyerDetail(address _BuyyerAddress)
        public
        view
        BuyyerNotRegistered(_BuyyerAddress)
        returns (BuyyerDetail memory)
    {
        return Buyyerlist[_BuyyerAddress];
    }

    //
    //
    //
    //    Function For Add Land .land can be added by verified seller only

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
            "Registration Required Seller are not Registered"
        );
        require(
            Sellerlist[msg.sender].isVerified == true,
            " Seller Verification Required"
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

    //
    //
    //
    //  Function For Verify Land

    function VerifyLand(bool permission, uint256 _id)
        public
        OnlyLandInspector
        LandNotRegistered(_id)
    {
        require(landlists[_id].isVerified == false, " Land Already Verified");
        landlists[_id].isVerified = permission;
        emit Status("Land Has Been Verified", msg.sender);
    }

    //
    //
    //
    // Function for check which lands availble to Sale

    function LandAvailables() public view returns (uint256[] memory) {
        return LandAvailable;
    }

    //
    //
    //
    //
    //
    // Function in which pass id and get detail of land such as owner or Isverified
    function GetLandDetail(uint256 _id)
        public
        view
        LandNotRegistered(_id)
        returns (landDetail memory)
    {
        return landlists[_id];
    }

    //
    //
    //
    //
    //
    //
    // Last Function for Buy land

    function BuyLand(uint256 _landid)
        public
        payable
        LandInspectorNotAllowed
        SellerNotAllowed
        LandNotRegistered(_landid)
        BuyyerNotRegistered(msg.sender)
    {
        require(landlists[_landid].isVerified == true &&  Buyyerlist[msg.sender].isVerified == true, " Land 0r Buyyer  are Not Verified");
    

        require(msg.value > 0, "Please Enter Amount To pay");
        require(
            landlists[_landid].LandOwner != msg.sender,
            " Buyyer are also owner of this land"
        );
        if (landlists[_landid].LandPrice <= address(this).balance) {     // if Contract Balance is Greather than Land Price than then If bOdy Execeute 
            payable(landlists[_landid].LandOwner).transfer(               //     Transfer Landprice to Current Owner
                landlists[_landid].LandPrice
            );
            landlists[_landid].LandOwner = msg.sender;                // Change Ownership in Landlist Mapping
            payable(msg.sender).transfer(address(this).balance);     // Reamining Amount Send to Buyyer who send Greather Amount

            emit Status("Ownership has been Changed", msg.sender);     // Event Call
        } else {
            payable(msg.sender).transfer(address(this).balance);         // If Contract Amount less than transaction reverted and return the Amount 
            revert InsufficientBalance(
                "  Insuffiecient Amount ,  Balance has Been Reverted"
            );
        }
    }
}
