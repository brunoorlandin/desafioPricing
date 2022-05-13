public with sharing class ImpostoHelper {
    public ImpostoHelper() {}

    public static void validateFields(List<Imposto__c> impostoList){
        for(Imposto__c imposto : impostoList){
            if(imposto.Produto__c == null){
                imposto.addError(System.Label.ProdutoVazio);
            }
        }
    }
    
    public static void checkDuplicates(List<Imposto__c> impostoList){
        List<Imposto__c> currentData = [
            SELECT Name, CentroDistribuicao__c, Estado__c, Produto__c, Status__c
            FROM Imposto__c
        ];

        for(Imposto__c newImposto : impostoList){
            for(Imposto__c currentImposto : currentData){
                if(newImposto.Name == currentImposto.Name){
                    newImposto.addError(Label.ImpostoDuplicado);
                }
                else if(
                    newImposto.CentroDistribuicao__c == currentImposto.CentroDistribuicao__c &&
                    newImposto.Estado__c == currentImposto.Estado__c
                ){
                    newImposto.addError(Label.ImpostoDuplicado);
                }
            }
        }
    } 
}
