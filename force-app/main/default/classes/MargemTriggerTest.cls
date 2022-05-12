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
        insert grupoConta;
        
        Account acc = new Account(
            Name = 'Account teste',
            CNPJ__c = 'XX.XXX.XXX/0001-XX',
            GrupoConta__c = grupoConta.Id
        );
        insert acc;

        Margem__c margem = new Margem__c(
            CentroDistribuicao__c = cd.Id,
            Name = 'Margem teste',
            GrupoConta__c = grupoConta.Id,
            // Conta__c = acc.Id,
            Status__c = 'Aprovado',
            Valor__c = 10,
            Produto__c = produto.Id,
            Cidade__c = cidade.Id
            // Estado__c = estado.Id
            //Pais__c = pais.Id
        );

        // Perform test
        Test.startTest();
        insert margem;
        Test.stopTest();
        // Verify
        System.assertEquals(1, [SELECT count() from Margem__c]);
    }

    @isTest static void MargemTriggerUpdateTest() {
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
        insert grupoConta;
        
        Account acc = new Account(
            Name = 'Account teste',
            CNPJ__c = 'XX.XXX.XXX/0001-XX',
            GrupoConta__c = grupoConta.Id
        );
        insert acc;

        Margem__c margem = new Margem__c(
            CentroDistribuicao__c = cd.Id,
            Name = 'Margem teste',
            GrupoConta__c = grupoConta.Id,
            // Conta__c = acc.Id,
            Status__c = 'Aprovado',
            Valor__c = 10,
            Produto__c = produto.Id,
            Cidade__c = cidade.Id
            // Estado__c = estado.Id
            //Pais__c = pais.Id
        );

        insert margem;

        Margem__c margemInseted = [
            SELECT Id, Name, Status__c
            FROM Margem__c
            WHERE Status__c = 'Aprovado'
            LIMIT 1
        ];

        margemInseted.Status__c = 'Bloqueado';

        // Perform test
        Test.startTest();
        update margemInseted;
        Test.stopTest();
        // Verify
        System.assertEquals(1, [SELECT count() from Margem__c WHERE Status__c = 'Bloqueado']);
    }

    @isTest static void MargemTriggerCheckDuplicatesTest() {
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
        insert grupoConta;
        
        Account acc = new Account(
            Name = 'Account teste',
            CNPJ__c = 'XX.XXX.XXX/0001-XX',
            GrupoConta__c = grupoConta.Id
        );
        insert acc;

        Margem__c margem = new Margem__c(
            CentroDistribuicao__c = cd.Id,
            Name = 'Margem teste',
            GrupoConta__c = grupoConta.Id,
            // Conta__c = acc.Id,
            Status__c = 'Aprovado',
            Valor__c = 10,
            Produto__c = produto.Id,
            Cidade__c = cidade.Id
            // Estado__c = estado.Id
            //Pais__c = pais.Id
        );

        Margem__c margemDuplicate = new Margem__c(
            CentroDistribuicao__c = cd.Id,
            Name = 'Margem teste',
            GrupoConta__c = grupoConta.Id,
            // Conta__c = acc.Id,
            Status__c = 'Aprovado',
            Valor__c = 10,
            Produto__c = produto.Id,
            Cidade__c = cidade.Id
            // Estado__c = estado.Id
            //Pais__c = pais.Id
        );

        Exception error;

        // Perform test
        Test.startTest();
        insert margem;
        try {
            insert margemDuplicate;
        } catch (Exception e) {
            error = e;
        }
        Test.stopTest();
        // Verify
        System.assertEquals(1, [SELECT count() from Margem__c]);
        if(error.getMessage() != null){
            System.assert(error.getMessage().contains(System.Label.MargemDuplicada));
        }
    }
}
