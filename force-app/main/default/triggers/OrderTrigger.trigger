trigger OrderTrigger on Order (before insert, before update) {
  OrderTriggerHandler handler = new OrderTriggerHandler(
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