trigger MargemTrigger on Margem__c (
  before insert,
  before update) {
  MargemTriggerHandler handler = new MargemTriggerHandler(
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