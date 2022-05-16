trigger FreteTrigger on Frete__c (
  before insert, 
  before update, 
  after insert, 
  after update){
  FreteTriggerHandler handler = new FreteTriggerHandler(
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
    when AFTER_INSERT{
      handler.afterInsert();
    }
    when AFTER_UPDATE{
      handler.afterUpdate();
    }
  }
}