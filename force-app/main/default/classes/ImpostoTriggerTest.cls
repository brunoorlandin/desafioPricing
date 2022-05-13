@isTest
private class ImpostoTriggerTest {
    @isTest static void ImpostoTriggerInsertTest() {
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

        Pais__c pais = new Pais__c(
            Name = 'Brasil',
            Sigla__c = 'BR'
        );
        insert pais;
        
        Product2 produto = new Product2(
            Name = 'Arroz',
            CustoProducao__c = 10,
            CodigoProduto__c = 'A10',
            HierarquiaProduto__c = hp.Id
        );
        insert produto;

        Estado__c estado = new Estado__c(
            Name = 'São Paulo',
            Pais__c = pais.Id,
            Sigla__c = 'SP'
        );
        insert estado;

        Imposto__c imposto = new Imposto__c(
            Name = 'Imposto teste',
            CentroDistribuicao__c = cd.Id,
            Produto__c = produto.Id,
            Estado__c = estado.Id,
            Status__c = 'Aprovado',
            ImpostoSobreCusto__c = 1.05
        );

        Imposto__c impostoWithoutProduct = new Imposto__c(
            Name = 'Imposto teste',
            CentroDistribuicao__c = cd.Id,
            Estado__c = estado.Id,
            Status__c = 'Aprovado',
            ImpostoSobreCusto__c = 1.05
        );

        Imposto__c impostoDuplicate = new Imposto__c(
            Name = 'Imposto teste 2',
            CentroDistribuicao__c = cd.Id,
            Produto__c = produto.Id,
            Estado__c = estado.Id,
            Status__c = 'Aprovado',
            ImpostoSobreCusto__c = 1.05
        );

        Exception error;
        Exception duplicateError;

        // Perform test
        Test.startTest();
        insert imposto;
        try {
            insert impostoWithoutProduct;
        } catch (Exception e) {
            error = e;
        }
        try {
            insert impostoDuplicate;
        } catch (Exception e) {
            duplicateError = e;
        }
        Test.stopTest();
        // Verify
        System.assertEquals(1, [SELECT count() from Imposto__c]);
        if(error.getMessage() != null){
            System.assert(error.getMessage().contains(System.Label.ProdutoVazio));
        }
        if(duplicateError.getMessage() != null){
            System.assert(duplicateError.getMessage().contains(System.Label.ImpostoDuplicado));
        }
    }
}
