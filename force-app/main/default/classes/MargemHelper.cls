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
                System.debug('Conta e grupo conta vazios');
                System.debug('Margem: ' + margem);
                margem.addError(System.Label.ContaGrupoContaInvalido);
            }
            else if(margem.GrupoConta__c != null && margem.Conta__c != null){
                System.debug('Conta ou grupo conta vazios');
                System.debug('Margem: ' + margem);
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

    public static void checkDuplicates(List<Margem__c> margemList){
        List<Margem__c> currentData = [
            SELECT Name, Conta__c, GrupoConta__c, CentroDistribuicao__c, Cidade__c, Estado__c, HierarquiaProduto__c, Pais__c, Produto__c, Status__c, Valor__c
            FROM Margem__c
        ];

        for(Margem__c newMargem : margemList){
            for(Margem__c currentMargem : currentData){
                if(newMargem.Name == currentMargem.Name){
                    newMargem.addError(System.Label.MargemDuplicada);
                }
                else if(
                    newMargem.CentroDistribuicao__c == currentMargem.CentroDistribuicao__c &&
                    (
                        newMargem.Conta__c == currentMargem.Conta__c 
                    ) &&
                    (
                        newMargem.Cidade__c == currentMargem.Cidade__c ||
                        newMargem.Estado__c == currentMargem.Estado__c ||
                        newMargem.Pais__c == currentMargem.Pais__c
                    ) &&
                    (
                        newMargem.Produto__c == currentMargem.Produto__c 
                    )
                ){
                    newMargem.addError(System.Label.MargemDuplicada);
                }
            }
        }
    }

    public static void calculateScore(List<Margem__c> margemList){
        for(Margem__c margem : margemList){
            Integer score = 0;

            if(margem.Produto__c != null){
                score += 2000;
            }

            if(margem.HierarquiaProduto__c != null){
                score += 1000;
            }

            if(margem.Conta__c != null){
                score += 200;
            }

            if(margem.GrupoConta__c != null){
                score += 100;
            }

            if(margem.Cidade__c != null){
                score += 30;
            }
            
            if(margem.Estado__c != null){
                score += 20;
            }

            if(margem.Pais__c != null){
                score += 10;
            }

            margem.Score__c = score;
        }
    }
}
