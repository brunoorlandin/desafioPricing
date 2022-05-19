public with sharing class OrderTriggerHandler {
    List<Order> oldRecords {get; set;}
    List<Order> newRecords {get; set;}
    Map<Id, Order> oldMap {get; set;}
    Map<Id, Order> newMap {get; set;}
    
    public OrderTriggerHandler(
        List<Order> oldRecords, 
        List<Order> newRecords, 
        Map<Id, Order> oldMap, 
        Map<Id, Order> newMap
    ) {
        this.oldRecords = oldRecords;
        this.newRecords = newRecords;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public void beforeInsert(){
        OrderHelper.validateOrder(this.oldMap, this.newMap);
    }

    public void beforeUpdate(){
        OrderHelper.validateOrder(this.oldMap, this.newMap);
    }

    public void afterUpdate(){
        List<OrderItem> updatedOrderItemList = OrderHelper.checkRecalcOrderItems(this.oldMap, this.newMap);
        update updatedOrderItemList;
    }


}
