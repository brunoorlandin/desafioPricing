@isTest
private  class AccountTriggerTest {
    @isTest static void AccountTriggerInsertTest() {
        GrupoConta__c grupoConta = new GrupoConta__c(
            Name = 'Grupo de conta teste',
            Codigo__c = 'ABC'
        );
        insert grupoConta;
        
        Account acc = new Account(
            Name = 'Account teste',
            CNPJ__c = '00360305000104',
            GrupoConta__c = grupoConta.Id
        );

        Account invalidAcc = new Account(
            Name = 'Account teste',
            CNPJ__c = '11444777000123',
            GrupoConta__c = grupoConta.Id
        );

        Exception error;
        
        // Perform test
        Test.startTest();
        insert acc;
        try {
            insert invalidAcc;
        } catch (Exception e) {
            error = e;
        }
        Test.stopTest();
        // Verify
        System.assertEquals(1, [SELECT count() from Account]);
        if(error.getMessage() != null){
            System.assert(error.getMessage().contains(System.Label.IncorrectCNPJ));
        }
    }
}
