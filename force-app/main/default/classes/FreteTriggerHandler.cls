public with sharing class FreteTriggerHandler {
    List<Frete__c> oldRecords {get; set;}
    List<Frete__c> newRecords {get; set;}
    Map<Id, Frete__c> oldMap {get; set;}
    Map<Id, Frete__c> newMap {get; set;}
    
    public FreteTriggerHandler(
        List<Frete__c> oldRecords, 
        List<Frete__c> newRecords, 
        Map<Id, Frete__c> oldMap, 
        Map<Id, Frete__c> newMap) {
        this.oldRecords = oldRecords;
        this.newRecords = newRecords;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public void beforeInsert(){
        FreteHelper.checkMandatoryFields(this.newRecords);
        FreteHelper.checkDuplicates(this.newRecords);
        FreteHelper.calculateScore(this.newRecords);
    }

    public void beforeUpdate(){
        FreteHelper.checkMandatoryFields(this.newRecords);
        FreteHelper.calculateScore(this.newRecords);
    }
}
