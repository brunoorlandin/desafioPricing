@isTest
private class OrderItemTriggerTest {
    @isTest static void OrderItemTriggerTest() {
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
            CNPJ__c = '00360305000104',
            GrupoConta__c = grupoConta.Id
        );
        insert acc;

        Contract contract = new Contract(
            Name = 'Contrato teste',
            Status = 'Draft',
            StartDate = System.today(),
            ContractTerm = 6,
            AccountId = acc.Id
        );
        insert contract;

        CondicaoPagamento__c condPag = new CondicaoPagamento__c(
            Name = 'Condição de pagamento teste',
            Codigo__c = 'teste'
        );
        insert condPag;

        EnderecoConta__c ed = new EnderecoConta__c(
            Name = 'Endereço teste',
            Conta__c = acc.Id,
            Logradouro__c = 'Rua teste, 99',
            CEP__c = '00000000',
            Bairro__c = 'Bairro Teste',
            Codigo__c = 'teste',
            Cidade__c = cidade.Id
        );
        insert ed;

        Individual individual = new Individual(
            LastName = 'Teste'
        );
        insert individual;

        Customer cliente = new Customer(
            PartyId = individual.Id,
            Name = 'Cliente teste'
        );
        insert cliente;

        Product2 product = new Product2(
            Name = 'Produto Teste',
            CustoProducao__c = 10,
            CodigoProduto__c = 'teste',
            HierarquiaProduto__c = hp.Id
        );
        insert product;

        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        Update standardPricebook;

        standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];

        PricebookEntry pricebookEntry = new PricebookEntry(
            Product2Id = product.id,
            UnitPrice = 10,
            Pricebook2Id = standardPricebook.Id,
            IsActive = true
        );
        insert pricebookEntry;

        Order order = new Order(
            Name = 'Pedido teste',
            AccountId = acc.Id,
            EffectiveDate = System.today(),
            ContractId = contract.Id,
            Status = 'Draft',
            TipoFrete__c = 'CIF',
            CentroDistribuicao__c = cd.Id,
            EnderecoConta__c = ed.Id,
            DataEntrega__c = System.today() + 10,
            Cliente__c = cliente.Id,
            CondicaoPagamento__c = condPag.Id,
            Pricebook2Id = standardPricebook.Id
        );
        insert order;

        OrderItem orderItem = new OrderItem(
            OrderId = order.Id,
            Product2Id = product.Id,
            ListPrice = 10,
            UnitPrice = 12,
            Quantity = 2,
            PricebookEntryId = pricebookEntry.Id
        );

        // Margem__c margem = new Margem__c(
        //     CentroDistribuicao__c = cd.Id,
        //     Name = 'Margem teste',
        //     GrupoConta__c = grupoConta.Id,
        //     // Conta__c = acc.Id,
        //     Status__c = 'Aprovado',
        //     Valor__c = 10,
        //     Produto__c = produto.Id,
        //     Cidade__c = cidade.Id
        //     // Estado__c = estado.Id
        //     //Pais__c = pais.Id
        // );

        // Perform test
        Test.startTest();
        insert orderItem;
        Test.stopTest();
        // Verify
        System.assertEquals(1, [SELECT count() from OrderItem]);
    }
}
