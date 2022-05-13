public with sharing class AccountHelper {
    public AccountHelper() {}

    public static void checkCNPJ(List<Account> accountList){
        for(Account acc : accountList){
            String cnpj = acc.CNPJ__c;
            String firstDigitString = cnpj.substring(cnpj.length() - 2, cnpj.length() - 1);
            String secondDigitString = cnpj.substring(cnpj.length() - 1);

            Integer firstDigit = Integer.valueOf(firstDigitString);
            Integer secondDigit = Integer.valueOf(secondDigitString);

            if(cnpj.length() < 14){
                acc.addError(System.Label.IncorrectCNPJ);
            }

            List<Integer> digitList = new List<Integer>();

            for(integer i = 0; i < cnpj.length() - 2; i++){
                String digit = cnpj.substring(i, i+1);
                Integer digitInt = Integer.valueOf(digit);

                digitList.add(digitInt);
            }

            Integer weight = 5;
            Integer sum = 0;

            for(integer i = 0; i < digitList.size(); i++){
                Integer digit = digitList[i];
                Integer result = digit * weight;
                sum = sum + result;
                if(weight == 2){
                    weight = 10;
                }
                weight = weight - 1;
            }

            Integer remainder = math.mod(sum, 11);

            Integer calculatedFirstDigit1 = 11 - remainder;

            if(remainder < 2){
                calculatedFirstDigit1 = 0;
            }

            if(firstDigit != calculatedFirstDigit1){
                acc.addError(System.Label.IncorrectCNPJ);
            }

            digitList.add(calculatedFirstDigit1);

            weight = 6;
            sum = 0;

            for(integer i = 0; i < digitList.size(); i++){
                Integer digit = digitList[i];
                Integer result = digit * weight;
                sum = sum + result;
                if(weight == 2){
                    weight = 10;
                }
                weight = weight - 1;
            }

            remainder = math.mod(sum, 11);

            Integer calculatedSecondDigit = 11 - remainder;

            if(remainder < 2){
                calculatedSecondDigit = 0;
            }

            if(secondDigit != calculatedSecondDigit){
                acc.addError(System.Label.IncorrectCNPJ);
            }
        }
    }
}
