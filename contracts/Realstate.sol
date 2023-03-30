// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

contract Realstate {
    struct landDetail {
        uint256 LandId;
        address LandOwner;
        string Area;
        string City;
        string State;
        uint256 LandPrice;
        bool isVerified;
    }

    mapping(uint256 => landDetail) landlists;
    uint[] LandAvailable ;

    struct SellerDetail {
        address Seller_address;
        string Name;
        uint8 Age;
        string City;
        string CNIC;
        string Email;
        bool isVerified;
    }

    mapping(address => SellerDetail)  Sellerlist;

    struct BuyyerDetail {
        address Buyyer_address;
        string Name;
        uint8 Age;
        string City;
        string CNIC;
        string Email;
        bool isVerified;
    }

    mapping(address => BuyyerDetail) Buyyerlist;

    struct landInspectorDetail {
        address LandInspectorAddress;
        uint256 Id;
        string Name;
        uint8 Age;
        string Designation;
    }

    landInspectorDetail public Land_Inspector;

    modifier OnlyLandInspector() {
        require(
            Land_Inspector.LandInspectorAddress == msg.sender,
            "Only LandInspector Verify "
        );
        _;
    }

    modifier LandInspectorNotAllowed(){
        require(
            Land_Inspector.LandInspectorAddress != msg.sender,
            "LandInspector Not allowed"
        );
        _;
    } 
    
 event Status(string,address);





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
    ) public    LandInspectorNotAllowed { 


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

        emit Status("Seller Has Been Registered",msg.sender); 
    }

        function RegisterBuyyer(
        string memory _Name,
        uint8 _Age,
        string memory _City,
        string memory _CNIC,
        string memory _Email
    ) public     LandInspectorNotAllowed {   

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

        emit Status("Buyyer Has Been Registered",msg.sender); 

    }


      function VerifySeller(address _sellerAddress, bool permission)   OnlyLandInspector public {
    require(Sellerlist[_sellerAddress].Seller_address == _sellerAddress," Seller are not Registered");
        Sellerlist[_sellerAddress].isVerified = permission;
        emit Status("Seller Has Been Verified",msg.sender); 

    }

     function VerifyBuyyer(address _BuyyerAddress,bool permission)   OnlyLandInspector public {
    require(Buyyerlist[_BuyyerAddress].Buyyer_address == _BuyyerAddress,"Buyyer are not Registered");
        Buyyerlist[_BuyyerAddress].isVerified = permission;
        emit Status("Buyyer Has Been Registered",msg.sender); 

    }


         function GetSellerDetail(address _sellerAddress   ) public view  returns(SellerDetail memory ) {
    require(Sellerlist[_sellerAddress].Seller_address == _sellerAddress,"Seller are not Registered");

       return Sellerlist[_sellerAddress];
    } 

       function GetBuyyerDetail(address _BuyyerAddress   ) public view  returns(BuyyerDetail memory ) {
    require(Buyyerlist[_BuyyerAddress].Buyyer_address == _BuyyerAddress,"Buyyer are not Registered");

       return Buyyerlist[_BuyyerAddress];
    } 




    function AddLand(
        uint256 _LandId,
        string memory _Area,
        string memory _City,
        string memory _State,
        uint256 _LandPrice
       
    ) public  LandInspectorNotAllowed  {

        require (landlists[_LandId].LandId != _LandId ,"Land Already Registered" );
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
        emit Status("Land Has Been Added" ,msg.sender); 

    }

    function VerifyLand(uint _id, bool permission)    OnlyLandInspector public    {
    require(landlists[_id].LandId == _id,"Land are not Registered");   
    landlists[_id].isVerified = permission;
        emit Status("Land Has Been Verified" ,msg.sender); 

    } 

   
    function LandAvailables() public  view returns(uint[]  memory) {
        return LandAvailable;
    }

    function GetLandDetail(uint _id  ) public view  returns(landDetail memory ) {
    require(landlists[_id].LandId == _id,"Land are not Registered"); 
       return landlists[_id];
    } 
     


        function UpdateSeller(
        string memory _Name,
        uint8 _Age,
        string memory _City,
        string memory _CNIC,
        string memory _Email
    ) public    LandInspectorNotAllowed { 


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

        emit Status("Seller Has Been Updated" ,msg.sender); 

    }


       function UpdateBuyyer(
        string memory _Name,
        uint8 _Age,
        string memory _City,
        string memory _CNIC,
        string memory _Email
    ) public     LandInspectorNotAllowed {   

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
        emit Status("Buyyer Has Been Upadted " ,msg.sender); 

    }  
       
   function BuyLand(uint _landid)  LandInspectorNotAllowed  payable public {
       require(landlists[_landid].LandId == _landid , " Land are Not Registered"  );
        require(Sellerlist[msg.sender].Seller_address !=  msg.sender , " Only Buyyer Buy Land");
        require(Buyyerlist[msg.sender].Buyyer_address == msg.sender , " Buyyer are Not Registered" );
         
         require(landlists[_landid].LandPrice == address(this).balance , "Insufficient Amount");
         payable(landlists[_landid].LandOwner).transfer(address(this).balance);
         landlists[_landid].LandOwner == msg.sender;
         //hjhjh
   }

}
