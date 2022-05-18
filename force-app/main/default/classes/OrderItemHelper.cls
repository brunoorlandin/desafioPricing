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
}
