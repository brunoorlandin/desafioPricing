public with sharing class FreteHelper {
    public FreteHelper() {}

    public static void checkMandatoryFields(
        List<Frete__c> freteList
    ){
        System.debug(freteList);

        for(Frete__c frete : freteList){
            if(frete.HierarquiaProduto__c == null && frete.Produto__c == null){
                frete.addError(Label.FreteInvalidoProdutoHierarquia);
            }
            else if(frete.HierarquiaProduto__c != null && frete.Produto__c != null){
                frete.addError(Label.FreteInvalidoProdutoHierarquia);
            }

            if(frete.Cidade__c == null && frete.Estado__c == null && frete.Pais__c == null){
                frete.addError(Label.FreteInvalidoLocalidade);
            }
            else if(frete.Cidade__c != null && frete.Estado__c != null){
                frete.addError(Label.FreteInvalidoLocalidade);
            }
            else if(frete.Cidade__c != null && frete.Pais__c != null){
                frete.addError(Label.FreteInvalidoLocalidade);
            }
            else if(frete.Estado__c != null && frete.Pais__c != null){
                frete.addError(Label.FreteInvalidoLocalidade);
            }
        }
    }
}
