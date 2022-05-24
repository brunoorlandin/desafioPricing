public with sharing class OrderHelper {
    public OrderHelper() {}

    public static void validateOrder(
        Map<Id, Order> oldOrderMap,
        Map<Id, Order> newOrderMap){
        for(Order order : newOrderMap.values()){
            Order oldOrder = oldOrderMap.get(order.Id);

            if(order.AccountId != oldOrder.AccountId){
                order.addError(System.Label.ContaAtt);
            }

            if(order.Status == 'Activated' && oldOrder.Status == 'Activated'){
                order.addError(System.Label.StatusPedido);
            }
        }
    }

    public static List<OrderItem> checkRecalcOrderItems(
        Map<Id, Order> oldOrderMap,
        Map<Id, Order> newOrderMap
    ){
        Set<Id> orderIds = new Set<Id>();

        for(Order order : newOrderMap.values()){
            Order oldOrder = oldOrderMap.get(order.Id);

            if(order.CentroDistribuicao__c != oldOrder.CentroDistribuicao__c){
                orderIds.add(order.Id);
                System.debug('Alteração no CD');
            }
            if(order.EnderecoConta__c != oldOrder.EnderecoConta__c){
                orderIds.add(order.Id);
                System.debug('Alteração no endereço da conta');
            }
        }

        List<Orderitem> orderItemList = [
            SELECT Id, OrderItem.OrderId, OrderItem.Product2Id, Desconto__c, PorcentagemImposto__c, PorcentagemMargem__c, PrecoFinal__c, PrecoSemMargem__c, ValorFrete__c, ListPrice, UnitPrice
            FROM OrderItem
            WHERE OrderId IN: orderIds
        ];

        System.debug('List de pedido => ' + orderItemList);

        List<OrderItem> updatedOrderItemList = OrderItemHelper.calculateFinalPrice(orderItemList);

        System.debug('Lista de pedidos recalculada => ' + updatedOrderItemList);

        return updatedOrderItemList;
    }
}
