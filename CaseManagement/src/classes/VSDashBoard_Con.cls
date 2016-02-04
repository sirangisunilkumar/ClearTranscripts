public without sharing class VSDashBoard_Con {

    public List<Case> displayCases {get;set;}

    public void displayList() {        
        String condition = ApexPages.currentPage().getParameters().get('view');
        if(condition == 'AllInward')
            displayCases = getInwardCases();
        else if(condition == 'AllOutward')
            displayCases = getOutwardCases();
        else if(condition == 'InwardInProgress')
            displayCases = getInwardProgressCases();
        else if(condition == 'OutwardInProgress')
            displayCases = getOutwardProgressCases();
        else if(condition == 'OutwardArchived')
            displayCases = getOutwardClosedCases();
        else if(condition == 'InwardArchived')
            displayCases = getInwardClosedCases();
            system.debug('***condition:'+condition);
            system.debug('***displayCases:'+displayCases);
    }

    public String name {get;set;}
    public String renderVariable {get;set;}
    public String selectedCaseId {get;set;}    
    public User u;
    public Account a;
    public Profile p;
    public VSDashBoard_Con(){
        displayCases = new List<Case>();
        u = [Select id,RelatedAccount__c,ProfileId FROM User where id=:UserInfo.getUserId()];
        system.debug('****Name:'+u.RelatedAccount__c);
        p = [Select Name from Profile where id=:u.ProfileId];
        if(p.name != 'System Administrator'){
            a = [Select id,name From Account where name = :u.RelatedAccount__c];
            name = u.RelatedAccount__c;
        }    
    }
    
    public List<Case> getInwardCases(){
        return [SELECT id,CaseNumber,Status,Student_Name__c,Register_Number__c,Course_Name__c FROM Case WHERE Case.To_Account__r.name=:u.RelatedAccount__c];
    }
    
    public List<Case> getInwardProgressCases(){
        return [SELECT id,CaseNumber,Status,Student_Name__c,Register_Number__c,Course_Name__c FROM Case WHERE Case.To_Account__r.name=:u.RelatedAccount__c AND Status <> 'Archived' AND Status <> 'Created'];
    }
    
    public List<Case> getInwardClosedCases(){
        return [SELECT id,CaseNumber,Status,Student_Name__c,Register_Number__c,Course_Name__c FROM Case WHERE Case.To_Account__r.name=:u.RelatedAccount__c AND Status = 'Archived'];
    }
    
    public List<Case> getOutwardCases(){
        return [SELECT id,CaseNumber,Status,Student_Name__c,Register_Number__c,Course_Name__c FROM Case WHERE Case.From_Account__r.name=:u.RelatedAccount__c];
    }
    
    public List<Case> getOutwardProgressCases(){
        return [SELECT id,CaseNumber,Status,Student_Name__c,Register_Number__c,Course_Name__c FROM Case WHERE Case.From_Account__r.name=:u.RelatedAccount__c AND Status <> 'Archived' AND Status <> 'Created'];
    }
    
    public List<Case> getOutwardClosedCases(){
        return [SELECT id,CaseNumber,Status,Student_Name__c,Register_Number__c,Course_Name__c FROM Case WHERE Case.From_Account__r.name=:u.RelatedAccount__c AND Status = 'Archived'];
    }  
      
    public PageReference navigateAplication(){
        PageReference pg = new PageReference('/apex/OutwardAplicationPage');
        pg.getParameters().put('aid', a.id);        
        pg.setRedirect(true);
        return pg;
    }
    public PageReference redirectAplicationOverview(){
        PageReference pg = new PageReference('/apex/AplicationOverview');
        pg.getParameters().put('view', renderVariable);
        pg.setRedirect(true);
        return pg;    
    }
    public PageReference redirectInwardAplicationOverview(){
        system.debug('***selectedCaseId'+selectedCaseId);
        Case c = [Select From_Account__c,To_Account__c FROM Case where id =: selectedCaseId];
        system.debug('***a.name'+a.name);
        system.debug('***u.RelatedAccount__c'+u.RelatedAccount__c);
        if(a.id != c.From_Account__c && a.id == c.To_Account__c){        
            PageReference pg = new PageReference('/apex/InwardAplicationDetailPage?id='+selectedCaseId);
            //pg.getParameters().put('id', selectedCaseId);
            pg.setRedirect(true);
            return pg; 
        } 
        else{
            PageReference pg1 = new PageReference('/apex/AplicationDetailPage?id='+selectedCaseId);
            //pg1.getParameters().put('id', selectedCaseId);
            pg1.setRedirect(true);
            return pg1;
        
        }  
    }
}