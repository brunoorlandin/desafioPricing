public with sharing class OrderItemHelper {
    public OrderItemHelper() {}

    public static void validateFields(List<OrderItem> orderItemList){
        for(OrderItem orderItem: orderItemList){
            if (orderItem.Quantity <= 0){
                orderItem.addError(System.Label.OrderItemQuantityError);

            }
            else if (orderItem.UnitPrice <=0){
                orderItem.addError(System.Label.OrderItemPriceError);

            }
        }
    }

    public static void calculateFinalPrice(List<OrderItem> newOrderItemList){
        Set<Id> orderIdSet = new Set<Id>();
        Set<Id> productIdSet = new Set<Id>();

        for(OrderItem orderItem : newOrderItemList){
            orderIdSet.add(orderItem.OrderId);
            productIdSet.add(orderItem.Product2Id);
        }

        Map<Id, Order> orderMap = new Map<Id, Order>([
            SELECT Id, AccountId, Account.GrupoConta__c, CentroDistribuicao__c ,EnderecoConta__r.Cidade__c, EnderecoConta__r.Cidade__r.Estado__c, EnderecoConta__r.Cidade__r.Estado__r.Pais__c
            FROM Order
            WHERE Id IN: orderIdSet
        ]);

        Map<Id, Product2> productMap = new Map<Id, Product2>([
            SELECT Id, HierarquiaProduto__c, CustoProducao__c
            FROM Product2
            WHERE Id IN: productIdSet
        ]);

        Map<OrderItem, Frete__c> orderItemToFreteMap = searchFrete(newOrderItemList, orderMap, productMap);
    }

    public static Map<OrderItem, Frete__c> searchFrete(
        List<OrderItem> newOrderItemList,
        Map<Id, Order> orderMap,
        Map<Id, Product2> productMap
    ){
        Set<Id> dcIds = new Set<Id>();
        Set<Id> cityIds = new Set<Id>();
        Set<Id> stateIds = new Set<Id>();
        Set<Id> countryIds = new Set<Id>();
        Set<Id> hierarchyIds = new Set<Id>();
        Set<Id> productIds = new Set<Id>();
        
        for(Order order : orderMap.values()){
            dcIds.add(order.CentroDistribuicao__c);
            cityIds.add(order.EnderecoConta__r.Cidade__c);
            stateIds.add(order.EnderecoConta__r.Cidade__r.Estado__c);
            countryIds.add(order.EnderecoConta__r.Cidade__r.Estado__r.Pais__c);
        }

        for(Product2 product : productMap.values()){
            productIds.add(product.Id);
            hierarchyIds.add(product.HierarquiaProduto__c);
        }

        List<Frete__c> freteList = [
            SELECT Id, HierarquiaProduto__c, Produto__c, CentroDistribuicao__c, Status__c, Valor__c, Cidade__c, Estado__c, Pais__c, Score__c
            FROM Frete__c
            WHERE (Produto__c IN: productIds OR Produto__c = null) AND
            (HierarquiaProduto__c IN: hierarchyIds OR HierarquiaProduto__c = null) AND
            (CentroDistribuicao__c IN: dcIds OR CentroDistribuicao__c = null) AND
            (Cidade__c IN: cityIds OR Cidade__c = null) AND
            (Estado__c IN: stateIds OR Estado__c = null) AND
            (Pais__c IN: countryIds OR Pais__c = null) AND
            (Status__c = 'Aprovado')
            ORDER BY Score__c DESC
        ];

        Map<OrderItem, Frete__c> orderItemToFrete = new Map<OrderItem, Frete__c>();

        for(OrderItem orderItem : newOrderItemList){
            orderItemToFrete.put(orderItem, null);

            for(Frete__c frete : freteList){
                if(matchFrete(frete, orderItem, orderMap, productMap)){
                    orderItemToFrete.put(orderItem, frete);
                    break;
                }
            }
        }

        return orderItemToFrete;
    }

    public static Boolean matchFrete(
        Frete__c frete,
        OrderItem orderItem,
        Map<Id, Order> orderMap,
        Map<Id, Product2> productMap
    ){
        return (String.isBlank(frete.Produto__c) || frete.Produto__c == orderItem.Product2Id) &&
        (String.isBlank(frete.HierarquiaProduto__c) || frete.HierarquiaProduto__c == productMap.get(orderItem.Product2Id).HierarquiaProduto__c) &&
        (String.isBlank(frete.CentroDistribuicao__c) || frete.CentroDistribuicao__c == orderMap.get(orderItem.OrderId).CentroDistribuicao__c) &&
        (String.isBlank(frete.Cidade__c) || frete.Cidade__c == orderMap.get(orderItem.OrderId).EnderecoConta__r.Cidade__c) &&
        (String.isBlank(frete.Estado__c) || frete.Estado__c == orderMap.get(orderItem.OrderId).EnderecoConta__r.Cidade__r.Estado__c) &&
        (String.isBlank(frete.Pais__c) || frete.Pais__c == orderMap.get(orderItem.OrderId).EnderecoConta__r.Cidade__r.Estado__r.Pais__c);
    }

    public static Map<OrderItem, Margem__c> searchMargin(
        List<OrderItem> newOrderItemList,
        Map<Id, Order> orderMap,
        Map<Id, Product2> productMap
    ){
        Set<Id> accountsIds = new Set<Id>();
        Set<Id> accountGroupIds = new Set<Id>();
        Set<Id> dcIds = new Set<Id>();
        Set<Id> cityIds = new Set<Id>();
        Set<Id> stateIds = new Set<Id>();
        Set<Id> countryIds = new Set<Id>();
        Set<Id> hierarchyIds = new Set<Id>();
        Set<Id> productIds = new Set<Id>();
        
        for(Order order : orderMap.values()){
            accountsIds.add(order.AccountId);
            accountGroupIds.add(order.Account.GrupoConta__c);
            dcIds.add(order.CentroDistribuicao__c);
            cityIds.add(order.EnderecoConta__r.Cidade__c);
            stateIds.add(order.EnderecoConta__r.Cidade__r.Estado__c);
            countryIds.add(order.EnderecoConta__r.Cidade__r.Estado__r.Pais__c);
        }

        for(Product2 product : productMap.values()){
            productIds.add(product.Id);
            hierarchyIds.add(product.HierarquiaProduto__c);
        }

        List<Margem__c> margemList = [
            SELECT Id, Conta__c, GrupoConta__c, HierarquiaProduto__c, Produto__c, CentroDistribuicao__c, Status__c, Valor__c, Cidade__c, Estado__c, Pais__c, Score__c
            FROM Margem__c
            WHERE (Produto__c IN: productIds OR Produto__c = null) AND
            (Conta__c IN: accountsIds OR Conta__c = null) AND
            (GrupoConta__c IN: accountGroupIds OR GrupoConta__c = null) AND
            (HierarquiaProduto__c IN: hierarchyIds OR HierarquiaProduto__c = null) AND
            (CentroDistribuicao__c IN: dcIds OR CentroDistribuicao__c = null) AND
            (Cidade__c IN: cityIds OR Cidade__c = null) AND
            (Estado__c IN: stateIds OR Estado__c = null) AND
            (Pais__c IN: countryIds OR Pais__c = null) AND
            (Status__c = 'Aprovado')
            ORDER BY Score__c DESC
        ];

        Map<OrderItem, Margem__c> orderItemToMargem = new Map<OrderItem, Margem__c>();

        for(OrderItem orderItem : newOrderItemList){
            orderItemToMargem.put(orderItem, null);

            for(Margem__c margem : margemList){
                if(matchMargin(margem, orderItem, orderMap, productMap)){
                    orderItemToMargem.put(orderItem, margem);
                    break;
                }
            }
        }

        return orderItemToMargem;
    }

    public static Boolean matchMargin(
        Margem__c margem,
        OrderItem orderItem,
        Map<Id, Order> orderMap,
        Map<Id, Product2> productMap
    ){
        return (String.isBlank(margem.Conta__c) || margem.Conta__c == orderMap.get(orderItem.OrderId).AccountId) &&
        (String.isBlank(margem.Produto__c) || margem.Produto__c == orderMap.get(orderItem.OrderId).Account.GrupoConta__c) &&
        (String.isBlank(margem.Produto__c) || margem.Produto__c == orderItem.Product2Id) &&
        (String.isBlank(margem.HierarquiaProduto__c) || margem.HierarquiaProduto__c == productMap.get(orderItem.Product2Id).HierarquiaProduto__c) &&
        (String.isBlank(margem.CentroDistribuicao__c) || margem.CentroDistribuicao__c == orderMap.get(orderItem.OrderId).CentroDistribuicao__c) &&
        (String.isBlank(margem.Cidade__c) || margem.Cidade__c == orderMap.get(orderItem.OrderId).EnderecoConta__r.Cidade__c) &&
        (String.isBlank(margem.Estado__c) || margem.Estado__c == orderMap.get(orderItem.OrderId).EnderecoConta__r.Cidade__r.Estado__c) &&
        (String.isBlank(margem.Pais__c) || margem.Pais__c == orderMap.get(orderItem.OrderId).EnderecoConta__r.Cidade__r.Estado__r.Pais__c);
    }
}
