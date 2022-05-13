trigger ImpostoTrigger on Imposto__c (before insert, before update) {
  ImpostoTriggerHandler handler = new ImpostoTriggerHandler(
    Trigger.new,
    Trigger.old,
    Trigger.newMap,
    Trigger.oldMap
  );

  switch on Trigger.operationType {
    when BEFORE_INSERT{
      handler.beforeInsert();
    }
    when BEFORE_UPDATE{
      handler.beforeUpdate();
    }
  }
}