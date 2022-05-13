public with sharing class ImpostoTriggerHandler {
    List<Imposto__c> oldRecords {get; set;}
    List<Imposto__c> newRecords {get; set;}
    Map<Id, Imposto__c> oldMap {get; set;}
    Map<Id, Imposto__c> newMap {get; set;}

    public ImpostoTriggerHandler(
        List<Imposto__c> newRecords,
        List<Imposto__c> oldRecords,
        Map<Id, Imposto__c> newMap,
        Map<Id, Imposto__c> oldMap) {
        this.newRecords = newRecords;
        this.oldRecords = oldRecords;
        this.newMap = newMap;
        this.oldMap = oldMap;
    }

    public void beforeInsert(){
        ImpostoHelper.checkDuplicates(this.newRecords);
        ImpostoHelper.validateFields(this.newRecords);
    }

    public void beforeUpdate(){
        ImpostoHelper.validateFields(this.newRecords);
    }
}
