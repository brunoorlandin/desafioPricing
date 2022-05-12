@isTest 
private class MargemTriggerTest {
    @isTest static void MargemTriggerInsertTest() {
        CentroDistribuicao__c cd = new CentroDistribuicao__c(
            Codigo__c = 'teste',
            Name = 'cd teste'
        );
        insert cd;

        HierarquiaProduto__c hp = new HierarquiaProduto__c(
            Name = 'Graos',
            Codigo__c = 'teste'
        );
        insert hp;

        Product2 produto = new Product2(
            Name = 'Arroz',
            CustoProducao__c = 10,
            CodigoProduto__c = 'A10',
            HierarquiaProduto__c = hp.Id
        );
        insert produto;

        Pais__c pais = new Pais__c(
            Name = 'Brasil',
            Sigla__c = 'BR'
        );
        insert pais;

        Estado__c estado = new Estado__c(
            Name = 'São Paulo',
            Pais__c = pais.Id,
            Sigla__c = 'SP'
        );
        insert estado;

        Cidade__c cidade = new Cidade__c(
            Name = 'São Bernardo do Campo',
            Estado__c = estado.Id,
            CodigoIBGE__c = 'SBC'
        );
        insert cidade;

        GrupoConta__c grupoConta = new GrupoConta__c(
            Name = 'Grupo de conta teste',
            Codigo__c = 'ABC'
        );
        
        Account acc = new Acount(
            Name = 'Account teste',
            CNPJ__c = 'XX.XXX.XXX/0001-XX',
            GrupoConta__c = grupoConta.Id
        );

        Margem__c margem = new Margem__c(
            CentroDistribuicao__c = cd.Id,
            Name = 'Margem teste',
            Conta__c = acc.Id,
            Status__c = 'Aprovado',
            Valor__c = 10,
            Produto__c = produto.Id,
            Cidade__c = cidade.Id
            //Estado__c = estado.Id
            //Pais__c = pais.Id
        );

        // Perform test
        Test.startTest();
        insert margem;
        Test.stopTest();
        // Verify
        System.assertEquals(1, [SELECT count() from Margem__c]);
    }
}
