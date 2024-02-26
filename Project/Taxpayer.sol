pragma solidity ^0.8.22;


contract Taxpayer {

    uint age; 

    bool isMarried; 

    /* Reference to spouse if person is married, address(0) otherwise */
    address spouse; 

    address parent1; 
    address parent2; 

    /* Constant default income tax allowance */
    uint constant  DEFAULT_ALLOWANCE = 5000;

    /* Constant income tax allowance for Older Taxpayers over 65 */
    uint constant ALLOWANCE_OAP = 7000;

    /* Income tax allowance */
    uint tax_allowance; 

    uint income; 

    constructor(address p1, address p2) {
        require(p1 != p2 || p1 == address(0), "Parents cannot be the same");
        age = 0;
        isMarried = false;
        parent1 = p1;
        parent2 = p2;
        spouse = address(0);
        income = 0;
        tax_allowance = DEFAULT_ALLOWANCE;
    } 
 
    function marry(Taxpayer new_spouse_tp) public {
        address new_spouse = address(new_spouse_tp); 
        require(new_spouse != address(0), "You cannot spose address 0x0");
//        require(new_spouse != address(parent1) && new_spouse != address(parent2), "You cannot spose your parent 1");
        require(new_spouse != address(this), "You cannot marry with yourself");
        require(!getIsMarried(), "You are already married, be faithful");
        require(age > 17, "You have to be 18 years old or more to marry");
        spouse = new_spouse;
        isMarried = true;
        if (new_spouse_tp.getSpouse() != address(this)){
            new_spouse_tp.marry(this);
        }      
        return;
    }
    function divorce() public {
        require(isMarried, "You have to be married to divorce");
        Taxpayer sp = Taxpayer(address(spouse));
        spouse = address(0);
        isMarried = false;

        tax_allowance = getBaseTaxAllowance();
        tax_allowance = 5000;
        if (sp.getIsMarried()) {
            sp.divorce();
        }
    }

    /* Transfer part of tax allowance to own spouse */
    function transferAllowance(uint change) public {
        require(tax_allowance >= change, "You cannot have a negative tax allowance");
        tax_allowance = tax_allowance - change;
        Taxpayer sp = Taxpayer(address(spouse));
        sp.setTaxAllowance(sp.getTaxAllowance()+change);
    }

    function haveBirthday() public {
        age++;
        if (age == 65) {
            tax_allowance += ALLOWANCE_OAP - DEFAULT_ALLOWANCE;
        }
    }

    function getSpouse() public view returns (address) {
        return spouse;
    }

    function getIsMarried() public view returns (bool) {
        return isMarried;
    }

    function getAge() public view  returns (uint) {
        return age;
    }

    function setTaxAllowance(uint ta) public {
        require(msg.sender == spouse);
        tax_allowance = ta;
    }

    function getTaxAllowance() public view returns (uint) {
        return tax_allowance;
    }

    function getBaseTaxAllowance() public view returns (uint) {
        if (age < 65) {
            return DEFAULT_ALLOWANCE;
        }
        else {
            return ALLOWANCE_OAP;
        }
    }

    function getParents() public view returns (address, address) {
        return (parent1, parent2);
    }

    function addIncome(uint new_income) public {
        income += new_income;
    }

    function resetIncome() public {
        income = 0;
    }

    function getTaxableIncomes() public view returns (uint){
        if (income > tax_allowance) {
            return income - tax_allowance;
        }
        else {
            return 0;
        }
    }
}