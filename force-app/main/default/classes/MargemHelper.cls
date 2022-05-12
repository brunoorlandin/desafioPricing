public with sharing class MargemHelper {
    public MargemHelper() {}

    public static void checkMandatoryFields(List<Margem__c> margemList){
        for(Margem__c margem : margemList){
            if(margem.HierarquiaProduto__c == null && margem.Produto__c == null){
                margem.addError(System.Label.InvalidoProdutoHierarquia);
            }
            else if(margem.HierarquiaProduto__c != null && margem.Produto__c != null){
                margem.addError(System.Label.InvalidoProdutoHierarquia);
            }

            if(margem.GrupoConta__c == null && margem.Conta__c == null){
                margem.addError(System.Label.ContaGrupoContaInvalido);
            }
            else if(margem.GrupoConta__c != null && margem.Conta__c != null){
                margem.addError(System.Label.ContaGrupoContaInvalido);
            }

            if(margem.Cidade__c == null && margem.Estado__c == null && margem.Pais__c == null){
                margem.addError(System.Label.InvalidoLocalidade);
            }
            else if(margem.Cidade__c != null && margem.Estado__c != null){
                margem.addError(System.Label.InvalidoLocalidade);
            }
            else if(margem.Cidade__c != null && margem.Pais__c != null){
                margem.addError(System.Label.InvalidoLocalidade);
            }
            else if(margem.Estado__c != null && margem.Pais__c != null){
                margem.addError(System.Label.InvalidoLocalidade);
            }
        } 
    }
}
