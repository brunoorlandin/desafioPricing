public with sharing class OrderHelper {
    public OrderHelper() {}

    public static void validateOrder(
        Map<Id, Order> oldRecords,
        Map<Id, Order> newRecords){
        for(Order order : newRecords.values()){
            Order oldOrder = oldRecords.get(order.Id);

            if(order.AccountId != oldOrder.AccountId){
                order.addError(System.Label.ContaAtt);
            }

            if(order.Status == 'Activated' && oldOrder.Status == 'Activated'){
                order.addError(System.Label.StatusPedido);
            }
        }
    }
}
