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
     bytes respond ; // State Varaiable for get responce from call fUNCTION

    //
    //
    //

     /*      Modifier    */
                        
    /*
   The "OnlyLandInspector()" modifier restricts access to a specific function to the address of the Land Inspector.
    */                           
    modifier OnlyLandInspector() {
        require(
            Land_Inspector.LandInspectorAddress == msg.sender,
            "Only LandInspector Verify "
        );
        _;
    }

   
    /*
    The "LandInspectorNotAllowed()" modifier is used to prevent the Land Inspector from performing a specific function or method in a smart contract. 
    */                           
    modifier LandInspectorNotAllowed() {
        require(
            Land_Inspector.LandInspectorAddress != msg.sender,
            "LandInspector Not allowed"
        );
        _;
    }

 /*
  The "BuyyerNotAllowed()" modifier is used to prevent a buyer from performing a specific function or method in a smart contract
    */                           
    modifier BuyyerNotAllowed() {
        require(
            Buyyerlist[msg.sender].Buyyer_address != msg.sender,
            "Buyyer Not Allowed"
        );
        _;
    }

 /*
  The "SellerNotAllowed()" modifier is used to prevent a Seller from performing a specific function or method in a smart contract
    */                           
    modifier SellerNotAllowed() {
        require(
            Sellerlist[msg.sender].Seller_address != msg.sender,
            "Seller Not Allowed"
        );
        _;
    }

 /*
    The "SellerNotRegistered()" modifier ensures that only registered sellers can perform specific functions
   in a smart contract by checking if the seller's address is in the "Sellerlist".
    */   


    modifier SellerNotRegistered(address _sellerAddress) {
        require(
            Sellerlist[_sellerAddress].Seller_address == _sellerAddress,
            " Seller are not Registered"
        );
        _;
    }


 /*
    The "BuyyerNotRegistered()" modifier checks if the buyer's address is in the "Buyyerlist" to ensure 
    only registered buyers can access specific functions in a smart contract.
    */ 

    modifier BuyyerNotRegistered(address _BuyyerAddress) {
        require(
            Buyyerlist[_BuyyerAddress].Buyyer_address == _BuyyerAddress,
            "Buyyer are not Registered"
        );
        _;
    }

 /*
   The "LandNotRegistered()" modifier ensures that only registered land can be accessed 
   or modified in a smart contract by checking if the land ID is in the "landlists".
    */ 

    modifier LandNotRegistered(uint256 _id) {
        require(landlists[_id].LandId == _id, "Land are not Registered");
        _;
    }

    
   
    /*
   Constructor for Adding Information of Land Inspector
    */ 

    constructor() {
        Land_Inspector.LandInspectorAddress = msg.sender;
        Land_Inspector.Id = 520;
        Land_Inspector.Name = "Adil";
        Land_Inspector.Age = 18;
        Land_Inspector.Designation = "SDO";
    }

  
/*
     * @dev RegisterSeller is used to register Seller.
     * Requirement:
     * - This function can be called by Seller
     * @param _Name - _SellerName 
     * @param _Age -  _SellerAge
     * @param _City - _SellerCity  
     * @param _CNIC -  _SellerCnic
     * @param _Email -  _SellerEmail
     *
     * Emits a {Status} event.
    */

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

  

