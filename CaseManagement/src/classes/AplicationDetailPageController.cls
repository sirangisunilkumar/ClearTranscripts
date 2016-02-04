public class AplicationDetailPageController {
    ApexPages.StandardController controller;
    public Id caseId;
    public Case cse;    
    public Boolean editFlag {get;set;}
    Approval.ProcessResult result;
    public AplicationDetailPageController(ApexPages.StandardController controller) {
        this.cse = (Case)controller.getRecord();
        this.controller = controller;
        caseId = ApexPages.currentPage().getParameters().get('id');
        editFlag = false;
    }
    public void Edit(){
        editFlag  = true;
    }
    
    public PageReference Save(){
        controller.save();
        PageReference pgr = new PageReference('/apex/AplicationDetailPage?id='+caseId);
            pgr.setRedirect(true);
            return pgr;
        
    }
    public PageReference submit(){
        try{
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitted for Approval');
            req1.setObjectID(caseId);
          // Submit the approval request for the account
           result = Approval.process (req1); 
           System.debug('******'+result.isSuccess()); 
           System.debug('******'+result.getInstanceStatus());
        
       }
       catch(Exception e){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Approval Process FOund');//Same old drama 
           ApexPages.addMessage(myMsg);
       }
           if(result.isSuccess()){
           PageReference pgr = new PageReference('/apex/AplicationDetailPage?id='+caseId);
            pgr.setRedirect(true);
            return pgr;
            }
            else
            return null;
    }
     public PageReference Approve(){
        List<ProcessInstanceWorkitem > listAprovacoes = [Select Id,ProcessInstanceId, OriginalActorId, CreatedDate, CreatedById, ActorId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: caseId  ORDER BY CreatedDate desc limit 1];
        ProcessInstanceWorkitem lWorkItem;
        lWorkItem = listAprovacoes[0];
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Approved by Manager');
        req.setAction('Approve');
        req.setWorkitemId( lWorkItem.Id );
        Approval.ProcessResult result = Approval.process( req );
        PageReference pgr = new PageReference('/apex/AplicationDetailPage?id='+caseId);
            pgr.setRedirect(true);
            return pgr;
    }
    
    public PageReference Reject(){
       List< ProcessInstanceWorkitem > listAprovacoes = [Select Id,ProcessInstanceId, OriginalActorId, CreatedDate, CreatedById, ActorId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: caseId  ORDER BY CreatedDate desc limit 1];
        ProcessInstanceWorkitem lWorkItem;
        lWorkItem = listAprovacoes[0];
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Rejected by Manager');
        req.setAction('Reject');
        req.setWorkitemId( lWorkItem.Id );
        Approval.ProcessResult result = Approval.process( req );
        PageReference pgr = new PageReference('/apex/AplicationDetailPage?id='+caseId);
            pgr.setRedirect(true);
            return pgr;       
    }    
}