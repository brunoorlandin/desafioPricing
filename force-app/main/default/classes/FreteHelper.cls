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

    public static void checkDuplicates(List<Frete__c> freteList){
        List<Frete__c> currentData = [
            SELECT Name, CentroDistribuicao__c, Cidade__c, Estado__c, HierarquiaProduto__c, Pais__c, Produto__c, Status__c, Valor__c
            FROM Frete__c
        ];

        for(Frete__c newFrete : freteList){
            for(Frete__c currentFrete : currentData){
                if(newFrete.Name == currentFrete.Name){
                    newFrete.addError(Label.FreteDuplicado);
                }
                else if(
                    newFrete.CentroDistribuicao__c == currentFrete.CentroDistribuicao__c &&
                    (
                        newFrete.Cidade__c == currentFrete.Cidade__c ||
                        newFrete.Estado__c == currentFrete.Estado__c ||
                        newFrete.Pais__c == currentFrete.Pais__c
                    ) &&
                    (
                        newFrete.Produto__c == currentFrete.Produto__c ||
                        newFrete.HierarquiaProduto__c == currentFrete.HierarquiaProduto__c
                    )
                ){
                    newFrete.addError(Label.FreteDuplicado);
                }
            }
        }
    }

    public static void calculateScore(List<Frete__c> freteList){
        for(Frete__c frete : freteList){
            Integer score = 0;

            if(frete.Produto__c != null){
                score += 2000;
            }

            if(frete.HierarquiaProduto__c != null){
                score += 1000;
            }

            if(frete.Cidade__c != null){
                score += 30;
            }
            
            if(frete.Estado__c != null){
                score += 20;
            }

            if(frete.Pais__c != null){
                score += 10;
            }

            frete.Score__c = score;
        }
    }
}
