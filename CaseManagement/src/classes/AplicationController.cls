public class AplicationController {
    ApexPages.StandardController controller;
    public String accId{get;set;}
    public Account acc{get;set;}
    public Case cse;
    public AplicationController(ApexPages.StandardController controller){
        this.cse = (Case)controller.getRecord();
        this.controller = controller;
        accId = ApexPages.currentPage().getParameters().get('aid');
        acc = [Select id,name from Account where id=:accId]; 
    }
    public PageReference Save(){
        PageReference pgr;
        String result = null;
        try {
            cse.From_Account__c = acc.id;
            controller.save();
            result = controller.getId();
        }
        catch(Exception e) {
            return null;
        }
        if(result <> null){
            pgr = new PageReference('/apex/AplicationDetailPage?id='+result);
            pgr.setRedirect(true);
            return pgr;
        }
        else{
            return null;
        }
    }
    
}