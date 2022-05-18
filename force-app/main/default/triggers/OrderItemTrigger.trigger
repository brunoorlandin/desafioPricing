trigger OrderItemTrigger on OrderItem (before insert, before update) {
  OrderItemTriggerHandler handler = new OrderItemTriggerHandler(
      Trigger.old,
      Trigger.new,
      Trigger.oldMap,
      Trigger.newMap
  );

  switch on Trigger.operationType{
      when BEFORE_INSERT{
          handler.beforeInsert();
      }
      when BEFORE_UPDATE{
        handler.beforeUpdate();
    }
  }

}