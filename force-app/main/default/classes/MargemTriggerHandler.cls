public with sharing class MargemTriggerHandler {
    List<Margem__c> oldRecords {get; set;}
    List<Margem__c> newRecords {get; set;}
    Map<Id, Margem__c> oldMap {get; set;}
    Map<Id, Margem__c> newMap {get; set;}

    public MargemTriggerHandler(
        List<Margem__c> oldRecords, 
        List<Margem__c> newRecords, 
        Map<Id, Margem__c> oldMap, 
        Map<Id, Margem__c> newMap) {
        this.oldRecords = oldRecords;
        this.newRecords = newRecords;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public void beforeInsert(){
        MargemHelper.checkMandatoryFields(this.newRecords);
        MargemHelper.checkDuplicates(this.newRecords);
    }

    public void beforeUpdate(){
        MargemHelper.checkMandatoryFields(this.newRecords);
    }
}