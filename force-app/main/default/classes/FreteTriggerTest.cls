@isTest
private class FreteTriggerTest {
    @isTest static void FreteTriggerInsertTest() {
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

        
        Frete__c frete = new Frete__c(
            CentroDistribuicao__c = cd.Id,
            Name = 'Frete teste',
            Status__c = 'Aprovado',
            Valor__c = 10,
            Produto__c = produto.Id,
            Cidade__c = cidade.Id
            //Estado__c = estado.Id
            //Pais__c = pais.Id
        );

        // Perform test
        Test.startTest();
        insert frete;
        Test.stopTest();
        // Verify
        System.assertEquals(1, [SELECT count() from Frete__c]);
    }

    @isTest static void FreteTriggerUpdateTest() {
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

        
        Frete__c frete = new Frete__c(
            CentroDistribuicao__c = cd.Id,
            Name = 'Frete teste',
            Status__c = 'Aprovado',
            Valor__c = 10,
            Produto__c = produto.Id,
            Cidade__c = cidade.Id
            //Estado__c = estado.Id
            //Pais__c = pais.Id
        );
        insert frete;

        Frete__c freteInserted = [
            SELECT Id, Name, Status__c
            FROM Frete__c
            WHERE Status__c = 'Aprovado'
        ];

        freteInserted.Status__c = 'Bloqueado';

        // Perform test
        Test.startTest();
        update freteInserted;
        Test.stopTest();
        // Verify
        System.assertEquals(1, [SELECT count() from Frete__c WHERE Status__c = 'Bloqueado']);
    }

    @isTest static void FreteTriggerDuplicateTest() {
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

        
        Frete__c frete = new Frete__c(
            CentroDistribuicao__c = cd.Id,
            Name = 'Frete teste',
            Status__c = 'Aprovado',
            Valor__c = 10,
            Produto__c = produto.Id,
            Cidade__c = cidade.Id
            //Estado__c = estado.Id
            //Pais__c = pais.Id
        );

        Frete__c freteDuplicate = new Frete__c(
            CentroDistribuicao__c = cd.Id,
            Name = 'Frete teste',
            Status__c = 'Aprovado',
            Valor__c = 10,
            Produto__c = produto.Id,
            Cidade__c = cidade.Id
            //Estado__c = estado.Id
            //Pais__c = pais.Id
        );

        Exception error;

        // Perform test
        Test.startTest();
        insert frete;
        try {
            insert freteDuplicate;
        } catch (Exception e) {
            error = e;
        }
        Test.stopTest();
        // Verify
        System.assertEquals(1, [SELECT count() from Frete__c]);
        if(error.getMessage() != null){
            System.assert(error.getMessage().contains(System.Label.FreteDuplicado));
        }
    }
}

