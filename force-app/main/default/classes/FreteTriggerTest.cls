@isTest
private class FreteTriggerTest {
    @isTest static void FreteTriggerTest() {
        CentroDistribuicao__c cd = new CentroDistribuicao__c(
            Codigo__c = 'teste',
            Name = 'cd teste'
        );
        insert cd;
        
        Frete__c frete = new Frete__c(
            CentroDistribuicao__c = cd.Id,
            Name = 'frete teste',
            Status__c = 'Aprovado',
            Valor__c = 10
        );
        // Perform test
        Test.startTest();
        insert frete;
        Test.stopTest();
        // Verify
        System.assertEquals(1, [SELECT count() from Frete__c]);
    }
}