/*
     * @dev RegisterBuyyer is used to register Buyyer.
     * Requirement:
     * - This function can be called by Buyyer
     * @param _Name - _BuyyerName 
     * @param _Age -  _BuyyerAge
     * @param _City - _BuyyerCity  
     * @param _CNIC -  _BuyyerCnic
     * @param _Email -  _BuyyerEmail
     *
     * Emits a {Status} event.
    */



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


    /*
     * @dev UpdateSeller is used to Update Seller.
     * Requirement:
     * - This function can be called by RegisteredSeller
     * @param _Name - _SellerName 
     * @param _Age -  _SellerAge
     * @param _City - _SellerCity  
     * @param _CNIC -  _SellerCnic
     * @param _Email -  _SellerEmail
     *
     * Emits a {Status} event.
    */


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

    


    /*
     * @dev UpdateSeller is used to Update Buyyer.
     * Requirement:
     * - This function can be called by RegisteredBuyyer
     * @param _Name - _BuyyerName 
     * @param _Age -  _BuyyerAge
     * @param _City - _BuyyerCity  
     * @param _CNIC -  _BuyyerCnic
     * @param _Email -  _BuyyerEmail
     *
     * Emits a {Status} event.
    */



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

   /* 
 * "VerifySeller()" function verifies a Seller's address.
*  Only the Land Inspector can execute this function.
*  It checks if the buyer is not already registered, sets "isVerified" to true if not, and logs the registration.
* @param _sellerAddress- for sellerAddress to verify  
*/

    function VerifySeller( address _sellerAddress)
        public
        OnlyLandInspector
        SellerNotRegistered(_sellerAddress)
    {
        require(
            Sellerlist[_sellerAddress].isVerified == false,
            " Seller Already Verified"
        );

        Sellerlist[_sellerAddress].isVerified = true;
        emit Status("Seller Has Been Verified", msg.sender);
    }

   

 /* 
 * "VerifyBuyyer()" function verifies a buyer's address.
*  Only the Land Inspector can execute this function.
*  It checks if the buyer is not already registered, sets "isVerified" to true if not, and logs the registration.
* @param _BuyyerAddress - for BuyyerAdddress to verify
*/


    function VerifyBuyyer( address _BuyyerAddress)
        public
        OnlyLandInspector
        BuyyerNotRegistered(_BuyyerAddress)
    {
        require(
            Buyyerlist[_BuyyerAddress].isVerified == false,
            " Buyyer Already Verified"
        );
        Buyyerlist[_BuyyerAddress].isVerified = true;
        emit Status("Buyyer Has Been Registered", msg.sender);
    }

   
    /*
       * "GetSellerDetail()" function returns the details of a registered seller in the contract.
       *  It's a read-only function accessible by any user using the "view" keyword.
       *  The "SellerNotRegistered" modifier ensures that the seller's address is registered in the "Sellerlist".
       * @param _sellerAddress -  seller's address as an argument and returns a "SellerDetail" struct containing the seller's details.
    */

    function GetSellerDetail(address _sellerAddress)
        public
        view
        SellerNotRegistered(_sellerAddress)
        returns (SellerDetail memory)
    {
        return Sellerlist[_sellerAddress];
    }

   
      /*
       * "GetBuyyerDetail()" function returns the details of a registered Buuyyer in the contract.
       *  It's a read-only function accessible by any user using the "view" keyword.
       *  The "BuyyerNotRegistered" modifier ensures that the Buyyer's address is registered in the "Buyyerlist".
       * @param _BuyyerAddress -  buyyer's address as an argument and returns a "BuyyerDetail" struct containing the Buyyer's details.
    */

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

      /*
     * @dev AddLand()  is used to Add Land.
     * Requirement:
     * - This function can be called by  verified seller only
     * @param _LandId - _LandId  
     * @param _Area -  _Area
     * @param _City - _City  
     * @param _State -  _State
     * @param _LandPrice - _LandPrice
     *
     * Emits a {Status} event.
    */

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

   /* 
 * "VerifyLand()" function verifies a Verify Land.
*  Only the Land Inspector can execute this function.
*  It checks if the land is not already registered, sets "isVerified" to true if not, and logs the registration.
* @param _id - for Land to verify
*/

    function VerifyLand(uint256 _id)
        public
        OnlyLandInspector
        LandNotRegistered(_id)
    {
        require(landlists[_id].isVerified == false, " Land Already Verified");
        landlists[_id].isVerified =true;
        emit Status("Land Has Been Verified", msg.sender);
    }

    
   /* 
* "LandAvailables()" returns an array of land IDs for all available lands in the contract.
*  It's a read-only function accessible by any user using the "view" keyword.
*/

    function LandAvailables() public view returns (uint256[] memory) {
        return LandAvailable;
    }


   
  /* 
* "The "GetLandDetail()" function retrieves detailed information about a specific land, including its ID, seller address, location, price, and availability status.
*  It uses the "view" keyword to ensure it is read-only and verifies that the land is registered using the "LandNotRegistered()" modifier.
*  This ensures that the land ID exists in the contract and prevents errors.
*/
  
    function GetLandDetail(uint256 _id)
        public
        view
        LandNotRegistered(_id)
        returns (landDetail memory)
    {
        return landlists[_id];
    }









     /*
     * @dev BuyLand()  is used to Sell Land.
     * Requirement:
     * - This function can be called by  verified Buyyer only 
     * - Verify that the land and buyer are verified and registered  
     * - Verify that the amount of ether sent by the buyer is greater than zero
     * -Verify that the buyer is not already the owner of the land
     * -Verify that the amount of ether sent by the buyer is equal to the land price
     * -Transfer the ether to the land owner and change the ownership in the mapping

     * @param _LandId - _LandId   for land detail
    
     *
     * Emits a {Status} event.
    */

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
        require(landlists[_landid].LandPrice == msg.value," Please Enter Correct Amount") ;    // if Contract Balance equal Land Price than then If bOdy Execeute 
        (bool transactionStatus , bytes memory _respond) = payable(landlists[_landid].LandOwner).call{value:msg.value,gas:2000}("");            //     Transfer Landprice to Current Owner
            landlists[_landid].LandOwner = msg.sender;                // Change Ownership in Landlist Mapping
             respond = _respond;                                 // get respond save in state varables
            require(transactionStatus,"Transaction Failed");  
            emit Status("Ownership has been Changed", msg.sender);     // Event Call                
    }
}
