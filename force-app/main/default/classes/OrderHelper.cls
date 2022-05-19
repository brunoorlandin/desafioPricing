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
            }

            if(order.EnderecoConta__r.Cidade__c != oldOrder.EnderecoConta__r.Cidade__c){
                orderIds.add(order.Id);
            }

            if(order.EnderecoConta__r.Cidade__r.Estado__c != oldOrder.EnderecoConta__r.Cidade__r.Estado__c){
                orderIds.add(order.Id);
            }

            if(order.EnderecoConta__r.Cidade__r.Estado__r.Pais__c != oldOrder.EnderecoConta__r.Cidade__r.Estado__r.Pais__c){
                orderIds.add(order.Id);
            }
        }

        List<Orderitem> orderItemList = [
            SELECT Id, Desconto__c, PorcentagemImposto__c, PorcentagemMargem__c, PrecoFinal__c, PrecoSemMargem__c, ValorFrete__c, ListPrice, UnitPrice
            FROM OrderItem
            WHERE OrderId IN: orderIds
        ];

        List<OrderItem> updatedOrderItemList = OrderItemHelper.calculateFinalPrice(orderItemList);

        return updatedOrderItemList;
    }
}
