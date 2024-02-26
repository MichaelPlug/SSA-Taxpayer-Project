// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "./Taxpayer.sol"; 

contract TaxpayerTesting is Taxpayer(address(0), address(0)) {
   Taxpayer alpha;
    
    constructor() {
        alpha = new Taxpayer(address(0), address(0));
    }

    function echidna_marry() public view returns (bool) {   
        return ((getSpouse() != address(0) && getIsMarried())|| getSpouse() == address(0) && !getIsMarried());
    }

    function echidna_marry_monogamy_and_reflexive_relation() public view returns (bool) {
        bool self_test = true;
        bool alpha_test = true;
        if (getIsMarried()) {
            Taxpayer spouse =Taxpayer(getSpouse());
            self_test = Taxpayer(spouse).getSpouse() == address(this) &&
                Taxpayer(spouse).getIsMarried();
        }

        if (alpha.getIsMarried()) {
            Taxpayer spouse =Taxpayer(alpha.getSpouse());
            alpha_test = Taxpayer(spouse).getSpouse() == address(alpha) &&
                Taxpayer(spouse).getIsMarried();
        }
        return self_test && alpha_test;
    }   

    function marry_alpha() public {
        marry(alpha);
    }

    function echidna_marry_age_limits() public view returns (bool) {
        if (getIsMarried()) {
            return getAge() > 17 && Taxpayer(getSpouse()).getAge() >= 17;
        }
        return true;
    }


    function echidna_spouse_is_different() public view returns (bool) {
        return getSpouse() != address(this);
    }

/*
    function echidna_couple_make_a_baby() public returns (bool) {
        try new Taxpayer(address(alpha), address(beta)) {
            return true;
        } catch {
            return false;
        }
    }
    
    */

    function echidna_divorce() public  returns (bool) {  
        if (getIsMarried()) {
            Taxpayer spouse = Taxpayer(getSpouse());
            divorce();

            return Taxpayer(spouse).getSpouse() == address(0) && !Taxpayer(spouse).getIsMarried() && getSpouse() == address(0) && !getIsMarried();
        } 
        return true;
    }

/*
    function echidna_cumulative_tax_allowance() public view returns (bool){
    if (getIsMarried()){
        Taxpayer spouse = Taxpayer(getSpouse());
        return (getTaxAllowance() + spouse.getTaxAllowance() == 10000);
    }
    else {
        return (getTaxAllowance() == 5000);
    }

*/
    function echidna_cumulative_tax_allowance() public view returns (bool){
        if (getIsMarried()){
            Taxpayer spouse = Taxpayer(getSpouse());
            return (getTaxAllowance() + spouse.getTaxAllowance() == getBaseTaxAllowance() + spouse.getBaseTaxAllowance());
        }
        else {
            return (getTaxAllowance() == getBaseTaxAllowance());
        }
    }

    function echidna_allowance_AOP() public view returns (bool) {
        if (getAge() < 65 && getBaseTaxAllowance() != 5000){
            return false;
        }
        if (getAge() >= 65 && getBaseTaxAllowance() != 7000){
            return false;
        }
        return true;
    }

    function getting_old(Taxpayer test_tp) public {
        for (uint i = 0; i < 15; i++){
            test_tp.haveBirthday();
        }
    }

    function im_getting_old() public {
        for (uint i = 0; i < 15; i++){
            haveBirthday();
        }
    }

    function force_marry(Taxpayer adamo, Taxpayer eva) public {
        adamo.marry(eva);
    }
/*
    function force_divorce(Taxpayer adamo) public {
        adamo.divorce();
    }
*/
/*
    function new_alpha() public {
        alpha = new Taxpayer(address(alpha), address(beta));
    }

    function new_beta() public {
        beta = new Taxpayer(address(alpha), address(beta));
    }

    function create_brothers() public {
        Taxpayer temp_alpha = new Taxpayer(address(alpha), address(beta));
        Taxpayer temp_beta = new Taxpayer(address(beta), address(alpha));
        alpha = temp_alpha;
        beta = temp_beta;
    }

    function new_alpha_orfano() public {
        alpha = new Taxpayer(address(alpha), address(0));
    }

    function new_beta_orfano() public {
        alpha = new Taxpayer(address(beta), address(0));
    }
    */
}
/*
    function echidna_spouse_is_taxpayer() public view returns (bool) {
        if (alpha.getIsMarried()) {
            Taxpayer spouse = Taxpayer(alpha.getSpouse());
            Taxpayer spouse2= Taxpayer(address(0));
            spouse2.getAge();
        }
        return true;
    }
    */

/*
    function echidna_tranferability_tax_allowance(uint change) public {
        tax_allowance = alpha.getTaxAllowance();
        if (!alpha.getIsMarried()) { 
            alpha.transferAllowance(change);
            assert (alpha.getTaxAllowance() == alpha.getBaseTaxAllowance());
            return;
        }
        
        Taxpayer spouse = Taxpayer(alpha.getSpouse());
        uint spuse_ta = spouse.getTaxAllowance();
        
        if (tax_allowance > change) {
            assert (alpha.getTaxAllowance() == tax_allowance - change);
            assert (spouse.getTaxAllowance() == spuse_ta + change);
        } else {
            assert (alpha.getTaxAllowance() == tax_allowance);
            assert (spouse.getTaxAllowance() == spuse_ta);
        }

    }
    */

    